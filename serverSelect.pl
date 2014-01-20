use IO::Select;
use IO::Socket;

$lsn = IO::Socket::INET -> new(Listen => 1, LocalPort => 2501);
$sel = IO::Select -> new( $lsn );

while (@ready = $sel->can_read) {
	foreach $fh (@ready) {
		if ($fh == $lsn) {
			$new = $lsn->accept();
			$sel->add($new);
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
				$sel->remove($fh);
				$fh->close();
				print "Peer disconnected...\r\n";
			}
		}
	}
}