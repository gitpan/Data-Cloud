#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;
use Data::Cloud;

my $cloud = Data::Cloud->new;

$cloud->set(
    foo => 10,
    bar => 20,
    baz => 30,
);

for my $word ( qw( foo bar baz ) ) {
    $cloud->decrement( $word );
}

is_deeply(
    $cloud->data,
    {
        foo => 9,
        bar => 19,
        baz => 29,
    },
);

