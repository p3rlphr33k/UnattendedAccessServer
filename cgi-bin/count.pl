#!/usr/bin/perl -w
#use CGI;
use DBI;

print "Content-Type: Text/HTML\n\n";

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


$myCount = "SELECT COUNT(*) FROM machines";


	$uniqueCount = $dbh->prepare("$myCount") or print "there was an error!";		
	$uniqueCount->execute() or print $DBI::errstr;
	($total) = $uniqueCount->fetchrow_array();

	$uniqueCount->finish();
	

#SELECT TAG FROM bookmarks GROUP BY TAG HAVING COUNT(*) = 1 WHERE USERID='$acctid' ORDER BY TAG ASC


print qq~
<h4>Remote Access: $total</h4>
~;			
