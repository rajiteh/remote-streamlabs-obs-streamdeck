
param (
    [int]$tunnelPort = 29999, 
    [string]$slobsHost = "",
    [string]$mode = $(throw "-mode is required.")
)


$tcptunnelBin="$PSScriptRoot\tcptunnel-0.8\tcptunnel.exe"

function StreamlabsHost {
    $slobsPortStart=28194
    $slobsPortEnd=28199
    $slobsListenerProcess="Streamlabs OBS"
    
    while ($true) {
        $listeningConnections = Get-NetTCPConnection -State Listen 
        $slobsPort=$null;
        for ($i=$slobsPortStart; $i -le $slobsPortEnd; $i=$i+1 ) {
            $connection= $listeningConnections | where Localport -eq $i;
            if ($connection -ne $null) {
                $processId=$connection.OwningProcess
                $process=(Get-Process -Id $processId).ProcessName
                if ($process.StartsWith($slobsListenerProcess)) {
                    write-host "SLOBS (pid:$processId) found listening on port $i"
                    $slobsPort=$i
                    break
                }
            }
        }
        if ($slobsPort -ne $null) {
            $tcptunnelArgs="--local-port=$tunnelPort --bind-address=0.0.0.0 --remote-host=127.0.0.1 --remote-port=$slobsPort"
            write-host "Args: $tcptunnelArgs"
            Invoke-Expression "$tcptunnelBin $tcptunnelArgs"
        } else {
            write-host "No listening ports created by SLOBS."
        }
        write-host "Waiting for 30 seconds and retrying..."
        Start-Sleep -Seconds 30
    }
}

function StreamlabsRemote {
   $slobsListenPort=28194
   $tcptunnelArgs="--local-port=$slobsListenPort --bind-address=127.0.0.1 --remote-host=$slobsHost --remote-port=$tunnelPort"
   write-host "Args: $tcptunnelArgs"
   Invoke-Expression "$tcptunnelBin $tcptunnelArgs"
}


if ($mode.Equals("remote")) {
    if ($slobsHost.Equals("")) {
        throw "-slobsHost must be set when mode is remote" 
    }
    write-host "Starting in remote mode connecting to ${slobsHost}:${tunnelPort}"
    StreamlabsRemote
} elseif ($mode.Equals("host")) {
    write-host "Starting in host mode and exposing tunnel on port ${tunnelPort}"
    StreamlabsHost
}
