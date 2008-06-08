#!perl -T

use strict;
use warnings;

use Test::More tests => 1;
use Data::Cloud;

my $cloud = Data::Cloud->new;

is_deeply(
    $cloud->data,
    {},
);
