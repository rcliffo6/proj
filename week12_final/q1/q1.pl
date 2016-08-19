#!/usr/bin/perl

use lib "/Users/owner/Desktop/perl_tests/midterm/lib";   #this would be the library for modules normally @INC
use RANDOM_PROTEIN qw/random_protein/;

use strict;
use warnings;

my $length = 50;
print random_protein(), "\n";
print random_protein($length), "\n";
