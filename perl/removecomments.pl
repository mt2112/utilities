#!/usr/bin/perl -w
use strict;
use Getopt::Long;

use constant USAGE => "usage: $0 [ -f filename ] file.dat";

GetOptions(
    'f|filename=s'  => \( my $opt_filename )
) or die USAGE;

die USAGE
    if not( $opt_filename );

my $new = "$opt_filename" . ".tmp";
open (OLD, "< $opt_filename") or die "can't open $opt_filename: $!";
open (NEW, "> $new") or die "can't open $new: $!";

select (NEW);
while(<OLD>) {
  print NEW $_ unless m/^\s*#/;
}
close (OLD);
close (NEW);
rename ($opt_filename, "$opt_filename.orig");
rename ($new, $opt_filename); 