#!/usr/bin/perl
use config;

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
	open(HostHandle, "< /var/www/www.supervene.com/web/rs/host/config_default.txt") or die $!;
	@HostConfig  = <HostHandle>;
	close(HostHandle);
	
	foreach $line (@HostConfig) {
		$line =~ s/::IP::/$config::IP/;
		$line =~ s/::PORT::/$config::PORT/;
		$line =~ s/::ID::/$sessionKey/;
	}
	
	open(HostFile, "> /var/www/www.supervene.com/web/rs/host/config.txt") or die $!;
	print HostFile @HostConfig;
	close(HostFile);

	$TMP = $config::TMP;
	$FILENAME = $config::FILENAME;
	#$FILE7Z = $config::FILE7Z;
	
	@cmds = (
		"cat /var/www/www.supervene.com/web/rs/support/7zS.sfx /var/www/www.supervene.com/web/rs/host/config.txt /var/www/www.supervene.com/web/rs/host/vncviewer.7z > $TMP/h$sessionKey.exe",
		"chmod 0777 $TMP/c$sessionKey.exe",
		"cp $TMP/h$sessionKey.exe /var/www/www.supervene.com/web/rs/built/",
		"rm $TMP/h$sessionKey.exe"
	);
	
	for $cmd (@cmds) {
		$ret = `$cmd`;
	}
	
	if(-e "/var/www/www.supervene.com/web/rs/built/h$sessionKey.exe") {

		print "Content-Type:application/octet-stream\n";
		print "Content-Disposition:attachment;filename=$FILENAME\n\n";

		open(DOWNLOAD, "< /var/www/www.supervene.com/web/rs/built/h$sessionKey.exe") or die "can't open : $!";
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
