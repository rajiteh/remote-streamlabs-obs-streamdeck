@ECHO OFF

Rem SET TUNNEL PORT TO BE EXPOSED 
set tunnelPort=29999
Rem TODO: SET REMOTE HOST IPS 
REM set remoteHosts=

pushd %~dp0
set nssm=%CD%\nssm-2.24\nssm.exe
set tcptunnel=%CD%\tcptunnel-0.8\tcptunnel.exe
set ps_script=%CD%\remote-slobs.ps1
popd

set service_name=com.rajiteh.remoteslobs.host
%nssm% install %service_name% powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%ps_script%" -mode host -tunnelPort %tunnelPort%
%nssm% set %service_name% AppThrottle 2000
%nssm% set %service_name% AppExit Default Restart
%nssm% set %service_name% AppRestartDelay 0

Rem TODO: Make only accept conections from trusted IP
netsh advfirewall firewall add rule name="%service_name%" dir=in program="%tcptunnel%" profile=any action=allow protocol=TCP localport=%tunnelPort%

sc start %service_name%