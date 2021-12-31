@ECHO OFF
set service_name=com.rajiteh.remoteslobs.host
sc delete %service_name%
netsh advfirewall firewall delete rule name="%service_name%"