use IO::Poll;
use IO::Socket;

$lsn = IO::Socket::INET -> new(Listen => 1, LocalPort => 2501);
$poll = IO::Poll -> new();

$poll->mask($lsn => POLLIN);

while (1) {
	$poll->poll();
	foreach $fh ($poll->handles(POLLIN)) {
		if ($fh == $lsn) {
			$new = $lsn->accept();
			$poll->mask($new => POLLIN);
			print "Peer connected!\r\n";
		}
		else {
			my $data;
			$fh->recv($data,256,0);
			if ($data ne '') {
				$fh->print($data);
				$fh->flush();
				chomp $data;
				print "Message from peer: '$data'\r\n";
			}
			else {
				$poll->mask($fh => 0);
				$fh->close();
				print "Peer disconnected...\r\n";
			}
		}
	}
}