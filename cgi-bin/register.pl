#!/usr/bin/perl
use DBI;

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
	#print "$k = $v<br>";
}

#@months = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
@months = qw(01 02 03 04 05 06 07 08 09 10 11 12);
@days = qw(Sun Mon Tue Wed Thu Fri Sat Sun);

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
$year = $year + 1900;
$month = $months[$mon];
if($sec < 10) { $sec = "0$sec"; }
if($min < 10) { $min = "0$min"; }
if($hour < 10) { $hour = "0$hour"; }

$mystamp = "$year-$month-$mday $hour:$min:$sec\n"; # 2016-02-20 14:22:23

if($acctid && $md5hash) {

	$MyCMD1 = "SELECT email FROM accounts WHERE email=?";
	$MyCMD2 = "INSERT INTO accounts (email,password,created) VALUES (?,?,?)";

	$sth1 = $dbh->prepare("$MyCMD1") or die $DBI::errstr;
	$sth1->execute("$acctid") or die $DBI::errstr;
	$existing = $sth1->fetchrow_array();
	$sth1->finish();
	#print "Existing: $existing\n";
	if($existing ne $acctid) {
		$sth1 = $dbh->prepare("$MyCMD2") or die $DBI::errstr;
		$sth1->execute("$acctid","$md5hash","$mystamp") or die $DBI::errstr;
		$existing = $sth1->fetchrow_array();
		$sth1->finish();
		$err = "Registration Successful.";
		print "Location: LoginForm.pl?err=$err\n\n";
	}
	else {
		$err = "Account already exists.";
		print "Location: RegisterForm.pl?err=$err\n\n";
	}
}
