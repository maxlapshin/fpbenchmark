#!/usr/bin/env perl

my $server = shift @ARGV || "localhost";
my $port = shift @ARGV || "8888";
my $path = shift @ARGV || "/";

my $cmdline = "-t4 http://$server:$port/";
my @measurement = ();

print "Measuring \"$cmdline\", please wait...\n";

for (my $rate = 1000; $rate <= 30000; $rate += 1000) {
    my @attempts = map {
        my($rps, $err) = measure($_, $rate);
        { rps => $rps, err => $err }
    } (1,2);
    push(@measurement, {
        rate => $rate,
        attempts => \@attempts
    });
}

print "Rate,reached,delta,expected,ERate,A1,A2,A3,E1,E2,E3\n";

foreach my $mnt (@measurement) {
    my @attempts = @{$mnt->{attempts}};
    my $rpssum = 0;
    my $errsum = 0;
    my $rpslist = join(",", map { $rpssum += $_->{rps}; $_->{rps} } @attempts);
    my $errlist = join(",", map { $errsum += $_->{err}; $_->{err} } @attempts);
    my $delta = 0;
    if ( $mnt->{rate} > $rpssum/scalar(@attempts) )
                 { $delta = int($rpssum/scalar(@attempts)); } else { $delta = $mnt->{rate}; };

    print "$mnt->{rate}";
    print "," . int($rpssum/scalar(@attempts));
    print "," . $delta;
    print "," . int($errsum/scalar(@attempts));
    print "\n";
}

sub measure($) {
    my $attempt = shift;
    my $rate = shift;
    my $conns = $rate;
    my $rps = 0;
    my $err = 0;
    my $cmd = "wrk -k -r 30k -c $conns $cmdline";
    local $_;
    print "Executing $cmd\n";
#    sleep(int($conns/1000));
    open(I, "$cmd |") or die "Can't open wrk: $!";
    while(<I>) {
        $err = $1 if /^  Socket errors: connect 0, read 0, write 0, timeout (\d+)/;
        $rps = $1 if /^Requests\/sec:   (\d+)/;
    };
    close(I);
    print "Attempt $attempt rate $rate rps => $rps rps with $err error rate\n";
    ($rps, $err);
}
