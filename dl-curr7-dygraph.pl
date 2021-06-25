#!/usr/bin/perl

# (C) 2021 Piotr Biesiada

# Perl script to download and parse exchange rates for Polish zloty PLN to Dygraph format

# perl -MCPAN -e shell
# install XML::LibXML

use IO::Socket;
use strict;
use warnings;

use LWP::Simple;
use XML::LibXML;

my $url  = 'http://www.nbp.pl/kursy/xml/dir.txt';
my $file = 'dir.txt';

getstore( $url, $file );

open my $handle, '<', $file;
my @lines = <$handle>;
close $handle;

my @files;

foreach (@lines) {
    if ( ord($_) == 97 ) {
        push @files, substr($_,0,11);
    }
}

open( my $outh, '>', 'output.txt' );

print $outh "D,GBP,EUR,CHF,USD,NOK\n";

for my $i ( 0 .. $#files ) {
    print "\r" . $i . "/" . $#files;
    select()->flush();
    my $fn = $files[$i];
    my $url = 'http://www.nbp.pl/kursy/xml/' . $fn . '.xml';
    $fn=$fn . ".txt";

    getstore( $url, $fn );

    my $dom = XML::LibXML->load_xml(location => $fn);

    print $outh $dom->findvalue('//data_publikacji') . ',';
    print $outh $dom->findvalue('//pozycja/kod_waluty[text()=\'GBP\']/../kurs_sredni') =~ s/,/./r . ',';
    print $outh $dom->findvalue('//pozycja/kod_waluty[text()=\'EUR\']/../kurs_sredni') =~ s/,/./r . ',';
    print $outh $dom->findvalue('//pozycja/kod_waluty[text()=\'CHF\']/../kurs_sredni') =~ s/,/./r . ',';
    print $outh $dom->findvalue('//pozycja/kod_waluty[text()=\'USD\']/../kurs_sredni') =~ s/,/./r . ',';
    print $outh $dom->findvalue('//pozycja/kod_waluty[text()=\'NOK\']/../kurs_sredni') =~ s/,/./r . "\n";
}

print "\nAll ok!\n";
