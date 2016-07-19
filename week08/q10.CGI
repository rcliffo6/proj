#!/usr/bin/perl

use strict;
use warnings;
use CGI qw(:standard);
use DBI;

=pod
This is a CGI to provide a web-based search of the SQLite3 database for the file data.fasta. It allows repeat searches from a single form. It allows queries on gene name, organism, tissue type, expression level, or any combination of these attributes.
=cut

# Create SQLite Tables to allow input
my $dbh = DBI -> connect("DBI:SQLite:data.dbl","","") or die "Cannot connect: $DBI::errstr";
my $sth;

# $dbh -> do (DROP TABLE IF EXISTS fasta_sequence);

$dbh -> do ("CREATE TABLE fasta_sequence(gene_name VARCHAR(15) PRIMARY KEY, organism VARCHAR(50), tissue VARCHAR (255), start INT, stop INT, expression_level FLOAT, sequence TEXT)");

# Open fasta file and prepare for input
my $fasta_data = "data.fasta";
open (DATA, $fasta_data) or die "ERROR: can't read this file: $!";

# create empty array for header line input from fasta file
# @header will contain all the header information as follows:
#       @header[0] = gene name;
#       @header[1] = organism;
#       @header[2] = tissue;
#       @header[3] = start;
#       @header[4] = stop;
#       @header[5] = expression level;

my @header = ();
my @sequence = ();  #array of string lines to hold sequence
my $sequence_end = "";
my $flength = 80;

# input header and sequence data into array
while (my $line = <DATA>) {
   chomp ($line);
   if ($line =~ /^>+/) {
      @header = split/\|/, $line;
      $line = "";
   }
   elsif (length($line) ==  $flength) {
      push @sequence, $line;
      $line = "";
   }
   else  {
       $sequence_end =  $line;
      $line = "";
   }

# now that we have a sequence and its headers, arrange the one array to place data into the SQLite tables
      my $sequence_string = join ("", @sequence);
      $sequence_string = $sequence_string.$sequence_end;
      $header[6] = $sequence_string;

# prepare and execute insertion into SQLite table
      $sth = $dbh -> prepare ("INSERT INTO fasta_sequence (gene_name, organism, tissue, start, stop, expression_level, sequence) VALUES (?,?,?,?,?,?,?)");
      for (@header) {
              $sth -> execute (@_);
      }
next;
}

# Printing the form to the URL
my $title = "INQUIRY INTO FASTA FILE";
print header,
   start_html($title),
   h1($title);
my $url = url();
print start_form(-method => 'GET', action => $url),
   p("What gene information do you require".br().checkbox_group(-name => 'input',
      -values => ['gene_name','organism','tissue','start','stop','expression_level','sequence_string'],
      -default => ['gene_name'],
      -linebreak => 'true' )),
p(submit(-name => 'submit', value => 'Submit')),

my @columns = ();

# processing form
if (param('submit'))   {
   @columns = param ('input');
}

my $ref = join ',', @columns;

# execute user's query
# Note:  I tried to output data using the list of input columns joined with commas in $ref,
# however, the program would not take it unless I specifically stated which columns the
# user had requested, and I couldn't figure out how to do that within SQL.

    my $sql = qq 'SELECT * FROM fasta_sequence' ;
    $sth = $dbh -> prepare ($sql) or die "Cannot prepare: " . $dbh -> errstr;
    $sth -> execute() or die ("Cannot execute: ". $sth -> errstr());
    $sth -> bind_columns ($ref);
    $sth -> fetchrow_array();

# print out the statement
    print "Here is the information requested:", "\n", $ref, "\n";
    while (my @row = $sth -> fetchrow_array() ) {
       print  @row;
    }

end_form();
end_html();

$sth -> finish();
$dbh -> disconnect;

    
    
    
