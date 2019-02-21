#!/usr/bin/perl
use DBI;
use Digest::MD5 qw(md5 md5_hex md5_base64);

#print "Content-Type: Text/HTML\n\n";

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

$MyCMD2 = "DELETE FROM machines WHERE id=? LIMIT 1";
$MyCMD1 = "SELECT id,email,password FROM accounts WHERE id=? LIMIT 1";

 $sth1 = $dbh->prepare("$MyCMD1") or die $DBI::errstr;
        $sth1->execute("$acctid") or die $DBI::errstr;
        ($id,$email,$password) = $sth1->fetchrow_array();
        $sth1->finish();

$enc = md5_hex("$email$password");

if($session eq $enc) {
        $sth2 = $dbh->prepare("$MyCMD2") or die $DBI::errstr;
        $sth2->execute("$mid") or die $DBI::errstr;
	$sth2->finish();

	print "Location: /cgi-bin/rs/clients.pl?acctid=$id&session=$session\n\n";
}

else {
        $err = "Invalid login.";
	print "Location: /cgi-bin/rs/LoginForm.pl?err=$err\n\n";
}

$dbh->disconnect();
