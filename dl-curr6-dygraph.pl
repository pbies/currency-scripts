#!/usr/bin/perl

# (C) 2021 Piotr Biesiada

# Perl script to download and parse exchange rates for Polish zloty PLN to Dygraph format
# sudo apt install libxml-simple-perl
# perl -MCPAN -e'install "LWP::Simple"'
# perl -MCPAN -e'install "XML::Simple"'

use IO::Socket;
use strict;
use warnings;

use LWP::Simple;
use XML::Simple;

my $url  = 'http://www.nbp.pl/kursy/xml/dir.txt';
my $file = 'dir.txt';

getstore( $url, $file );

open my $handle, '<', $file;
chomp( my @lines = <$handle> );
close $handle;

my @files;

foreach (@lines) {
	if ( ord($_) == 97 ) {
		chomp($_);
		push @files, $_;
	}
}

open( my $outh, '>', 'output.txt' );

print $outh "D,EUR,USD,CHF,GBP\n";

for my $i ( 0 .. $#files ) {
	my $fn = $files[$i];
	chop $fn;
	$fn = $fn . '.xml';
	my $url = 'http://www.nbp.pl/kursy/xml/' . $fn;

	getstore( $url, $fn );

	my $xml = XMLin($fn);
	print $outh $xml->{data_publikacji} . ',';
	print $outh $xml->{pozycja}[7]{kurs_sredni}  =~ s/,/./r . ',';
	print $outh $xml->{pozycja}[1]{kurs_sredni}  =~ s/,/./r . ',';
	print $outh $xml->{pozycja}[9]{kurs_sredni}  =~ s/,/./r . ',';
	print $outh $xml->{pozycja}[10]{kurs_sredni} =~ s/,/./r . "\n";

}
