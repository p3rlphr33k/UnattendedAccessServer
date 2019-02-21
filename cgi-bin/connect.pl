#!/usr/bin/perl -W
use CGI;
use DBI;

###############################################################

$MySQLServer		= 'localhost';		# MySQL Server IP
#$MySQLPort			= 3306;				# MySQL Server Port (default 3306)
$MySQLUsername		= 'YOURUSER';			# MySQL username
$MySQLPassword		= 'YOURPASS';	# MySQL password
$MySQLDatabase		= 'YOURDB';	# MySQL Database name

################################################################

### SETUP SQL CONNECTIONS:	
$dsn = "DBI:mysql:database=$MySQLDatabase;host=$MySQLServer";
$dbh=DBI->connect($dsn,$MySQLUsername,$MySQLPassword) or print $DBI::errstr;

################################################################

$in = $ENV{'QUERY_STRING'};

@in = split(/&/, $in);
foreach $kv (@in){
	($k,$v) = split(/=/, $kv);
	$k =~ tr/+/ /;
	$v =~ tr/+/ /;
	$k =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
	$v =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
	${$k} = $v; 
	#print "$k = $v<br>";
}


if($session && $acctid && $id) {
$MyCMD1 = "UPDATE machines SET command=? WHERE account=? AND hostname=? LIMIT 1";

## ADDED TO TEST NEW CLIENT
#if($id eq 'BRYAN-HP') {
#	$vncCMD = 'sc start uvnc_service';
#}
#else {
	$vncCMD = "winvnc.exe -id $session -connect supervene.com::5500 -noregistry";
#}

## ORIGINAL COMMAND:
#$vncCMD = "winvnc.exe -id $session -connect supervene.com::5500 -noregistry";

$sth1 = $dbh->prepare("$MyCMD1") or print "Error preparing: " .$DBI::errstr . "\n";
$sth1->execute("$vncCMD","$acctid","$id") or print "Error Executing: " .$DBI::errstr . "\n";
$sth1->finish();

## CLOSE SQL CONNECTIONS
$dbh->disconnect();

$connectString = "https://supervene.com/rs/novnc/vnc.html?host=supervene.com&port=6080&encrypt=1&logging=debug&true_color=0&stylesheet=default&clip=true&resize=scale&cursor=true&shared=true&repeaterID=ID:$session";
$q = new CGI;
print $q->redirect($connectString);
}

else {
print "Content-Type: Text/HTML\n\n";

print qq|
<!DOCTYPE html>
<html lang="en-us">
<head>
<meta charset="utf-8" />
<title>Supervene Remote Support</title>
</head>
<body>
That's strange, no session was found.<br>Close this window and try again. Maybe that will help.
</body>
</html>
|;
exit;
}
