#!/bin/bash
#chkconfig: 345 80 05
nohup perl vnc_repeater.pl -l /var/log/vnc_repeater.log &
nohup /var/www/www.supervene.com/web/rs/novnc/utils/launch.sh --vnc localhost:5900 --cert /var/www/www.supervene.com/ssl/supervene.com.pem /var/log/no_vnc.log &
