#!/usr/bin/perl 
 
use warnings; 
use strict; 
 
=pod 
This script converts Celsius to Fahrenheit and vice versa, depending 
upon input from the user. If input <STDIN> is numerical, it asks whether 
the user requests C or F, however, any alphabetical input results in 
exit from the program (Good-bye!). The user may or may not spell out 
Celsius or Fahrenheit, and may use upper or lower case. The default, if 
the character is anything but F or f ..., is Celsius. 
=cut 
 
my $type = ""; 
my $temp = 0; 
 
print "Give me a temperature to convert or type -> Good-bye.   "; 
while ($temp ne "Good-bye") { 
   chomp ($temp = <STDIN>); 
   if ($temp =~ /^[a-z]/i)  { 
       print "Good-bye!\n"; 
       exit; 
    } 
    else { 
       print "\nIs this Centigrade (C) or Fahrenheit (F)?"; 
       chomp ($type = <STDIN>); 
 
       if ($type =~ /^F/) { 
          my $Celsius = ($temp - 32) * (5/9); 
          print "$temp Fahrenheit converts to $Celsius Celsius.\n\n"; 
       } 
 
       else { 
          my $Fah = ($temp * 9/5) + 32; 
          printf  ("$temp Celsius converts to %d Fahrenheit.\n\n, $Fah"; 
       } 
    } 
    print "Give me another temperature to convert or type -> Good-bye.   "; 
} 
