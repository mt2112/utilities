# Luodaan .end-tiedosto jokaiselle kansion tiedostolle

use strict;
use File::Touch;
use Getopt::Long;

use constant USAGE => "Usage: $0 -d directory (default .) -e extension (default .csv)";

GetOptions(
    'd|directory=s'  => \( my $opt_directory = "." ),
    'e|extension=s'  => \( my $opt_ext = ".csv" ),
) or die USAGE;

die USAGE if not( $opt_directory and $opt_ext);

opendir (DIR, $opt_directory);
my @files = grep { /$opt_ext$/ } readdir(DIR);
closedir(DIR);

my $touch_obj = File::Touch->new();

for my $file (@files) {
  # touch .end file
  $file =~ s/\..*$/.end/;
  $touch_obj->touch($file);
  #print "$file\n";
}