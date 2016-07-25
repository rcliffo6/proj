package RestrictionEnzyme;
use Moose;

=pod
This module defines restriction enzymes, which are amino acid sequences that cleave DNA, either single-stranded, or usually double-stranded. 
They were originally discovered from viruses that killed bacteria, but you don't need to know that right now. 
They can be specific, in that they recognize a certain DNA sequence and cleave at a specific spot in the DNA, or they can be generalized. 
There are 5 types of restriction enzymes. Some are "natural" and some are synthesized by various manufacturers.

The module will define a restriction enzyme by the following attributes:
1. Name - common name.
2. Manufacturer - if it is synthesized.
3. Recognition sequences on DNA. Since DNA is complementary, there will be 2 recognition sites, 
   one for primary, one for the other strand. Both are "required".
4. Cleavage site that it usually cuts the DNA. Note that these cleavages can be either blunt or "sticky", 
   that is, the DNA from one strand is an overhang to the other strand. There will be two cleavage sites, one for
   the primary strand, and one for the secondary strand. Both are "required".

The module contains a method cut_DNA that will take a double-stranded DNA sequence consisting of either 1 or 2 sequences, 
one from the 5' to 3' end and the other from the 3' to 5' end. These strands must be complementary.
If only one sequence is given, it is assumed that it is 5' to 3', and
a complementary sequence is generated.
The module scans to see if the sequence contains the appropriate
recognition sequences, and then return the cleaved sequences
in an array of strings.
=cut

# name and key
has 'name' => (
   is => 'rw',
   required => 1,
   isa => 'Str',
);

# only 1 manufacturer
has 'manufacturer' => (
   is => 'rw',
);

# recognition sequence 1 is in 5' to 3' direction of DNA sequence
# takes a DNA sequence
has 'recognition_sequence1' => (
   is => 'rw',
   required => 1,
);

# recognition sequence 2 is in the 3' to 5' direction. Both are required
# takes the complement DNA sequence
has 'recognition_sequence2 => (
   is => 'rw'.
   required => 1,
);


# cleavage site 1 is where the Restriction Enzyme will split the DNA
# it may be a different site depending on strand - leaving "sticky ends"
# and different lengths.

has 'cleave_site1' => (
   is => 'rw',
   required => 1,
   isa => 'Str',
);

# cleavage site 2 is on the complementary strand, where the Restriction Enzyme
# will split the DNA, creating either blunt ends or sticky ends
has 'cleave_site2 => (
   is => 'rw',
   required => 1,
   isa => 'Str',
);

# The cut_DNA method cleaves the DNA input sequence and retrieve the sequences
# input is an string of DNA nucleotides
# return @ is an array of DNA sequences split by cleavage site
# called with $restriction-enzyme -> cut_DNA ($param1, optional $param2)
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
   if (($param1 =~ $self->recognition_sequence1 &&
        $param2 =~ $self->recognition_sequence2) {
        @temp_ret1 = split ($self->cleave_site1, $param1);
        @temp_ret2 = split ($self->cleave_site2, $param2);
        push @return_seq, @temp_ret1, @temp_ret2;
   }
   elsif ($param1 =~ $self->recognition_sequence2 &&
          $param2 =~ $self->recognition_sequence1) {
          @temp_ret1 = split ($self->cleave_site2, $param1);
          @temp_ret2 = split ($self->cleave_site1, $param2);
          push @return_seq, @temp_ret1, @temp_ret2;
   }
   return @return_seq;
}

1;
