#!/bin/bash
#chkconfig: 345 80 05
# certificate .pem file is made up of certificate.csr + certificate.crt 
# command: "cat cert.csr cert.crt > cert.pem"

nohup perl vnc_repeater.pl -l /var/log/vnc_repeater.log &
nohup /var/www/html/novnc/utils/launch.sh --vnc localhost:5900 --cert /var/www/ssl/certificate.pem /var/log/no_vnc.log &
