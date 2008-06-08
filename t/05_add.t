#!perl -T

use strict;
use warnings;

use Test::More tests => 2;
use Data::Cloud;

my $cloud = Data::Cloud->new;

$cloud->add( foo => 10, bar => 20, baz => 30 );

is_deeply(
    $cloud->data,
    {
        foo => 10,
        bar => 20,
        baz => 30,
    },
);

$cloud->add( foo => 20, bar => -10, baz => -50 );

is_deeply(
    $cloud->data,
    {
        foo => 30,
        bar => 10,
        baz => 0,
    },
);

