#!perl -T

use strict;
use warnings;

use Test::More tests => 2;
use Data::Cloud;

my $cloud = Data::Cloud->new;

$cloud->set( foo => 10, bar => 20, baz => 30 );

is_deeply(
    $cloud->clear,
    {
        foo => 10,
        bar => 20,
        baz => 30,
    },
);

is_deeply(
    $cloud->data,
    {},
);
