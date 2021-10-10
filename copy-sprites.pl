use 5.20.0;
use strict;
use warnings;

use File::Copy::Recursive qw/dircopy/;
use File::Path qw/make_path/;

# Make sure dist dir exists
make_path( 'dist/illwikihover' );

# Copy unit sprites
dircopy( 'dom5inspector/images/sprites', 'dist/illwikihover/img_unit' );

# Copy item sprites
dircopy( 'dom5inspector/images/items',   'dist/illwikihover/img_item' );
