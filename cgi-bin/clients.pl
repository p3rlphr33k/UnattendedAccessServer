#!/usr/bin/perl -w
use CGI;
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

## RESULTS PER PAGE ##########

$limit=50;
$thisCount = 0;

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
	#print "$k = $v<br>\n";
	}


$MyCMDOnline = "SELECT * FROM machines WHERE updated BETWEEN timestamp(DATE_SUB(NOW(), INTERVAL 1 MINUTE)) AND timestamp(NOW()) AND account LIKE '$acctid' ORDER BY hostname ASC";
$MyCMDOffline = "SELECT * FROM machines WHERE updated <= NOW() - INTERVAL 1 MINUTE AND account LIKE '$acctid' ORDER BY hostname ASC";
$myCMDTotal = "SELECT * FROM machines WHERE account LIKE '$acctid";
$myAcctInfo = "SELECT email,password,created,updated FROM accounts WHERE id='$acctid' LIMIT 1";

($email,$password,$created,$updated) = &FetchMyAcctInfo;

if(!$session) { 
	$cgi = new CGI;
	$session = $cgi->cookie('SvRS'); 
}
else {
	$cgi = new CGI;
	$cookie = $cgi->cookie(
		-name => 'SvRS',
		-value => "$session",
		-expires => '+1h'
	);
}

$compare = md5_hex("$email$password");

if($session && $session eq $compare){

print "Content-Type: Text/HTML\n\n";

print qq~
<!DOCTYPE html>
<html lang="en-us">
<head>
<meta charset="utf-8"/>
<title>Supervene Remote Support</title>
<style type="text/css">
body {
font-family:arial, verdana, times;
color:#000000;
font-weight:bold;
margin:0px;
padding:0px;
}

nav {
  text-align:center;
  line-height:30px;
  display:block;
  background: #0099FF;
  background-image: -webkit-linear-gradient(top, #0099FF, #E3E3E3);
  background-image: -moz-linear-gradient(top, #0099FF, #E3E3E3);
  background-image: -ms-linear-gradient(top, #0099FF, #E3E3E3);
  background-image: -o-linear-gradient(top, #0099FF, #E3E3E3);
  background-image: linear-gradient(to bottom, #0099FF, #E3E3E3);
}

a {
font-weight:bold;
text-decoration:none;
color:#0099FF;
}

.btn2 {
  -webkit-border-radius: 4;
  -moz-border-radius: 4;
  border-radius: 4px;
  font-family: Arial;
  color: #ffffff;
  font-size: 14px;
  background: #349fd9;
  padding: 6px 15px 6px 15px;
  border: solid #27208a 2px;
  text-decoration: none;
}

.btn2:hover {
  background: #3cb0fd;
  background-image: -webkit-linear-gradient(top, #3cb0fd, #3498db);
  background-image: -moz-linear-gradient(top, #3cb0fd, #3498db);
  background-image: -ms-linear-gradient(top, #3cb0fd, #3498db);
  background-image: -o-linear-gradient(top, #3cb0fd, #3498db);
  background-image: linear-gradient(to bottom, #3cb0fd, #3498db);
  text-decoration: none;
  cursor:pointer;
}

.btn {
  background: #34d968;
  background-image: -webkit-linear-gradient(top, #34d968, #219e2a);
  background-image: -moz-linear-gradient(top, #34d968, #219e2a);
  background-image: -ms-linear-gradient(top, #34d968, #219e2a);
  background-image: -o-linear-gradient(top, #34d968, #219e2a);
  background-image: linear-gradient(to bottom, #34d968, #219e2a);
  -webkit-border-radius: 4;
  -moz-border-radius: 4;
  border-radius: 4px;
  text-shadow: 1px 1px 3px #666666;
  font-family: Arial;
  color: #ffffff;
  font-size: 22px;
  padding: 10px 20px 10px 20px;
  border: solid #1f8c2b 2px;
  text-decoration: none;
  width:130px;
  text-align:center;
}

.btn:hover {
  background: #3cfc96;
  background-image: -webkit-linear-gradient(top, #3cfc96, #34d94d);
  background-image: -moz-linear-gradient(top, #3cfc96, #34d94d);
  background-image: -ms-linear-gradient(top, #3cfc96, #34d94d);
  background-image: -o-linear-gradient(top, #3cfc96, #34d94d);
  background-image: linear-gradient(to bottom, #3cfc96, #34d94d);
  text-decoration: none;
  cursor:pointer;
}

.btnO {
  text-shadow: 1px 1px 3px #666666;
  font-family: Arial;
  color: #ffffff;
  font-size: 22px;
  -webkit-border-radius: 5;
  -moz-border-radius: 5;
  border-radius: 5px;
  background: #edabb1;
  padding: 10px 20px 10px 20px;
  border: solid #8c1f1f 2px;
  text-decoration: none;
  width:130px;
  cursor:pointer;
  text-align:center;
}

.btnD {
  -webkit-border-radius: 5;
  -moz-border-radius: 5;
  border-radius: 5px;
  background: #edabb1;
  padding: 0px 0px 0px 0px;
  border: solid #8c1f1f 2px;
  text-decoration: none;
  width:50px;
  height:50px;
  cursor:pointer;
}

.btnD:hover {
  background: #f08787;
  text-decoration: none;
}
tr {
border-bottom: 1px #000 solid;
}
header {
  display:block;
  height:50px;
}
#logo { float:left; margin:7px; }
#account { float:right; margin:10px; }
</style>
<link rel="stylesheet" href="http://supervene.com/rs/css/font-awesome.min.css">
</head>
<body>
<header id="header">
	<div id="logo">
	<img src="http://supervene.com/i/finalize.png">
	</div>

	<div id="account">
		<!--small>Member Since: $created</small>&emsp;
		<small>Last Login: $updated</small>&emsp;-->
		<a href="/cgi-bin/rs/clients.pl?acctid=$acctid&session=$session" class="btn2"><i class="fa fa-refresh"></i> Refresh</a>&emsp;
		<a href="http://supervene.com/rs/SuperveneRemoteAccessSetup-v1.0.exe" class="btn2"><i class="fa fa-plus-square-o"></i> Add Computer</a>&emsp;
		<a href="javascript:alert('Settings coming soon.');" class="btn2"><i class="fa fa-cogs"></i> $email</a>&emsp;
		<a href="/cgi-bin/rs/login.pl?acctid=$acctid&session=logoff" class="btn2"><i class="fa fa-sign-out"></i> Logout</a>
	</div>
</header>

<nav id="nav"></nav>
~;

&FetchOnlineMachines;
&FetchOfflineMachines;
&pccounter;

# http://supervene.com/rs/novnc/vnc.html?host=supervene.com&port=6080&encrypt=0&true_color=0&repeaterID=ID:$sessionID&logging=error

print qq~
</body>
</html>
~;
}
else {
$err = "Invalid Login.";
print "Location: /cgi-bin/rs/LoginForm.pl?err=$err\n\n";
}

################################################################

sub pccounter {

$currentSet = $start+$i;
if($start==0){$start=1;}
if($currentSet==0){$start=0;}
$nav = "$start - $currentSet of $thisCount Computers";

 if($page > 1) {
	$back = $page-1;
	$nav .= qq|<a href="#" onClick="list(\\'$acctid\\',$back);">< Previous</a>&nbsp;|;
 }
 
 if($currentSet < $thisCount) {
	$forward = $page+1;
	$nav .= qq|<a href="#" onClick="list(\\'$acctid\\',$forward);">Next ></a>&nbsp;|;
	$totalMachines = $totalMachines-$limit;
 }

print qq~
<script language="javascript">
document.getElementById('nav').innerHTML = '$nav';
</script>
~;
}
################################################################

## CREATE RANDOM 10 DIGIT VNC SESSION ID

sub sessionNum {

@Chars = ('1'..'9');
$Length = 10;
$Number = '';

for (1..$Length) {
$Number .= $Chars[int rand @Chars];
}
return $Number;
}

########################## ROUTINE TO DISPLAY EACH OFFLINE MACHINE
sub displayOffline {
	if(@_) {
	($mid,$account,$hostname,$command,$updated,$vncnum) = @_;

print qq~
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
		
			<td>
			<img src="http://supervene.com/rs/img/modern2.jpg" width="100px" height="65px">
			</td>
	
			<td>
			PC Name: $hostname
			<br>
			Last Communication: <i style="color:#FF0000;">$updated</i>
			</td>
			
			<td>
			<div class="btnO" onClick="">OFFLINE</div>
			</td>	
			
			<td >
			<div  class="btnD">
			<a href="/cgi-bin/rs/delete.pl?acctid=$acctid&session=$session&mid=$mid">
			<img src="http://supervene.com/rs/img/delete.png" width="50px" height="50px">
			</a>
			</div>
			</td>
			
		</tr>
		</table>
		<hr>
~;
	}
else { print "No Results!<br>"; }
}
########################## ROUTINE TO DISPLAY EACH ONLINE MACHINE
sub displayConnect {
	if(@_) {
	($mid,$account,$hostname,$command,$updated,$vncnum) = @_;

	#$sessionID = &sessionNum;

print qq~
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
		
			<td>
			<img src="http://supervene.com/rs/img/modern.jpg" width="100px" height="65px">
			</td>
	
			<td>
			PC Name: <a href="http://supervene.com/cgi-bin/rs/connect.pl?id=$hostname&session=$vncnum&acctid=$acctid" target="remote">$hostname</a>
			<br>
			Last Communication: <i>$updated</i>
			</td>
			
			<td>
			<a href="http://supervene.com/cgi-bin/rs/connect.pl?id=$hostname&session=$vncnum&acctid=$acctid" target="remote">
			<div class="btn" onClick="">Connect</div>
			</a>
			</td>	
			
			<td >
			<div  class="btnD">
			<a href="/cgi-bin/rs/delete.pl?acctid=$acctid&session=$session&mid=$mid">
			<img src="http://supervene.com/rs/img/delete.png" width="50px" height="50px">
			</a>
			</div>
			</td>
			
		</tr>
		</table>
		<hr>

~;
	}
else { print "No Results!<br>"; }
}
############################# FETCH ALL ONLINE MACHINES AND TALLY FOR PAGE NAVIGATION

sub FetchOnlineMachines {

if(!$page){$page=1;}
$start=$page*$limit-$limit;
$stop=$page*$limit;
$totalMachines=0;

$sth1 = $dbh->prepare("$MyCMDOnline") or print "Error preparing: " .$DBI::errstr . "\n";
$sth1->execute() or print "Error Executing: " .$DBI::errstr . "\n";

while(@row1 = $sth1->fetchrow_array()){
	$thisCount++;
	if(@row1) {
		$totalMachines++;
		if($totalMachines<=$stop && $totalMachines>$start) {
			&displayConnect(@row1);
			$i++;
		}
	}
	else { print "No Machines Found!<br>"; }
}
$sth1->finish();

}

############################# FETCH ALL OFFLINE MACHINES AND TALLY FOR PAGE NAVIGATION

sub FetchMyAcctInfo {
	$sth1 = $dbh->prepare("$myAcctInfo") or print "Error preparing: " .$DBI::errstr . "\n";
	$sth1->execute() or print "Error Executing: " .$DBI::errstr . "\n";
	@udata = $sth1->fetchrow_array();
	$sth1->finish();
	return(@udata);
}

sub FetchOfflineMachines {

if(!$page){$page=1;}
$start=$page*$limit-$limit;
$stop=$page*$limit;
$totalMachines=0;

$sth1 = $dbh->prepare("$MyCMDOffline") or print "Error preparing: " .$DBI::errstr . "\n";
$sth1->execute() or print "Error Executing: " .$DBI::errstr . "\n";

while(@row1 = $sth1->fetchrow_array()){
	$thisCount++;
	if(@row1) {
		$totalMachines++;
		if($totalMachines<=$stop && $totalMachines>$start) {
			&displayOffline(@row1);
			$i++;
		}
	}
	else { print "No Machines Found!<br>"; }
}
$sth1->finish();
}
################################################################

## CLOSE SQL CONNECTIONS
$dbh->disconnect();
exit;
