
$tunnelPort=29999
$slobsHost="10.1.1.174"
$tcptunnelBin="$PSScriptRoot\tcptunnel\tcptunnel.exe"

function StreamlabsHost {
    $slobsPortStart=28194
    $slobsPortEnd=28199
    $slobsListenerProcess="Streamlabs OBS"
    $listeningConnections = Get-NetTCPConnection -State Listen 
    
    for ($i=$slobsPortStart; $i -le $slobsPortEnd; $i=$i+1 ) {
        $connection= $listeningConnections | where Localport -eq $i;
        if ($connection -ne $null) {
            $processId=$connection.OwningProcess
            $process=(Get-Process -Id $processId).ProcessName
            if ($process.StartsWith($slobsListenerProcess)) {
                $tcptunnelArgs="--local-port=$tunnelPort --bind-address=0.0.0.0 --remote-host=127.0.0.1 --remote-port=$i"
                write-host "tcptunnel.exe $tcptunnelArgs"
                Invoke-Expression "$tcptunnelBin $tcptunnelArgs"
            }
        }
    }
    write-host "No ports found or tunnel crashed"

}

function StreamlabsRemote {
   $slobsListenPort=28194
   $tcptunnelArgs="--local-port=$slobsListenPort --bind-address=127.0.0.1 --remote-host=$slobsHost --remote-port=$tunnelPort"
   write-host "$tcptunnelArgs"
   Invoke-Expression "$tcptunnelBin $tcptunnelArgs"
}

StreamlabsHost

#StreamlabsRemote
