#!/usr/bin/perl

use config;

#print "Content-Type: text/html\n\n";

if($ENV{'REQUEST_METHOD'} eq 'POST') {
	$in = <STDIN>;
} else {
	$in = $ENV{'QUERY_STRING'};
}
@in = split(/&/, $in);
foreach $kv (@in) {
	($k, $v) = split(/=/, $kv);
	$k =~ tr/+/ /;
	$v =~ tr/+/ /;
	$k =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
	$v =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
	${$k} = $v;
}

if($sessionKey && $sessionKey ne '') {
	open(ClientHandle, "< /var/www/www.supervene.com/web/rs/client/helpdesk_default.txt") or die "unable to open helpdesk_defualt.txt: " . $!;
	@ClientConfig  = <ClientHandle>;
	close(ClientHandle);
	foreach $line (@ClientConfig) {
		$line =~ s/::IP::/$config::IP/;
		$line =~ s/::PORT::/$config::PORT/;
		$line =~ s/::REP::/$config::REP/;
		$line =~ s/::ID::/$sessionKey/;
	}
	open(ClientFile, "> /var/www/www.supervene.com/web/rs/client/helpdesk.txt") or die $!;
	print ClientFile @ClientConfig;
	close(ClientFile);

	$TMP = $config::TMP;
	$FILENAME = $config::FILENAME;
	#print "$FILENAME";
	$FILE7Z = $config::FILE7Z;

	@cmds = (
		"$FILE7Z a /var/www/www.supervene.com/web/rs/tmp/c$sessionKey.7z /var/www/www.supervene.com/web/rs/client/helpdesk.txt /var/www/www.supervene.com/web/rs/client/icon1.ico /var/www/www.supervene.com/web/rs/client/icon2.ico /var/www/www.supervene.com/web/rs/client/icon3.ico /var/www/www.supervene.com/web/rs/client/winvnc.exe",
		"chmod 0777 $TMP/c$sessionKey.7z",
		"cat /var/www/www.supervene.com/web/rs/support/7zS.sfx /var/www/www.supervene.com/web/rs/client/config.txt $TMP/c$sessionKey.7z > $TMP/c$sessionKey.exe",
		"chmod 0777 $TMP/c$sessionKey.exe",
		"cp $TMP/c$sessionKey.exe /var/www/www.supervene.com/web/rs/built/",
		"chmod 0777 /var/www/www.supervene.com/web/rs/built/c$sessionKey.exe",
		"rm $TMP/c$sessionKey.7z",
		"rm $TMP/c$sessionKey.exe",
		"rm $TMP/c$sessionKey.exe"
	);
	
	for $cmd (@cmds) {
		$ret = `$cmd`;
		#print $ret .'\n';
	}

	if(-e "/var/www/www.supervene.com/web/rs/built/c$sessionKey.exe") {

		print "Content-Type:application/octet-stream\n";
		print "Content-Disposition:attachment;filename=$FILENAME\n\n";

		open(DOWNLOAD, "< /var/www/www.supervene.com/web/rs/built/c$sessionKey.exe") or die $!;
		binmode DOWNLOAD;
		local $/ = \10240;
		while (<DOWNLOAD>){
		    print $_;
		}
		close DOWNLOAD;   
	}
	else {
		print "Location: /rs/error.html\n\n";
	}
}
else {
	print "Location: /rs/error.html\n\n";
}
