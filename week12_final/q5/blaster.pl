#! /usr/bin/perl

use strict;
use warnings;

use Bio::DB::GenBank;
use Bio::Perl;
use Bio::Tools::Run::RemoteBlast;
use Bio::Search::Hit::HitI;
use Bio::Search::Result::ResultI;
use Bio::SearchIO;

=pod
This program takes either a DNA or protein sequence accession number as a
command line argument, along with a type of blast, either blastn, tblastn, 
blastpgp, blastx, tblastx, megablast, or blastp, and performs a blast search. 
First it checks to see if it's the appropriate blast for either DNA or protein, 
and detects when the two arguments do not match. 
It outputs to a file named for the query sequence (i.e., accession_number), 
and the type of blast.
Here are the command line elements:
$ARGV[0] = type of blast program;
$ARGV[1] = 'dna' or 'protein';
$ARGV[2] = Accession number;
Output file = Accession_number.type_of_blast.
=cut

my $prog = shift or die "Blast type not specified: $!\n";
my $type = shift or die "DNA or protein not specified: $!\n";
my $acc = shift or die "Accession_number not specified: $!\n";

if ($prog eq 'tblastn'and $type =~ /DNA/i) {   #tblastn is for proteins
   die "1. These parameters do not match: $!\n";
}
elsif ($type =~ /^protein$/i and $prog !~ /^.+p$/i) { # other protein blasts
   die "2. These parameters do not match: $!\n";      # end in 'p'
}
elsif ($type =~ /^DNA$/i and $prog =~  /^.+p/i) {     # DNA blasts do not
   die "3. These parameters do not match: $!\n";      # end in 'p'
}

# obtain the sequence from the database accession number
my $gb_dbh = Bio::DB::GenBank->new();
my $seq = $gb_dbh->get_Seq_by_acc($acc);

# create a $factory object
my $factory = Bio::Tools::Run::RemoteBlast->new (-prog => $prog,
                                                 -data => 'nr',
                                                 -readmethod => 'SearchIO',
                                                );
$factory->submit_blast($seq);
my $v = 1;

print STDERR "waiting..." if ($v > 0);
while (my @rids = $factory->each_rid) {
   foreach my $rid (@rids) {
      my $rc = $factory-> retrieve_blast($rid);
      if (!ref($rc) ) {
         if ($rc < 0 ) {
            $factory->remove_rid($rid);
         }
      print STDERR "." if ($v>0);
      sleep 5;
      } else {
      my $result = $rc->next_result;

      #save in the output file
       my $filename = $acc."_".$prog;
       $factory->save_output($filename);
       $factory->remove_rid($rid);
        while (my $hit = $result->next_hit ) {
           next unless ( $v > 0 );
           print "\thit name is ", $hit->name, "\n";
           while (my $hsp = $hit->next_hsp) {
              print "\t\tscore is ", $hsp->score, "\n";
          }
        }
     }
   }
}
