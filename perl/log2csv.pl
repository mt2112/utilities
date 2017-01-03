# Script for converting Informatica PowerCenter text formatted run logs
# to csv-format.
#
# Sample input record:
#2015-01-15 INF VAR_2 Integrat Use override value [C:\Program                   
#11:21:09       7028  ionserve Files\Informatica\Server\SrcFiles\ErrorLogs\lph_p
#                     r        erhe_dw_errors.csv] for mapping                  
#                              parameter:[$$ERRORLOG].   
#
# Resulting csv-record (clipped):
#2015-01-15 11:21:09;INF;VAR_27028;Integrationserver;Use override value [C:\Progr..
#
# Columns:
# $dt   0-11    date-time
# $sev  12-16   severity
# $code 17-23   code
# $ser  24-31   server
# $msg  32-80   message
#
# Severity is the only field value that exists only on the first line in the log entry. 
# We use it to find the beginning of the next log entry.
#
use strict;
use warnings;
use Getopt::Long;

use constant USAGE => "usage: $0 [ -f filename ] file.dat";

sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}

GetOptions(
    'f|filename=s'  => \( my $infile )
) or die USAGE;

die USAGE if not( $infile );

my $new = "$infile" . ".tmp";
open (OLD, "< $infile") or die "can't open $infile: $!";
open (NEW, "> $new") or die "can't open $new: $!";

my ($t_dt, $t_sev, $t_code, $t_ser, $t_msg); # vars for combining data
my $nl = 0; # time to write newline

# skip 2 header lines
<OLD>;
<OLD>;

#select (NEW);
while(<OLD>) {
  my ($dt, $sev, $code, $ser, $msg) = unpack("A11A4A6A9A48", $_);
  if (trim($sev) && $nl) { # is it time to print line to new file? 
    print NEW "$t_dt;$t_sev;$t_code;$t_ser;$t_msg\n";   
    $nl = 0;
    # clear variables so next line starts clear
    $t_dt = $t_code =  $t_msg = $t_ser = $t_sev = "";    
  } else {    
    $nl = 1;
  }
  # combine several rows of data to one row    
  $t_dt .= $dt;
  $t_code .= $code;
  $t_ser .= $ser;
  $t_msg .= $msg;
  $t_sev .= $sev;
}
close (OLD);
close (NEW);