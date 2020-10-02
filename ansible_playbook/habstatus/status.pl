#!/usr/bin/perl

$ENV{'PATH'} = '/usr/local/bin/nginx:' . $ENV{'PATH'};

use strict;

my %commands = (
	'uptime' => 'tell how long the system has been running.',
	'ps' => 'report a snapshot of the current processes.',
	'lastlog' => 'reports the most recent login of all users.',
	'who' => 'show who is logged on.',
	'free' => 'display amount of free and used memory in the system.',
	'sf' => 'show a flag string.',
	'ls' => 'list the contents of the Apache DocumentRoot.',
	'netstat' => 'print network connections.',
	'ifconfig' => 'display the status of the currently active interfaces',
	'df' => 'report file system disk space usage.'
);

print "Content-type: text/html\n";
print "Refresh: 5\n\n";
print "<pre>HAB-CGISTAT\n-----------\n";

if($ENV{'QUERY_STRING'} =~ m/(?:command|cmd)=([a-z]+)$/) {
	if (exists($commands{$1})) {
		print system($1);
	} elsif ($1 eq 'help') {
		foreach my $key (sort (keys %commands)) {
			print $key, "\t", $commands{$key}, "\n";
		}
	} else {
		print "Command not found\nTry 'help'.";
	}
} else {
  print "Missing 'command' parameter or command not specified.";
}

print "</pre>";