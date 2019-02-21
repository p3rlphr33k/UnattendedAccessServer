#!/usr/bin/perl -w
print "Content-Type: Text/Plain\n\n";

# NO PROXY USE:
# $ENV{'REMOTE_ADDR'}

# WITH PROXY USE:
# $ENV{'HTTP_X_FORWARDED_FOR'}

$GUEST = $ENV{'REMOTE_ADDR'};
print "$GUEST";
