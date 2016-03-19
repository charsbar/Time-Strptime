package Time::Strptime;
use 5.008005;
use strict;
use warnings;

our $VERSION = "0.07";

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

Time::Strptime is pure perl date and time string parser.
In other words, This is pure perl implementation a L<strptime(3)>.

This module allows you to perform better by pre-compile the format by string.

benchmark:GMT(-0000) C<dt=DateTime, ts=Time::Strptime, tp=Time::Piece>

    Benchmark: timing 100000 iterations of dt, dt(cached), tp, tp(cached), ts, ts(cached)...
            dt: 34 wallclock secs (34.23 usr +  0.02 sys = 34.25 CPU) @ 2919.71/s (n=100000)
    dt(cached): 21 wallclock secs (20.50 usr +  0.01 sys = 20.51 CPU) @ 4875.67/s (n=100000)
            tp:  1 wallclock secs ( 1.52 usr +  0.00 sys =  1.52 CPU) @ 65789.47/s (n=100000)
    tp(cached):  1 wallclock secs ( 0.61 usr +  0.00 sys =  0.61 CPU) @ 163934.43/s (n=100000)
            ts: 24 wallclock secs (24.32 usr +  0.01 sys = 24.33 CPU) @ 4110.15/s (n=100000)
    ts(cached):  1 wallclock secs ( 0.59 usr +  0.00 sys =  0.59 CPU) @ 169491.53/s (n=100000)
                   Rate       dt       ts dt(cached)        tp tp(cached) ts(cached)
    dt           2920/s       --     -29%       -40%      -96%       -98%       -98%
    ts           4110/s      41%       --       -16%      -94%       -97%       -98%
    dt(cached)   4876/s      67%      19%         --      -93%       -97%       -97%
    tp          65789/s    2153%    1501%      1249%        --       -60%       -61%
    tp(cached) 163934/s    5515%    3889%      3262%      149%         --        -3%
    ts(cached) 169492/s    5705%    4024%      3376%      158%         3%         --

benchmark:Asia/Tokyo(-0900) C<dt=DateTime, ts=Time::Strptime, tp=Time::Piece>

    Benchmark: timing 100000 iterations of dt, dt(cached), tp, tp(cached), ts, ts(cached)...
            dt: 41 wallclock secs (40.74 usr +  0.02 sys = 40.76 CPU) @ 2453.39/s (n=100000)
    dt(cached): 26 wallclock secs (26.09 usr +  0.01 sys = 26.10 CPU) @ 3831.42/s (n=100000)
            tp:  2 wallclock secs ( 2.10 usr +  0.00 sys =  2.10 CPU) @ 47619.05/s (n=100000)
    tp(cached):  1 wallclock secs ( 1.48 usr +  0.01 sys =  1.49 CPU) @ 67114.09/s (n=100000)
            ts: 27 wallclock secs (26.74 usr +  0.01 sys = 26.75 CPU) @ 3738.32/s (n=100000)
    ts(cached):  1 wallclock secs ( 0.83 usr +  0.00 sys =  0.83 CPU) @ 120481.93/s (n=100000)
                   Rate       dt       ts dt(cached)        tp tp(cached) ts(cached)
    dt           2453/s       --     -34%       -36%      -95%       -96%       -98%
    ts           3738/s      52%       --        -2%      -92%       -94%       -97%
    dt(cached)   3831/s      56%       2%         --      -92%       -94%       -97%
    tp          47619/s    1841%    1174%      1143%        --       -29%       -60%
    tp(cached)  67114/s    2636%    1695%      1652%       41%         --       -44%
    ts(cached) 120482/s    4811%    3123%      3045%      153%        80%         --

=head1 FAQ

=head2 What's the difference between this module and other modules?

This module is fast and not require XS. but, support epoch C<strptime> only.
L<DateTime> is very useful and stable! but, It is slow.
L<Time::Piece> is fast and useful! but, treatment of time zone is confusing. and, require XS.
L<Time::Moment> is very fast and useful! but, not support C<strptime>. and, require XS.

=head2 How to specify a time zone?

Set time zone name or L<DateTime::TimeZone> object to C<time_zone> option.

    use Time::Strptime::Format;

    my $format = Time::Strptime::Format->new('%Y-%m-%d %H:%M:%S', { time_zone => 'Asia/Tokyo' });
    my ($epoch, $offset) = $format->parse('2014-01-01 00:00:00');

=head2 How to specify a locale?

Set locale name object to C<locale> option.

    use Time::Strptime::Format;

    my $format = Time::Strptime::Format->new('%Y-%m-%d %H:%M:%S', { locale => 'ja_JP' });
    my ($epoch, $offset) = $format->parse('2014-01-01 00:00:00');

=head1 LICENSE

Copyright (C) karupanerura.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

karupanerura E<lt>karupa@cpan.orgE<gt>

=cut
