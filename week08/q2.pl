#! usr/bin/perl

use strict;
use warnings;


# this script creates a hash, creates a reference to it,
# sends the reference to a subroutine,
# returns a reference to the hash to the script,
# and prints out the hash.

my %hash = (red=>255, green=>150, blue=> 0);
my $hashref = \%hash;

sub hash_reference {
   my ($ref_to_hash) = @_;
   return $ref_to_hash;
}

# call to subroutine
my $new_hash = hash_reference($hashref);

# dereference the returned hash
my %deref_hash = %$new_hash;

for my $key (keys %deref_hash) {
   print "$key => $deref_hash{$key}\n";
}
