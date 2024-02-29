#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use IO::Socket::INET;

my $proto;
my $port;
my $server;
my $help;

GetOptions(
    'proto=s'  => \$proto,
    'port=i'   => \$port,
    'server=s' => \$server,
    'h'        => \$help,
);

if ($help || !defined $proto || !defined $port || !defined $server) {
    print "Usage: $0 --proto <protocol> --port <port> --server <server>\n";
    print "Options:\n";
    print "  --proto   Protocol\n";
    print "  --port    Port number\n";
    print "  --server  Server address\n";
    print "  -h        Display this help message\n";
    exit;
}

my $sock = IO::Socket::INET->new(
    PeerAddr => $server,
    PeerPort => $port,
    Proto    => $proto,
);

die "Could not create socket: $!\n" unless $sock;

$sock->send("Test data");

my $timeout = 2;

eval {
    local $SIG{ALRM} = sub { die "Timeout\n" };
    alarm $timeout;

    my $response;
    $sock->recv($response, 1024);

    print "Received response: $response\n";
};

alarm 0;

if ($@ && $@ eq "Timeout\n") {
    print "No response received within $timeout seconds.\n";
}

$sock->close();
