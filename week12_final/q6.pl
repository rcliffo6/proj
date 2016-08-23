#!/usr/bin/perl

use strict;
use warnings;

use Bio::Perl;
use Bio::DB::GenBank;
use Bio::Search::Hit::HitI;
use Bio::Search::Result::ResultI;
use Bio::SearchIO;
use Bio::Tools::Run::RemoteBlast;
use Bio::Search::HSP::HSPI;
use Bio::SeqIO;

=pod
This script takes a protein accession number as input on the command line, 
fetches it from GenBank, then blasts it against a non-redundant database. 
It retrieves all the hits given above a certain e-value . The script then
writes to separate files per hit, designated as accession numbers and
descriptions in each file, along with information about the hit,
including the GenBank sequence. It would be easy to change this to just
the fasta sequence, however, this provides more data on the hit. 
If there are no hits within the parameters of the cutoff e-value, 
a message will appear on the screen. 
=cut

my $acc = shift or die "Accession_number not specified: $!\n";
my $e_val = shift or die "E-value cut-off not given: $!\n";
my $db = Bio::DB::GenBank->new();
my $seq = $db->get_Seq_by_acc($acc);
my $count = 0;

#  create a factory object for processing and submit
my $factory = Bio::Tools::Run::RemoteBlast->new (
                                -prog => 'blastp',
                                -data => 'nr',
                                -expect => $e_val,
                                -readmethod => 'SearchIO'
                                );
$factory->submit_blast($seq);

while (my @rids = $factory->each_rid) {
   foreach my $rid (@rids) {
      my $rc = $factory->retrieve_blast($rid);
      if (!ref($rc)) {
          $factory -> remove_rid($rid);
      }
      sleep 5;
      } else {
       my $result = $rc->next_result;
       my $filename = "blast.temp";
       $factory->save_output($filename);
       $factory->remove_rid($rid);

        # create a Bio::SearchIO object to parse individual hits
        my $searchio = Bio::SearchIO->new (-format => 'blast',
                                           -file => $filename );
        while (my $input = $searchio->next_result ) {
          $count++;
          while (my $hit = $result->next_hit )  {
             while ( my $hsp = $hit->next_hsp ) {
                my $hsp_file = $hit->accession;
                 
                # print out information in individual files
                open (my $fh, '>>', "$hsp_file") or die ("Could not open file. $!");
                print $fh  $hit->name, $hit->description,"\n",
                   "length= ", $hsp->length(),
                   "    percent_id= ", $hsp->percent_identity,
                   "    e-value= ", $hsp->evalue,"\n",
                   "    fraction identicals= ", $hsp->frac_identical,
                   "    gaps= ", $hsp->gaps,"\n\n",

                # obtain sequence from accession number and print to file
                my $genBank = new Bio::DB::GenBank;
                my $seqIn = $genBank->get_Seq_by_acc("$hsp_file");
                my $seqOut = new Bio::SeqIO(-file => "+>>$hsp_file",
                                            -format => 'genbank');
                $seqOut->write_seq($seq);

                close $fh;
            }
          }
        }
          if ($count == 0) {
             print "There were no hits at this e-value.";
          }
      }
   }
   unlink "blast.temp";
}

          
