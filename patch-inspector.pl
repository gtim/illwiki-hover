use 5.24.0;
use warnings;

#
# Copy the dom5inspector into a build directory and "patch" it to 
# facilitate scraping.
#

use File::Copy::Recursive qw/dircopy/;
use File::Slurp qw/read_file write_file/;
use Text::Patch qw/patch/;

# create build directory 

my $DIR_BUILD = 'build';
mkdir $DIR_BUILD unless -d $DIR_BUILD;

# copy inspector directory

my $DIR_INSPECTOR_ORIG  = 'dom5inspector';
my $DIR_INSPECTOR = "$DIR_BUILD/dom5inspector";
die "$DIR_INSPECTOR exists, please clean build directory" if -d $DIR_INSPECTOR;
dircopy( $DIR_INSPECTOR_ORIG, $DIR_INSPECTOR ) or die $!;

# apply patch file

my $file_path = 'scripts/DMI/MItem.js';
my $patch = read_file('MItem.js.diff' ) or die $!;
my $text_to_patch = read_file("$DIR_INSPECTOR_ORIG/$file_path") or die $!;
my $patched_text = patch( $text_to_patch, $patch, STYLE => 'Unified' );
write_file( "$DIR_INSPECTOR/$file_path", $patched_text ) or die $!;
