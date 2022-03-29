use 5.20.0;
use strict;
use warnings;

# old code -- make clearer

use File::Slurp;
use JSON;

my $OUT_DIR = 'dist/illwikihover';

#process( 'item', $OUT_DIR, 'build/inspector-html/items.json' );
process( 'spell', $OUT_DIR, 'build/inspector-html/spells.json' );
#process( 'unit', $OUT_DIR, 'build/inspector-html/units.json' );

sub process {
	my ( $type, $OUT_DIR, $in_fn ) = @_;

	# ensure output directories exist
	mkdir $OUT_DIR unless -d $OUT_DIR;
	mkdir "$OUT_DIR/$type" unless -d "$OUT_DIR/$type";

	my $json_dump = read_file( $in_fn );
	my @spells_html = @{ decode_json( $json_dump ) };

	my %name_to_id = ();
	for my $html ( @spells_html ) {
		$html =~ s@^\s*<div.*?>(.*)</div>\s*$@$1@;

		# find ID 
		
		$html =~ m@<div class="overlay-header" title="$type id:([\d\.]+)">@ or die "could not find ID";
		my $id = $1;
		next if ( $type eq 'unit' && $id =~ m/\./ ); # skip units with ID on the form 123.01 (what are these?)

		# find name
		
		$html =~ m@<div class="h2replace">(.*?)</div>@ or die "could not find name";
		my $name = $1;
		$name =~ s/\x{201c}//g; # remove quotation marks
		die "unexpected char in name '$name'" unless $name =~ /^[a-zA-Zö '-]+$/;


		printf "%4d: %s\n", $id, $name;
		
		# clean
		$html =~ s/<input.*?>//; # unpin button
		$html =~ s@<div class="overlay-wiki-link.*?</div>@@;
		$name_to_id{$name} //= [];
		push @{$name_to_id{$name}}, $id;

		# update item/unit image
		if ( $type eq 'item' ) {
			$html =~ s@src="[^"]*?(item\d+\.png)"@src="/dom5/lib/plugins/illwikihover/img_item/$1"@;
		} elsif ( $type eq 'unit' ) {
			$html =~ s@src="[^"]*?sprites/([\d_]+\.png)"@src="/dom5/lib/plugins/illwikihover/img_unit/$1"@;
		}

		# get spell description + details
		$name =~ s/[' ]//g; # clean spell name for descriptions
		if ( $type eq 'spell' ) {
			$html = proc_add_descr( $name, $html, 'dom5inspector/gamedata/spelldescr/', 1 );
		} elsif ( $type eq 'item' ) {
			$html = proc_add_descr( $name, $html, 'dom5inspector/gamedata/itemdescr/', 0 );
		} elsif ( $type eq 'unit' ) {
			my $fn = sprintf( "dom5inspector/gamedata/unitdescr/%04d.txt", $id );
			if ( -f $fn ) {
				my $desc = read_file( $fn ) or die $!;
				$html =~ s@(<div class="overlay-descr.*?>)(</div>)@$1$desc$2@;
			} else {
				if ( grep { $_ == $id } qw/601 955 1347 1454 2141 2142 2144 2146 2147 2194 2195 2598 2607/ ) {
					say "      missing description for $name as expected";
				} else {
					die "      unitdescr missing: $fn";
				}
			}
		}

		# write
		write_file( sprintf('%s/%s/%d.htm',$OUT_DIR,$type,$id), $html ) or die $!;
	}
	# write name-to-id hash
	my $hash_fn = sprintf( '%s/%s_nametoid_hash.json', $OUT_DIR, $type );
	say "writing name-to-id map to $hash_fn";
	write_file( $hash_fn, encode_json( \%name_to_id ) ) or die $!;
}


sub proc_add_descr {
	my ( $name, $html_old, $desc_folder, $also_dets ) = @_;
	my $html = $html_old;


	$name =~ s/AshestoAshes/Ashestoashes/;
	$name =~ s/CalltheWormThatWalks/CalltheWormthatWalks/;
	$name =~ s/K.nhelm/Knhelm/;
	my $desc_fn = $desc_folder . $name . '.txt' ;
	if ( ! -f $desc_fn ) {
		if ( grep { $_ eq $name } qw/HolyThing Burning Cleansing Grip MemoriesofDeath Bewilderment Halt FieryDeath Drowning Petrification LightningDeath Paralyzation Death Exhaustion Tangles Bleeding Chestwound CaveCollapse/ ) {
			say "      missing description for $name as expected";
		} else {
			die "description for $name not found: $desc_fn";
		}
	} else {
		my $desc = read_file( $desc_fn ) or die $!;
		$html =~ s@(<div class="overlay-descr.*?>)(</div>)@$1$desc$2@;
	}
	if ( $also_dets ) {
		my $dets_fn = $desc_folder . 'details' . $name . '.txt' ;
		if ( -f $dets_fn ) {
			my $dets = read_file( $dets_fn );
			$html =~ s@(<div class="overlay-details.*?>)(</div>)@$1$dets$2@;
		}
	}
	return $html;
}
