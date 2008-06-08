#!perl -T

use strict;
use warnings;

use Test::More tests => 1;
use Data::Cloud;

isa_ok(
    Data::Cloud->new,
    'Data::Cloud',
);
