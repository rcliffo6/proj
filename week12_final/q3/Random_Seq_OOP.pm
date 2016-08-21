package Random_Seq_OOP;
use Moose;

=pod
This module creates an amino acid object which has a length and a randomly generated sequence by default. 
A length is put into the main program, then a sequence is generated via the subroutine random_protein
and placed into the Sequence attribute. It should have a "handles" portion in the 'Sequence' attribute
which delegates the Sequence to the random_protein module, however, I was unable to get this to work. 
I have ##'ed it out, but the idea is to have the 'Sequence' attribute delegate to the subroutine. 
In addition, I have placed a default length in case it was not specified, in order to generate 
random lengths. It was necessary to put a limit on the default length because the rand() function 
only generates random numbers between 0 and 1.
=cut

has 'Length' => (
   is => 'ro',
   isa=> 'Int',
   default => 1 + int(rand(150)),
);

has 'Sequence' => (
   is => 'rw',
   isa => 'Str',
   # handles => {
   #  'protein' => 'random_protein'
   # },
);

sub random_protein {
my $return_sequence = "";
   my $length = shift;
   my @amino_acids = qw/ a r n d c q e g h i l k m d p a r q y c /;

   foreach (1 .. $length) {
      $return_sequence = $return_sequence.$amino_acids[int(rand(20))];
   }
   return $return_sequence;
}
