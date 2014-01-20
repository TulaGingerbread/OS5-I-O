use IO::Socket;
use strict;

my $socket = IO::Socket::INET -> new(
	PeerAddr => "127.0.0.1",
	PeerPort => 2501,
	Proto => 'tcp',
	Timeout => 10,
	Type => SOCK_STREAM
) || die "$!";
while (<>) {
	send $socket, $_, 0;
	while (<$socket>) {
		print;
		last;
	}
}
close $socket;