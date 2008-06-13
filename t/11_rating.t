#!perl -T

use strict;
use warnings;

use Test::More tests => 1;
use Data::Cloud;

my $cloud = Data::Cloud->new;

$cloud->set(
    a => 1,
    b => 3,

    c => 4,
    d => 4,

    e => 5,
    f => 6,

    g => 7,
    h => 8,

    i => 10,
    k => 10,
);

is_deeply(
    $cloud->rating( rate => 5 ),
    [
        { name => 'i', count => 10, rank => 5 },
        { name => 'k', count => 10, rank => 5 },

        { name => 'h', count =>  8, rank => 4 },
        { name => 'g', count =>  7, rank => 4 },

        { name => 'f', count =>  6, rank => 3 },
        { name => 'e', count =>  5, rank => 3 },

        { name => 'c', count =>  4, rank => 2 },
        { name => 'd', count =>  4, rank => 2 },

        { name => 'b', count =>  3, rank => 1 },
        { name => 'a', count =>  1, rank => 1 },
    ]
);
