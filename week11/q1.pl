#!/usr/bin/perl

use strict;
use warnings;
use CGI qw/:standard/;
use Bio::DB::EUtilities;

=pod
This is a form that will ask the user for an entry in Entrez on NCBI. It takes
the user parameters via CGI, processes the input via EGQuery, accesses Entrez,
then prints out the number of hits in each category, along with the status of
each data block. It checks to see if there is an entry after the user presses
the "Submit" button, and prints out data for the user. It can take individual
submissions for as long as the user requests. If the query is invalid, it will
return no hits.
=cut

 # create factory object to obtain data from Entrez
my $entrez = '';
my $factory = Bio::DB::EUtilities->new(-eutil => 'egquery',
                                         -email => 'cdravtx@gmail.com',
                                         -term => "$entrez");
# begin HTML transmission
my $title = 'Query of Entrez Database';
print header,
     start_html ($title),
     h1($title);

# process query
if (param('submit')) {
    my $entrez = param('query');

# iterate through Global Query objects
    while (my $gq = $factory->next_GlobalQuery) {
       print p("Database: ",$gq->get_database),
             p("Count:    ",$gq->get_count),
             p("Status:   ",$gq->get_status, "\n");
    }
}


# the form that the user will fill out
my $url = url();
print start_form(-method => 'GET', action => $url),
    p("What is your query in Entrez\?" . textfield(-name=>'query')),
    p(submit(-name => 'submit', value =>'Submit')),
 end_form(),
 end_html();
