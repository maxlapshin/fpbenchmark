#!/usr/bin/env perl

my $server = shift @ARGV || "localhost";
my $port = shift @ARGV || "3000";
my $path = shift @ARGV || "/";

my $cmdline = "-t4 http://$server:$port/";
my @measurement = ();

print "Measuring \"$cmdline\", please wait...\n";

for (my $rate = 30000; $rate >= 1000; $rate -= 1000) {
    my @attempts = map {
	    my($rps, $err) = measure($_, $rate);
	    { rps => $rps, err => $err }
	} (1, 2);
    push(@measurement, {
	rate => $rate,
	attempts => \@attempts
    });
}

print "Rate,reached,delta,expected,ERate,A1,A2,A3,E1,E2,E3\n";

foreach my $mnt (@measurement) {
    print "$mnt->{rate}";
    my @attempts = @{$mnt->{attempts}};
    my $rpssum = 0;
    my $errsum = 0;
    my $rpslist = join(",", map { $rpssum += $_->{rps}; $_->{rps} } @attempts);
    my $errlist = join(",", map { $errsum += $_->{err}; $_->{err} } @attempts);
    my $delta = 0;
    if ( $mnt->{rate} > $rpssum/scalar(@attempts) )
                 { $delta = int($rpssum/scalar(@attempts)); } else { $delta = $mnt->{rate}; };

    print "," . $delta;
    print "," . int($errsum*100/scalar(@attempts));
    print "," . $mnt->{rate};
    print "," . int($errsum/scalar(@attempts));
    print "," . $rpslist;
    print "," . $errlist;
    print "\n";
}

sub measure($) {
    my $attempt = shift;
    my $rate = shift;
    my $conns = $rate;
    my $rps = 0;
    my $err = 100;
    my $cmd = "wrk -k -r 100k -c $conns $cmdline";
    local $_;
    print "Executing $cmd\n";
    open(I, "$cmd 2>/dev/null |") or die "Can't open wrk: $!";
    while(<I>) {
	$rps = $1 if /^Requests\/sec:  (\d+)/;
	$err = $1 if /^timeout (\d+)/;
    };
    close(I);
    my $err_rate = int($err * 100 / $conns);
    print "Attempt $attempt rate $rate rps => $rps rps with $err_rate error rate\n";
    ($rps, $err_rate);
}
