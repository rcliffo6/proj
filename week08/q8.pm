package Translate_DNA;

use warnings;
use strict;

use Exporter 'import';
our @EXPORT_OK = ("translate_DNA");


=pod
=head translate_DNA
Called with a single argument consisting of a string of DNA bases
that returns an array of amino acid sequences for any valid sequence that
begins with a start codon, ATG, contains at least 3 amino acids, and ends with a valid stop codon, (TAG, TAA, or TGA).

If there is no start codon, it will return that information.
If there is no stop codon, it will translate to the end and note it.
If there is an non-nucleotide character, it will return that information.
If it cannot open or read the string, it will return that information.
Also checks start and stop to ensure they are in the same reading frame.
=cut
# Find any start codons
# Do the sequence by 3's until it reaches a stop codon, find its index
# Checks to see that there is at least 3 amino acids (9 bases including ATG)
# ATG is before the stop codon

sub translate_DNA {
    my %DNA_code = qw(
       TCA  S  TCC  S  TCG  S  TCT  S  TTC  F  TTT  F  TTA  L  TTG  L
       TAC  Y  TAT  Y  TAA  _  TAG  _  TGC  C  TGT  C  TGA  _  TGG  W
       CTA  L  CTC  L  CTG  L  CTT  L  CCA  P  CCC  P  CCG  P  CCT  P
       CAC  H  CAT  H  CAA  Q  CAG  Q  CGA  R  CGC  R  CGG  R  CGT  R
       ATA  I  ATC  I  ATT  I  ATG  M  ACA  T  ACC  T  ACG  T  ACT  T
       AAC  N  AAT  N  AAA  K  AAG  K  AGC  S  AGT  S  AGA  R  AGG  R
       GTA  V  GTC  V  GTG  V  GTT  V  GCA  A  GCC  A  GCG  A  GCT  A
       GAC  D  GAT  D  GAA  E  GAG  E  GGA  G  GGC  G  GGG  G  GGT  G
   );

   my $string = shift;
   my @ATG_index = ();        # to store start codon indices
   my $start_index = 0;
   my @stop_index_list = ();  # to store stop codon indices
   my $stop_index = 0;
   my $ATG = "ATG";           # to find start codon
   my %start_stop = ();       # hash to store start/stop codons
   my $compare = 0;           # to ensure that codons are in same reading frame
   my $DNA_string;
   my @nucleotide_strings;    # valid nucleotide strings with start and stop codons
   my $aa_string = "";
   my @proteins = ();         # return array of amino acid strings
   my @nuc_string = ();

#  check for validity of string
   if ( $string =~ /^\s+$/ or $string eq "" or not defined $string) {
      die "This sequence is not readable. $!\n";
      exit;
   }
   elsif (length($string) < 12) {    #actually the shortest protein is 20 aa's
      die "This sequence is too short to be a protein.";
      exit;
   }
   elsif ($string !~ /^(A|T|G|C|U)*$/)  {      # must be upper case but can be RNA
      die "This sequence contains a non-nucleotide: $!\n";    #try /[ACGT]{3}/g /^[ACGTU]+$/
      exit;
   }
   elsif ($string !~ /ATG/)   {
      die "This sequence contains no start codon: $!\n";
      exit;
      
       }

#  read the $string - find the start codons
   my $idx = 0;
   $start_index = index($string, $ATG, $idx);
   while ($start_index != -1) {
      push (@ATG_index, $start_index);
      $idx = $start_index + 1;
      $start_index = index ($string, $ATG, $idx);
   }

# find stop codon indices
    my $sidx = 0;
    while ($string =~ /TAA|TAG|TGA/g) {
      push @stop_index_list, pos($string);
   }

# find matching start and stop codons and push the indices into a hash
# key will be start codon index, value will be end of the stop codon,
# which is one past the stop codon itself.
# check that distance between start and stop will be at least 3 amino acids
# since the start and stop must be in same reading frame
# Note: if stop_index_list is empty, then code is read from start of ATG
# until end of $string
# All of these DNA_strings will be created from start to stop and pushed into an
# array of nucleotide strings for later translation to amino acids.
   OUTER: foreach my $i (0 .. $#ATG_index) {
      if (@stop_index_list)  {
         INNER: foreach my $j (0 .. $#stop_index_list) {
            $compare = $stop_index_list[$j];
            if ($ATG_index[$i]%3 == $compare%3 && $ATG_index[$i] + 11 < $stop_index_list[$j])  {
               $DNA_string = substr $string, $ATG_index[$i], $stop_index_list[$j] - $ATG_index[$i];
               push @nucleotide_strings, $DNA_string;
          next OUTER;
            }
         }
      }
      else {           # if there are no stop codons, it will go from start to the end of the sequence
         for my $k (0 .. $#ATG_index) {
           $DNA_string = substr $string, $ATG_index[$k];
            push @nucleotide_strings, $DNA_string;
         }
      }
   }

# split @nucleotide_strings into codons to create appropriate amino acids,
# compare to the @DNA-code in order to translate to amino acid string
# and place these into an array of amino acid strings
   foreach (@nucleotide_strings) {
      @nuc_string = $_ =~ /\D{3}/g;  #array of codons
      foreach (@nuc_string)  {
           $aa_string = $aa_string.$DNA_code{$_};
      }
      push @proteins, $aa_string;
      @nuc_string = ();       # empty string to start on new DNA string.
      $aa_string  = "";        # empty amino acid string to start on new putative protein.
  }
   foreach (@proteins) {
      print $_, "\n";
    }
   return @proteins;
}
# use it
1;


