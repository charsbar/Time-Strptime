package Time::Strptime;
use 5.008005;
use strict;
use warnings;

our $VERSION = "0.01";

use parent qw/Exporter/;
our @EXPORT_OK = qw/strptime/;

use Carp ();
use Time::Strptime::Format;

my %instance_cache;
sub strptime {
    my ($format_text, $date_text) = @_;

    local $Carp::CarpLevel = $Carp::CarpLevel + 1;
    my $format = $instance_cache{$format_text} ||= Time::Strptime::Format->new($format_text);
    return $format->parse($date_text);
}

1;
__END__

=encoding utf-8

=head1 NAME

Time::Strptime - parse date and time string.

=head1 SYNOPSIS

    use Time::Strptime qw/strptime/;

    # function
    my ($epoch_f, $offset_f) = strptime('%Y-%m-%d %H:%M:%S', '2014-01-01 00:00:00');

    # OO style
    my $fmt = Time::Strptime::Format->new('%Y-%m-%d %H:%M:%S');
    my ($epoch_o, $offset_o) = $fmt->parse('2014-01-01 00:00:00');

=head1 DESCRIPTION

B<THE SOFTWARE IS IT'S IN ALPHA QUALITY. IT MAY CHANGE THE API WITHOUT NOTICE.>

Time::Strptime is pure perl date and time string parser.
In other words, This is pure perl implementation a L<strptime(3)>.

This module allows you to perform better by pre-compile the format by string.

benchmark:GMT(-0000) C<dt=DateTime, ts=Time::Strptime, tp=Time::Piece>

    Benchmark: timing 100000 iterations of dt, dt(compiled), tp, ts, ts(compiled)...
            dt: 44 wallclock secs (43.61 usr +  0.05 sys = 43.66 CPU) @ 2290.43/s (n=100000)
    dt(compiled): 25 wallclock secs (25.12 usr +  0.03 sys = 25.15 CPU) @ 3976.14/s (n=100000)
            tp:  1 wallclock secs ( 0.73 usr +  0.00 sys =  0.73 CPU) @ 136986.30/s (n=100000)
            ts: 30 wallclock secs (30.03 usr +  0.09 sys = 30.12 CPU) @ 3320.05/s (n=100000)
    ts(compiled):  2 wallclock secs ( 1.69 usr +  0.00 sys =  1.69 CPU) @ 59171.60/s (n=100000)
                     Rate         dt         ts dt(compiled) ts(compiled)         tp
    dt             2290/s         --       -31%         -42%         -96%       -98%
    ts             3320/s        45%         --         -17%         -94%       -98%
    dt(compiled)   3976/s        74%        20%           --         -93%       -97%
    ts(compiled)  59172/s      2483%      1682%        1388%           --       -57%
    tp           136986/s      5881%      4026%        3345%         132%         --

benchmark:Asia/Tokyo(-0900) C<dt=DateTime, ts=Time::Strptime, tp=Time::Piece>

    Benchmark: timing 100000 iterations of dt, dt(compiled), tp, ts, ts(compiled)...
            dt: 52 wallclock secs (52.25 usr +  0.07 sys = 52.32 CPU) @ 1911.31/s (n=100000)
    dt(compiled): 34 wallclock secs (33.05 usr +  0.05 sys = 33.10 CPU) @ 3021.15/s (n=100000)
            tp:  0 wallclock secs ( 0.81 usr +  0.01 sys =  0.82 CPU) @ 121951.22/s (n=100000)
            ts: 33 wallclock secs (31.97 usr +  0.11 sys = 32.08 CPU) @ 3117.21/s (n=100000)
    ts(compiled):  1 wallclock secs ( 1.71 usr +  0.00 sys =  1.71 CPU) @ 58479.53/s (n=100000)
                     Rate         dt dt(compiled)         ts ts(compiled)         tp
    dt             1911/s         --         -37%       -39%         -97%       -98%
    dt(compiled)   3021/s        58%           --        -3%         -95%       -98%
    ts             3117/s        63%           3%         --         -95%       -97%
    ts(compiled)  58480/s      2960%        1836%      1776%           --       -52%
    tp           121951/s      6280%        3937%      3812%         109%         --

=head1 FAQ

=head2 What's the difference between this module and other modules?

This module is fast and not require XS. but, support epoch C<strptime> only.
L<DateTime> is very useful and stable! but, It is slow.
L<Time::Piece> is fast and useful! but, treatment of time zone is confusing. and, require XS.
L<Time::Moment> is very fast and useful! but, not support C<strptime>. and, require XS.

=head2 How to specify a time zone?

Set time zone to C<$ENV{TZ}> and call C<POSIX::tzset()>.
NOTE: C<POSIX::tzset()> is not supported on C<cygwin> and C<MSWin32>.

example:

    use Time::Strptime qw/strptime/;
    use POSIX qw/tzset/;

    local $ENV{TZ} = 'Asia/Tokyo';
    tzset();
    my ($epoch, $offset) = strptime('%Y-%m-%d %H:%M:%S', '2014-01-01 00:00:00');

And, This code is same as:

    use Time::Strptime::Format;

    my $format = Time::Strptime::Format->new('%Y-%m-%d %H:%M:%S', { time_zone => 'Asia/Tokyo' });
    my ($epoch, $offset) = $format->parse('2014-01-01 00:00:00');

=head1 LICENSE

Copyright (C) karupanerura.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

karupanerura E<lt>karupa@cpan.orgE<gt>

=cut
