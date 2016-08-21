#! /usr/bin/perl

use Bio::SeqIO;
use strict;
use warnings;

=pod
This script will take any flat file in a format such as genbank, fasta,
swissprot, etc., convert it to the file format of choice, and print to
a file of .fasta, .gb, etc. format. It requires four command line arguments,
as follows:
$ARGV[0] = input file name
$ARGV[1] = input file format
$ARGV[2] = output file name
$ARGV[3] = output file format
If any one of these are missing, the program will die.
=cut

#get command-line arguments or die
my $infile = shift or die "Can't find the file: $!\n";
my $infileformat = shift or die "No input file type: $!\n";
my $outfile = shift or die "No output file: $!\n";
my $outfileformat = shift or die "No output file format: $!\n";

# create two objects, one to read in, the other to write out
my $seq_in = Bio::SeqIO->new (-file => "$infile",
                              -format => $infileformat,
                             );
my $seq_out = Bio::SeqIO->new ( -file => ">$outfile",
                                -format => $outfileformat,
                              );

while (my $inseq = $seq_in->next_seq) {
   $seq_out -> write_seq($inseq);
}
