package config;
# Extend the config file for all parameters
# This includes MySQL connection info
# This file will get replaced with a JSON solution

$IP = 'supervene.com'; # ip address of repeater
$PORT = '5500'; # server listening port of repeater (YOUR client)
$VIEW = '5900'; # viewer listening port of repeater (tech support agent)
$FILENAME = "support.exe"; # filename to be sent to user to download
$TMP = '/var/www/html/tmp'; # location of temporary folder (must be writable by webserver), DON'T include trailing slash
$FILE7Z = '/var/www/html/7zip/bin/7za'; # 7zip executable filename '7za' or '7zr'
$REP = 'support specialist'; # name of support tech (shown in balloon message box on client)

1;
