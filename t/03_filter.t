#!perl -T

use strict;
use warnings;

use Test::More tests => 4;
use Data::Cloud;

my $cloud = Data::Cloud->new();
my $word  = 'Word';
my $num   = -3;
$cloud->filter( word => \$word, number => \$num );
is( $word => 'word' );
is( $num  => 0 );

$cloud = Data::Cloud->new( case_sensitive => 1 );
$word  = 'WoAd';
$cloud->filter( word => \$word );
is( $word => 'WoAd' );

$cloud = Data::Cloud->new( allow_negative_number => 1 );
$num   = -3;
$cloud->filter( number => \$num );
is( $num => -3 );
