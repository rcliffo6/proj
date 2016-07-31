#!/usr/bin/perl

use strict;
use warnings;

=head
This script will read information from a file on multiple
DNA sequences, then ask the user which sequence they would
like to blast. It takes the information, blasts at NCBI,
then returns a file with the results, and asks if they would
like to check another sequence.
Bio::Perl does not work (at least in my hands) as advertised.
The only attributes I could receive were the initial information
from the first line of a fasta file, and then the sequence itself.
I could not glean an access number from it, separate species, or
other data given in the first line. Luckily, that information was
not required to blast the sequence. Although Bio::Seq was accepted
by .bfx.aap.jhu.edu, it was not possible to "get" all the attributes
of the program.

This file uses fasta.txt which contains 2 fasta sequences for its
inquiry.
=cut

use Bio::Perl;
use Bio::Seq;


my $file = 'fasta.txt';
my @bio_seq_objects = read_all_sequences ($file, 'fasta');
my $count = 0;

foreach my $seq (@bio_seq_objects)  {
   $count++;
   my $name = $seq->display_id();
   my $sequence = $seq->seq();
   my $description = $seq->desc();

   print "
   NUMBER: $count
   NAME: $name
   DESC: $description
   
   "
}

# user will choose by accession number and type
print "\nPlease choose a sequence by number\n";
print "or X for exit.\n";
my $input = "";
while (<STDIN>)  {
   chomp;
   my $input = $_;
   if ($input =~ /^X|x$/) {
     exit;
   }
   elsif ($input !~ /^[0-9]+$/ || $input > scalar @bio_seq_objects )  {
      print "This is not a valid number, 
             please try again!","\n";
   }
# writes blast sequence to a file, sends message, asks to try another
   else {
      my $protein = translate_as_string ($bio_seq_objects[$count-1]->seq);
      my $blast_results = blast_sequence($protein);
      write_blast (">blast$count.txt", $blast_results);
      print "This results has been placed into the file blast$count.txt\n";
      print "Do you want to try another sequence? If so, ";
      print "type another number or X for e(X)it.\n";
   }
}
