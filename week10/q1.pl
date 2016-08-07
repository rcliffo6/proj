#! /usr/bin/perl

use strict;
use warnings;

use Bio::DB::GenBank;
use Bio::Perl;
use Bio::Tools::Run::RemoteBlast;
use Bio::Search::Hit::HitI;
use Bio::Search::Result::ResultI;
use Bio::SearchIO;

=head
This program will prompt a user for an accession number, BLAST and
retrieve the top non-self hit. I attempted to prompt the user if
the sequence was not valid, but Bio::SearchIO  does not allow that -
instead, it crashes if it is not valid, despite valiant efforts to
avoid that possibility.
The blast results are placed in a file (although that is not necessary),
then finds the the highest non-self hit of THAT search, BLASTS it.
From this second file (query2.out), the second hit is chosen
and information is printed out about it.
Although it would be easy to check to see if this was a duplicate hit
to the first, and as a result, go on to the third hit,
that wasn't the homework assignment, so very often
it will be reciprocal, and if it's true, that is noted as well.
=cut

print "Please type a valid accession number.\n";
my $acc = <STDIN>;
chomp $acc;
my $count = 1;

my $hit = &blast_seq($acc);

# obtain accession number from 2nd ranking hit that is not identical
# to the 1st accession, and reblast it.
my $acc1 = $hit->name();
my @acc2 = split( /\|/, $acc1);
my $hit2 = &blast_seq($acc2[1]);

# print out information on the second hit
# accession, GI, name, species, score, length
# notes whether these are reciprocal hits.
&hit_info ($hit2);
if ($hit2->name eq $acc || $hit2->name eq $hit) {
   print "Note: these are reciprocal hits.\n"
}

# subroutine blast_seq will blast and return the second highest hit
#  for further processing
sub blast_seq {
    my ($accession) = @_;
    my $gb_dbh = Bio::DB::GenBank->new();
    my $seq = $gb_dbh->get_Seq_by_acc($accession);
    my $factory = Bio::Tools::Run::RemoteBlast->new(-prog => 'blastp',
                                                -data => 'nr',
                                                -expect => 1e-10,
                                                -readmethod=>'SearchIO' );
    $factory->submit_blast( $seq);
    while ( my @rids = $factory->each_rid) {
        foreach my $rid ( @rids ) {
           my $result = $factory->retrieve_blast( $rid );

           if( ref( $result )) {
              my $output = $result->next_result();
              my $filename = "query$count.out";
              $factory->save_output($filename);

              my $searchio = Bio::SearchIO->new (-format => 'blast',
                                                 -file   => "query$count.out");
              my $blast_result = $searchio->next_result;

              while ( $hit = $blast_result->next_hit()) {
                  if ( $hit->name() !~ $accession) {
                  $count++;
                  return $hit;
              }
              $factory->remove_rid( $rid );
              }
           }
           elsif( $result < 0 ) {
              $factory->remove_rid( $rid );
           }
           else {
              sleep 5;
           }
        }
    }
}

# subroutine to print out information on an individual hit
sub hit_info {
   my ($hit) = @_;
   my $name = $hit->name();
   my $desc = $hit->description();
   my $len = $hit->length();
   my $alg = $hit->algorithm();
   my $score = $hit->raw_score();
   my $significance = $hit->significance();
   my $rank = $hit->rank();

   print "
        NAME:    $name 
        DESC:    $desc
        LENGTH:  $len
        ALGORI:  $alg
        SCORE:   $score
        SIGNIF:  $significance
        RANK:    $rank
      ";
}
