package Data::Cloud;

use strict;
use warnings;

use Carp ();
use vars qw( $VERSION );

$VERSION = '0.03';

sub new {
    my ( $class, %args ) = @_;

    my $cs = delete $args{'case_sensitive'}          || 0;
    my $nn = delete $args{'allow_negative_number'}   || 0;

    my $self = bless {
        data    => {},
        option  => {
            case_sensitive          => $cs,
            allow_negative_number   => $nn,
        },
    }, $class;

    return $self;
}

sub data { shift->{'data'} }

sub filter {
    my ( $self, %args ) = @_;

    if ( defined( my $word = delete $args{'word'} ) ) {
        Carp::croak "Argument 'word' is not SCALAR reference."
            if ( ref $word ne 'SCALAR' );

        ${ $word } = lc ${ $word } if ( ! $self->{'option'}->{'case_sensitive'} );
    }

    if ( defined( my $num = delete $args{'number'} ) ) {
        Carp::croak "Argument 'number' is not SCALAR reference."
            if ( ref $num ne 'SCALAR' );

        Carp::croak "Argument 'number' is not integer: number => ${ $num }"
            if ( ${ $num } !~ m{\A[\+\-]?\d+\z} );

        if ( ! $self->{'option'}->{'allow_negative_number'} ) {
            my $number = ${ $num };
               $number = ( $number > 0 ) ? $number : 0 ;
            ${ $num }  = $number;
        }
    }
}

sub set {
    my ( $self, %words ) = @_;

    while ( my ( $word, $num ) = each %words ) {
        Carp::croak "Argument is not integer: $word => $num"
            if ( $num !~ m{\A[\+\-]?\d+\z} );

        $self->filter( word => \$word, number => \$num );

        $self->data->{$word} = $num;
    }
}

sub add {
    my ( $self, %words ) = @_;

    while ( my ( $word, $num ) = each %words ) {
        Carp::croak "Argument is not integer: $word => $num"
            if ( $num !~ m{\A[\+\-]?\d+\z} );

        $self->filter( word => \$word );

        my $value = $self->data->{$word} || 0;
        my $sum   = $num + $value;
        $self->filter( number => \$sum );

        $self->data->{$word} = $sum;
    }
}

sub remove {
    my $self = shift;
    my $word = shift or Carp::croak "Remove word is not specified.";

    $self->filter( word => \$word );

    return delete $self->data->{$word};
}

sub clear {
    my ( $self ) = @_;
    my $removed = $self->data;
    $self->{'data'} = {};
    return $removed;
}

sub increment {
    my $self = shift;
    my $word = shift or Carp::croak "Target word is not specified.";

    $self->filter( word => \$word );

    $self->data->{$word} = 0 if ( ! exists $self->data->{$word} );
    $self->data->{$word}++;
}

sub decrement {
    my $self = shift;
    my $word = shift or Carp::croak "Target word is not specified.";

    $self->filter( word => \$word );

    my $num = $self->data->{$word} || 0;
       $num--;

    $self->filter( number => \$num );

    $self->data->{$word} = $num;
}

sub count {
    my $self = shift;
    my $word = shift or Carp::croak "Target word is not specified";

    $self->filter( word => \$word );

    my $count = ( exists $self->data->{$word} )
              ? $self->data->{$word}
              : 0 ;

    return $count;
}

sub rating {
    my ( $self, %args ) = @_;

    my $rate = delete $args{'rate'} or Carp::croak "Argument 'rate' is not specified.";
    Carp::croak "Argument 'rate' is not positive number"    if ( $rate < 0 );
    Carp::croak "Argument 'rate' is zero"                   if ( $rate == 0 );

    my $all = scalar( keys %{ $self->data } );
    my $num = int( ($all / $rate) + 0.5 );
       $num = 1 if ( $num == 0 );

    my $results = [];
    my $count   = $num;
    my $rank    = $rate;
    for my $word ( sort { $self->data->{$b} <=> $self->data->{$a} } sort keys %{ $self->data } ) {
        push @{ $results }, +{
            name    => $word,
            count   => $self->data->{$word},
            rank    => $rank,
        };

        $count--;
        if ( $count == 0 ) {
            $rank--;
            $rank = 1 if ( $rank <= 0 );
            $count = $num;
        }
    }

    return $results;
}

1;
__END__

=head1 NAME

Data::Cloud - Utility for word cloud.

=head1 SYNOPSIS

  use Data::Cloud;
  
  my $cloud = Data::Cloud->new;
  $cloud->set( wordA => 5, wordB => 3, wordC => 7 );
  $cloud->add( wordA => 5, wordB => -2 wordC => 1 );
  
  my $resource = $cloud->rating( rate => 5 );

=head1 DESCRIPTION

Data::Cloud is a utility for data cloud( tag cloud, word cloud, ...etc ).

This module does a count of a word and a rate separation.

=head1 METHODS

=head2 new

  my $cloud = Data::Cloud->new( %options );

This method is constructor of Data::Cloud.

The following option can be specified as arguments:

=over

=item C<'case_sensitive'>

This option designates whether Data::Cloud distinguishes between uppercase and lowercase letters.

If this option is true, Data::Cloud distinguishes between uppercase and lowercase letters.
And if this option is false, Data::Cloud does not distinguish.

This option is false by default.

=item C<'allow_negative_number'>

This option designates whether Data::Cloud permits the negative number.

If this option is true, Data::Cloud permits the negative number.
And if this option is false, Data::Cloud does not permits.

This option is false by default.

=back

=head2 set

  $cloud->set( wordA => 10, wordB => 5 );

This method sets the number of the word.

When the number exists already, the old number is overwritten by the new number.

=head2 add

  $cloud->add( wordA => 3, wordB => -2 );

This method adds the number of the word.

=head2 remove

  $cloud->remove( $word );
  my $count = $cloud->remove( $word );

This method removes the number of word.

Return value is the number of the removed word.

=head2 clear

  $cloud->clear;
  my $removed = $cloud->clear;

This method removes all data.

A return value is hash reference including a word and the number.
The form of this return value is same as C<$cloud-E<gt>data>.

Please see L<"data"> for more information.

=head2 increment

  $cloud->increment($word);

This method increases the number of the word.

=head2 decrement

  $cloud->decrement($word);

This method decreased the number of the word.

=head2 count

  my $count = $cloud->count($word);

This method gets the number of the word.

=head2 rating

  my $resource = $cloud->rating( rate => 5 );

This method assigns the rate to a word.

The rate is specified as argument C<'rate'>.
Argument 'rate' has to be an integer of more than zero.

A return value is the following feeling:

  $resource = [
      { name => 'foo', count => 20, rank => 5 },
      { name => 'bar', count => 15, rank => 4 },
      { name => 'baz', count => 10, rank => 3 },
      ...
  ];

=head2 filter

  my ( $word, $number ) = ( word => 5 );
  
  $self->filter( word   => \$word );
  $self->filter( number => \$number );
  
  $self->filter( word   => \$word, number => \$number );

This method processes a word and its number with constructor's options.

When Data::Cloud operates a word and the number, this method is called certainly.

=head2 data

  my $data  = $cloud->data;
  my $count = $cloud->data->{$word};

This method is accessor to hash reference keeping data.
Data is kept by the form as C<{ word => $count }>.

=head1 AUTHOR

Naoki Okamura (Nyarla) E<lt>nyarla[:)]thotep.netE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
