#!/usr/bin/perl

use Moose;
use lib "/Users/owner/Desktop/perl_tests/final";
use Random_Seq_OOP;

my @prot_length = (50, 100, 150, 0);

foreach my $x (@prot_length) {
   if ($x == 0) {
      $x = 1 + int(rand(150));
   }
   my $prot_seq = Random_Seq_OOP::random_protein($x);
   my $aa = Random_Seq_OOP->new (
      Length => $x,
      Sequence => $prot_seq,
      # Sequence => protein,
   );
   print $aa->Sequence, "\n";
}
