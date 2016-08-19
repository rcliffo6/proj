package RANDOM_PROTEIN;

use strict;
use warnings;

use Exporter qw/import/;
our @EXPORT_OK = qw/random_protein/;

sub random_protein {
   my @aa = qw/ a r n d c q e g h i l k m f p s t w y v /;
   my $random_length = 1 + int(rand(100));  #note that this maximum is required
                                            #by perl, otherwise the rand() function
                                            #creates a number between 0 and 1.
   my ($length) = @_;
   my $return = "";

   if ($length) {
      foreach (1 .. $length) {
         $return = $return.$aa[int(rand(20))];
      }
   }
   else {
      foreach (1 .. $random_length) {
        $return = $return.$aa[int(rand(20))];
      }
   }
return $return;
}


# use it
1;

=pod
=head1  random_protein will take one or two arguments.
 my $sequence = random_protein();
 my $length_identified = random_sequence(150);

 With no argument, returns a random protein sequence of a random amount.
 With 1 argument, returns a random protein sequence of the argument's amount.
=cut
