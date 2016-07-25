package RestEnz;

use strict;
use warnings;

our $AUTOLOAD;

=pod
This module defines restriction enzymes, which are amino acid sequences that cleave DNA, either single-stranded, or usually double-stranded. 
They were originally discovered from viruses that killed bacteria, but you don't need to know that right now. 
They can be specific, in that they recognize a certain DNA sequence and cleave at a specific spot in the DNA, 
or they can be generalized. There are 5 types of restriction enzymes. 
Some are "natural" and some are synthesized by various manufacturers.

The module will define a restriction enzyme by the following attributes:
1. Name - common name.
2. Manufacturer - if it is synthesized.
3. Recognition sequence on DNA - there is one on each strand, and they may or may not be the same cleavage site.
4. Cleavage site that it usually cuts the DNA. Note that these cleavages can be either blunt or "sticky", that is, 
the DNA from one strand is an overhang to the other strand.

The module contains a method cut_DNA that will take a double-stranded DNA sequence consisting of either 1 or  2 sequences, one from the 5' to 3' end
and the other from the 3' to 5' end. These strands must be complementary.
If only one sequence is given, it is assumed that it is 5' to 3', and
a complementary sequence is generated.
The module scans to see if the sequence contains the appropriate
recognition sequences, and then return the cleaved sequences
in an array of strings.
=cut

# constructor
sub new {
   my ($class, %attribs ) = ( @_);
   my $obj = {
      _name => $attribs {name} || die ( "need 'name'!" ),
      _mfg =>  $attribs {mfg}  || die ( "need 'manufacturer'!" ),
      _type => $attribs {type} || die ( "need 'type'!"),
      _recognitionSite1 => $attribs {recognitionSite1} ||
                        die ( "need 'recognitionSite1'!"),
      -cleaveSite1 => $attribs {cleaveSite1} || die ( "need 'cleaveSite1'!" ),
      _recognitionSite2 => $attribs {recognitionSite2} ||
                        die ( "need 'recognitionSite2'!"),
      -cleaveSite2 => $attribs {cleaveSite2} || die ( "need 'cleaveSite2'!" ),

   }
   return bless $obj, $class;
}

# accessor for all attributes
sub get_name {
   my ($self) = (@_);
    return $self -> {_name};
}

sub get_mfg {
   my ($self) = (@_);
   return $self -> {_mfg};
}

sub get_type {
   my ($self) = (@_);
   return $self -> {_type};
}

sub get_recognitionSite1 {
   my ($self) = (@_);
   return $self -> {_recognitionSite1};
}

sub get_recognitionSite2 {
   my ($self) = (@_);
   return $self -> {_recognitionSite2};
}

sub get_cleaveSite1 {
   my ($self) = (@_);
   return $self -> {_cleaveSite1};
}

sub get_cleaveSite2 {
   my ($self) = (@_);
   return $self -> {_cleaveSite2};
}

# mutators
sub set_name {
   my ($self, $new_name) = (@_);
   $self -> {_name} = $new_name;
   return $self -> {_name};
}

sub set_mfg {
   my ($self, $new_mfg) = (@_);
   $self -> {_mfg} = $new_mfg;
   return $self -> {_name};
}
sub set_type {
   my ($self, $new_type) = (@_);
   $self -> {_type} = $new_type;
   return $self -> {_name};
}

sub set_recognitionSite1 {
   my ($self, $new_recognitionSite1) = (@_);
   $self -> {_recognitionSite1} = $new_recognitionSite1;
   return $self -> {_recognitionSite1};
}

sub set_recognitionSite2 {
   my ($self, $new_recognitionSite2) = (@_);
   $self -> {_recognitionSite2} = $new_recognitionSite2;
   return $self -> {_name};
}

sub set_cleaveSite1 {
   my ($self, $new_cleaveSite1) = (@_);
   $self -> {_cleaveSite1} = $new_cleaveSite1;
   return $self -> {_cleaveSite1};
}

sub set_cleaveSite2 {
   my ($self, $new_cleaveSite2) = (@_);
   $self -> {_cleaveSite2} = $new_cleaveSite2;
   return $self -> {_cleaveSite2};
}

sub AUTOLOAD {
   my ( $self, $new ) = (@_);
   my ( $operation, $attribute ) = $AUTOLOAD =~ /(get|set)(_\w+)/;

   die "no such attribute" unless exists $self -> {$attribute};

   if ( $operation eq 'set' ) {
      $self -> {$attribute} = $new;
   }
   return $self -> {$attribute};
}

# The cut_DNA method cleaves the DNA input sequence and retrieve the sequences
# input is an string of DNA nucleotides
# return @ is an array of DNA sequences split by cleavage site
# called with $restriction-enzyme -> cut_DNA
# Note that this method may not be entirely correct. We would also want to check that the cut sites on both strands are
# within the same site, either exactly apposed to each other for blunt ends, or within the constraints of
# the sticky ends, which may be (depending on the Restriction Enzyme) 3 or more nucleotides apart per strand.
sub cut_DNA {
  my @return_seq = ();
  my ($self, $param1, $param2) = @_;
      die ("This is not a valid DNA sequence: $!\n") unless ($param1 =~ /^[ATGC]*$/);
      die ("The second sequence is not a valid DNA sequence: $!\n" unless defined(param$2) && $param2 =~ /^[ATGC]*$/);

      if ( undef($param2)) {                       #if there is only 1
         my $temp = reverse($param1);              #strand, create the
         $temp = tr/ATGC/TACG/g;                   #complementary strand.
         $param2 = $temp;
     } else {                                      #else check to ensure
         my $temp1 = reverse($param1);             #complementarity of
         $temp1 = tr/ATGC/TACG/g;                  #param2. If not, die.
                die ("These strands are not complementary: $!\n") unless ($param2 eq $param1);
     }
   if (($param1 =~ $self->recognitionSite11 &&
        $param2 =~ $self->recognitionSite22) {
        @temp_ret1 = split ($self->cleaveSite1, $param1);
        @temp_ret2 = split ($self->cleaveSite2, $param2);
        push @return_seq, @temp_ret1, @temp_ret2;
   }
   elsif ($param1 =~ $self->recognitionSite2 &&
          $param2 =~ $self->recognitionSite1) {
          @temp_ret1 = split ($self->cleaveSite2, $param1);
          @temp_ret2 = split ($self->cleaveSite1, $param2);
          push @return_seq, @temp_ret1, @temp_ret2;
   }
   return @return_seq;
}
#use it
1;

