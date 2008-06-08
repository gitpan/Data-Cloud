#!perl -T

use strict;
use warnings;

use Test::More tests => 2;
use Data::Cloud;

my $cloud = Data::Cloud->new;

$cloud->set(
    Foo => 10,
    bAr => 20,
    baZ => 30,
);

is_deeply(
    $cloud->data,
    {
        foo => 10,
        bar => 20,
        baz => 30,
    },
);

$cloud->set(
    foO => 30,
    Bar => 15,
    bAz => -15,
);

is_deeply(
    $cloud->data,
    {
        foo => 30,
        bar => 15,
        baz => 0,
    },
);
