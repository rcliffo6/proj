#!/usr/bin/perl

use warnings;
use strict;

# generate an array of random integers
# send this array to 2 subroutines
# to find and return the largest and smallest

my @numbers = ();
for my $i (0 .. 50) {
   $numbers[$i] = int(rand(1000));
}
print "@numbers\n";

sub max_sum {
   my @digits = @_;
   my $max = (sort {$b <=> $a} @digits)[0];
   return $max;
}

sub min_sum {
   my @nos = @_;
   my $min = (sort {$a <=> $b} @nos)[0];
   return $min;
}

my $maximum = max_sum(@numbers);
my $minimum = min_sum(@numbers);
print "Smallest = $minimum, largest = $maximum\n";
