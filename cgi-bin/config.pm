package config;

$IP = 'supervene.com'; # ip address of repeater
$PORT = '5500'; # server listening port of repeater (YOUR client)
$VIEW = '5900'; # viewer listening port of repeater (tech support agent)
$FILENAME = "support.exe"; # filename to be sent to user to download
$TMP = '/var/www/www.supervene.com/web/rs/tmp'; # location of temporary folder (must be writable by webserver), DON'T include trailing slash
$FILE7Z = '/var/www/www.supervene.com/web/rs/7zip/bin/7za'; # 7zip executable filename '7za' or '7zr'
$REP = 'support specialist'; # name of support tech (shown in balloon message box on client)

1;
