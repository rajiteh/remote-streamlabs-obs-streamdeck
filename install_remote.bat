@ECHO OFF

Rem SET STREAMLABS HOST PC ADDRESS HERE
set slobsHost=10.1.1.174
Rem SET TUNNEL PORT AS SET ON THE HOST
set tunnelPort=29999

pushd %~dp0
set nssm=%CD%\nssm-2.24\nssm.exe
set tcptunnel=%CD%\tcptunnel-0.8\tcptunnel.exe
set ps_script=%CD%\remote-slobs.ps1
popd

set service_name=com.rajiteh.remoteslobs.remote
%nssm% install %service_name% powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%ps_script%"  -mode remote -tunnelPort %tunnelPort% -slobsHost %slobsHost%
%nssm% set %service_name% AppThrottle 2000
%nssm% set %service_name% AppExit Default Restart
%nssm% set %service_name% AppRestartDelay 0

sc start %service_name%