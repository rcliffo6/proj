#!/usr/bin/perl

use strict;
use warnings;

# calculate annealing temperature of an oligomer,
# 2 degrees C per A or T, 4 degrees per G or C
# calculate the GC content of the oligo

my @bases = qw/ A C G T /;
my $length = 50;
my $sequence = "";
my $Celsius = 0;
my $GC;


foreach (1 .. $length) {
   $b = $bases[int(rand(4))];
   if ($b eq 'G' | $b eq 'C') {
      $Celsius += 2;
      $GC++;
   }
   else {
       $Celsius += 4;
   }
   $sequence = $sequence.$b;
}
my $GC_content = ($GC/$length)*100;
print "\nThe sequence is:  $sequence \n";
print "The annealing temperature of the sequence is:  $Celsius degrees Celsius.\n";
print "The GC content is $GC_content percent.\n\n";
