#!/usr/bin/perl
use DBI;
use Digest::MD5 qw(md5 md5_hex md5_base64);

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

#print "Content-Type: Text/HTML\n\n";

$in = <STDIN>;

@in = split(/&/, $in);
foreach $kv (@in){
	($k,$v) = split(/=/, $kv);
	$k =~ tr/+/ /;
	$v =~ tr/+/ /;
	$k =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
	$v =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
	${$k} = $v; 
#	print "$k = $v<br>";
}

$MyCMD1 = "SELECT id,email,password FROM accounts WHERE email=? LIMIT 1";

if($acctid && $md5hash) {

	$sth1 = $dbh->prepare("$MyCMD1") or die $DBI::errstr;
	$sth1->execute("$acctid") or die $DBI::errstr;
	($id,$email,$password) = $sth1->fetchrow_array();
	$sth1->finish();
	$dbh->disconnect();

	#print "email: $email<br>\npassword: $password<br>\n";
	if($acctid eq $email && $md5hash eq $password) {
		$session = md5_hex("$email$password");
		print "Location: /cgi-bin/rs/clients.pl?acctid=$id&session=$session\n\n";
	}
	else {
		$err = "Invalid login.";
		print "Location: /cgi-bin/rs/LoginForm.pl?err=$err\n\n";
	}
}
else {
	if($acctid && $session) {
		$session = md5_hex("$session");
                print "Location: /cgi-bin/rs/clients.pl?acctid=$id&session=$session\n\n";	
	}
	else {
		$err = "Invalid login.";
		print "Location: /cgi-bin/rs/LoginForm.pl?err=$err\n\n";
	}
}
