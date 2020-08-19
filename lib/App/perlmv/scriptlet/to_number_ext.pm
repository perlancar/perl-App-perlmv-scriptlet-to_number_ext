package App::perlmv::scriptlet::to_number_ext;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

our $SCRIPTLET = {
    summary => 'Rename files into numbers, preserve extension (foo.txt, bar.mp3 -> 1.txt, 2.mp3)',
    description => <<'_',


_
    args => {
        digits => {
            summary => 'Number of digits to use (1 means 1,2,3,..., 2 means 01,02,03,...); the default is to autodetect',
            schema => 'posint*',
            req => 1,
        },
        start => {
            summary => 'Number to start from',
            schema => 'int*',
            default => 1,
        },
        interval => {
            summary => 'Interval from one number to the next',
            schema => 'int*',
            default => 1,
        },
    },
    code => sub {
        package
            App::perlmv::code;

        use vars qw($ARGS $FILES $TESTING $i);

        $ARGS //= {};
        my $digits = $ARGS->{digits} // (@$FILES >= 1000 ? 4 : @$FILES >= 100 ? 3 : @$FILES >= 10 ? 2 : 1);
        my $start  = $ARGS->{start} // 1;
        my $interval = $ARGS->{interval} // 1;

        $i //= 0;
        $i++ unless $TESTING;

        my $ext = /.+\.(.+)/ ? $1 : undef;
        my $num  = $start + ($i-1)*$interval;
        my $fnum = sprintf("%0${digits}d", $num);
        $fnum . (defined $ext ? ".$ext" : "");
    },
};

1;

# ABSTRACT:

=head1 SYNOPSIS

The default is sorted ascibetically:

 % perlmv to-number-ext foo bar.txt baz.mp3

 bar.txt -> 1.txt
 baz.mp3 -> 2.mp3
 foo -> 3

Don't sort (C<-T> perlmv option), use two digits:

 % perlmv to-number-ext -T -a digits=2 foo bar.txt baz.mp3

 foo -> 01
 bar.txt -> 02.txt
 baz.mp3 -> 03.mp3


=cut
