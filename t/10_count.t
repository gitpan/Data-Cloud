#!perl -T

use strict;
use warnings;

use Test::More tests => 1;
use Data::Cloud;

my $cloud = Data::Cloud->new;

$cloud->set( foo => 12 );

is( $cloud->count('foo'), 12 );
