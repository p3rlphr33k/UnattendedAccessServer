#!/usr/bin/perl

print "Content-Type: Text/HTML\n\n";

$in = $ENV{'QUERY_STRING'};

@in = split(/&/, $in);
foreach $kv (@in){
	($k,$v) = split(/=/, $kv);
	$k =~ tr/+/ /;
	$v =~ tr/+/ /;
	$k =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
	$v =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
	${$k} = $v; 
}

print qq~
<!DOCTYPE html>
<!--[if IE 7]>
<html class="ie ie7" lang="en-US">
<![endif]-->
<!--[if IE 8]>
<html class="ie ie8" lang="en-US">
<![endif]-->
<!--[if !(IE 7) | !(IE 8)  ]><!-->
<html lang="en-US">
<!--<![endif]-->
<head>
<title>Supervene Remote Support Login</title>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="author" content="Bryan Donarski">
<!--[if lt IE 9]>
<script>
  var e = ("abbr,article,aside,audio,canvas,datalist,details," +
    "figure,footer,header,hgroup,mark,menu,meter,nav,output," +
    "progress,section,time,video").split(',');
  for (var i = 0; i < e.length; i++) {
    document.createElement(e[i]);
  }
</script>
<![endif]-->
<!--[if lte IE 8]>
<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
<![endif]-->
<link href="/rs/css/global.css" rel="stylesheet" type="text/css" />
<style type="text/css">
.barColor {
	background: #0099FF;
        color: #FFFFFF !important;
        font-family:verdana;
        font-weight:bold;
        }

.logoBG {
	color:#FFFFFF;
	margin:0px;
	padding:0px;
	background: #009933;
	}

html, body {
background:#333333;
color:#000;
margin:0px;
padding:0px;
width:100%;
height:100%;
text-align:center; }

#wrapper {
width:100%;
height:100%;
margin:40px auto; }

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
h1 {
  text-shadow: 1px 1px 3px #666666;
  font-family: Arial;
  color: #000000;
  font-size: 28px;
}
</style>

<script language="javascript" type="text/javascript" src="/rs/scripts/md5.js"></script>
<script language="javascript">


function validateLogin()
{
	uname = document.getElementById('usernameField').value;
	pword = document.getElementById('passwordField').value;
	pword2 = document.getElementById('passwordField2').value;
	
	document.getElementById('passwordField').value = '';
	document.getElementById('passwordField').disbled=true;
	document.getElementById('passwordField').style.display='none';
	
	document.getElementById('passwordField2').value = '';
	document.getElementById('passwordField2').disbled=true;
	document.getElementById('passwordField2').style.display='none';
	
	document.getElementById('sendIt').disabled=true;
	document.getElementById('sendIt').style.display='none';
	
	hash = hex_md5(pword);
	hash2 = hex_md5(pword2);
	document.getElementById('md5hash').value = hash;
	
	if(uname && hash == hash2)
	{
		return true;
	}
	else
	{
		document.getElementById('usernameField').disabled=false;
		document.getElementById('usernameField').value='';
		
		document.getElementById('passwordField').disabled=false;
		document.getElementById('passwordField').style.display='block';
		document.getElementById('passwordField').value='';
		
		document.getElementById('passwordField2').disabled=false;
		document.getElementById('passwordField2').style.display='block';
		document.getElementById('passwordField2').value='';
		
		document.getElementById('sendIt').disabled=false;
		document.getElementById('sendIt').style.display='block';
		document.getElementById('usernameField').focus;
		return false;
	}
}
</script>

</head>
<body style="padding:0px;margin:0px;">
<form action="/cgi-bin/rs/register.pl" method="post" id="loginForm" onsubmit="return validateLogin();">

<div id="wrapper">
<table border="0" cellpadding="0" cellspacing="0" style="border:1px #696969 solid;background:#FFF;width:400px;margin-top:auto;margin-left:auto;margin-right:auto;margin-left:auto;border-radius:10px;box-shadow:0 0 10px rgba(33, 33, 33, 0.95);">
<tr>
	<td style="padding:20px;">

	<table border="0" cellpadding="3" cellspacing="3" style="padding:0px;">
	<tr>
		<td align="center">
		<img src="http://supervene.com/i/finalize.png">
		<h1>Remote Access</h1>
		</td>
	</tr>
~;

if($err) {
print qq~
	<tr>
		<td>
		<span style="color:red;">$err</span>
		</td>
	</tr>
~;
}

print qq~

	<tr>
		<td>
		<input type="text" name="acctid" id="usernameField" placeholder="E-mail" style="padding:5px;font-size:28px;padding:5px;" class="username_box">
		</td>
	<tr>
	<tr>
		<td>
		<input type="password" name="passwd" id="passwordField" placeholder="Password" style="padding:5px;font-size:28px;padding:5px;" class="password_box">
		</td>
	</tr>
	<tr>
		<td>
		<input type="password" name="passwd2" id="passwordField2" placeholder="Confirm Password" style="padding:5px;font-size:28px;padding:5px;" class="password_box">
		</td>
	</tr>
	<tr>
		<td>
		<input type="submit"  class="btn2" style="width:325px;font-size:25px;padding:7px;cursor:pointer;" value="Register" id="sendIt">		
		</td>
	</tr>

	<tr><td colspan="2" align="center"><span style="font-family:verdana;font-size:small;">Already have an account? <a href="http://supervene.com/rs/login.html" target="new">Login</a></span></td></tr>
	</table>
	
	</td>
</tr>
</table>
<input type="hidden" id="md5hash" name="md5hash" value="">
</form>
<br>
<noscript>
	<font color="#FFFFFF" size="+1">JavaScript must be enabled.</font>
</noscript>
</div>
</body>
</html>
~;