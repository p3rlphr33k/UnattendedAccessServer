#!/usr/bin/perl
use DBI;
use Digest::MD5 qw(md5 md5_hex md5_base64);

print "Content-Type:text/html\n\n";
###############################################################

$MySQLServer		= 'localhost';		# MySQL Server IP
$MySQLPort			= 3306;				# MySQL Server Port (default 3306)
$MySQLUsername		= 'YOURUSER';			# MySQL username
$MySQLPassword		= 'YOURPASS';	# MySQL password
$MySQLDatabase		= 'YOURDB';	# MySQL Database name

################################################################

### SETUP SQL CONNECTIONS:	
$dsn = "DBI:mysql:database=$MySQLDatabase;host=$MySQLServer";
$dbh=DBI->connect($dsn,$MySQLUsername,$MySQLPassword) or print $DBI::errstr;

################################################################

$in = $ENV{'QUERY_STRING'};
$IP = $ENV{'REMOTE_ADDR'};
	
@in = split(/&/,$in);
foreach $kv (@in)
	{
	($k,$v) = split(/=/, $kv);
	$k =~ tr/+/ /;
	$v =~ tr/+/ /;
	$k =~ s/(%[a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/ge;
	$v =~ s/(%[a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/ge;
	${$k} = $v;	
	}

$MyCMD1 = "SELECT id,account,command,updated,sessionid FROM machines WHERE hostname=? LIMIT 1";
$MyCMD2 = "INSERT INTO machines (hostname,IP,sessionid) VALUES (?,?,?)";
$MyCMD3 = "SELECT id,email,password FROM accounts WHERE email=? AND password=? LIMIT 1";

## CREATE RANDOM 10 DIGIT VNC SESSION ID

sub sessionNum {

@Chars = ('1'..'9');
$Length = 100;
$Number = '';

for (1..$Length) {
$Number .= $Chars[int rand @Chars];
}
return $Number;
}

$sth1 = $dbh->prepare("$MyCMD1") or print "Error preparing: " .$DBI::errstr . "\n";
$sth1->execute("$hostname") or print "Error Executing: " .$DBI::errstr . "\n";

$thisCount=0;

while(@row1 = $sth1->fetchrow_array()){
	($id,$account,$command,$updated,$sessionid) = @row1;
	$thisCount++;
}

if(!$id) {
	$SessionID = &sessionNum;
	$sth2 = $dbh->prepare("$MyCMD2") or die $DBI::errstr;
	$sth2->execute("$hostname","$IP","$SessionID") or die $DBI::errstr;
	$sth2->finish();

	$sth1 = $dbh->prepare("$MyCMD1") or print "Error preparing: " .$DBI::errstr . "\n";
	$sth1->execute("$hostname") or print "Error Executing: " .$DBI::errstr . "\n";

	while(@row1 = $sth1->fetchrow_array()){
        ($id,$account,$command,$updated) = @row1;
        $thisCount++;
	}
}

print "ID:$id, ACCT:$account, CMD:$command, UPDATED:$updated, SESSIONID: $sessionid\n";
if($thisCount > 0) {

	$myenc = md5_hex($pwd);
	$sth3 = $dbh->prepare("$MyCMD3") or die "Error preparing: " .$DBI::errstr . "\n";
	$sth3->execute("$email","$myenc") or die "Error Executing: " .$DBI::errstr . "\n";
	($aid,$auser,$apword) = $sth3->fetchrow_array();
	$sth3->finish();

	if($aid && $auser && $apword) {
		$MyCMD2 = "UPDATE machines SET account=?,IP='".$IP."',updated=current_timestamp,command='' WHERE hostname = ?";
		$sth2 = $dbh->prepare("$MyCMD2") or die "Error preparing: " .$DBI::errstr . "\n";
		$sth2->execute("$aid","$hostname") or die "Error Executing: " .$DBI::errstr . "\n";
		$sth2->finish();
	}
	else {
		$MyCMD2 = "UPDATE machines SET IP='".$IP."',updated=current_timestamp,command='' WHERE hostname = ?";
		$sth2 = $dbh->prepare("$MyCMD2") or die "Error preparing: " .$DBI::errstr . "\n";
		$sth2->execute("$hostname") or die "Error Executing: " .$DBI::errstr . "\n";
		$sth2->finish();
	}
	
	if($command) {
		print "status=ONLINE&updated=$updated&execute=$command";
	}
	else {
		print "status=ONLINE&updated=$updated";
	}
}

################################################################

## CLOSE SQL CONNECTIONS
$dbh->disconnect();
exit;
