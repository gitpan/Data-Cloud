#!perl -T

use strict;
use warnings;

use Test::More tests => 2;
use Data::Cloud;

my $cloud = Data::Cloud->new;

$cloud->add( foo => 10, bar => 20, baz => 30 );

is( $cloud->remove('foo'), 10 );

is_deeply(
    $cloud->data,
    {
        bar => 20,
        baz => 30,
    },
);
