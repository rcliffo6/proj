#!/usr/bin/perl

use strict;
use warnings;

=pod
This script will take an array of arrays from a file
and transpose it. The file is included, named Input.txt. 
The mechanism is long, and I'm sure
there is a shorter way to do it, but this makes sense
to me. And it works! It can be used with any symmetrical array of arrays.
The final array is @transposed.
=cut

my @original;   # original array of arrays for input
my $row = 0;
my $column = 0;
my @line = ();
my @transposed = ();
my @middle = ();
my @next = ();

open (INPUT, "Input.txt") or die "Cannot open file: $!";

# read from Input.txt and place into array of references.
while (<INPUT>) {
   chomp();
   @line = split ' ', $_;
   foreach $column (@line)  {
      push @{$original[$row]}, $column;
   }
   $row++;   # will use later to denote number of columns in @transposed
}
close INPUT;

print @original, "\n";

# flatten the original array
for (my $i = 0; $i < $row; $i++)  {
   for (my $j = 0; $j < $row; $j++) {
      push @middle, $original[$i][$j] ;
   }
}

# print the middle array
foreach (@middle) {
   print "$_ ";
}
print "\n";

