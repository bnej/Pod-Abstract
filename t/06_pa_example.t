 #!/usr/bin/perl
use strict;
use warnings;

use Test::More tests => 2;
 
use Pod::Abstract;
use Pod::Abstract::BuildNode qw(node);

# This test is just to validate that the example provided at the start of the
# Pod::Abstract documentation actually works!

# Get all the first level headings, and put them in a verbatim block
# at the start of the document
my $pa = Pod::Abstract->load_file('lib/Pod/Abstract.pm');
my @headings = $pa->select('/head1@heading');
my @headings_text = map { $_->pod } @headings;
my $headings_node = node->verbatim(join "\n",@headings_text);

$pa->unshift( node->cut );
$pa->unshift( $headings_node );
$pa->unshift( node->pod );

my $expect = q{=pod

 NAME
 SYNOPSIS
 DESCRIPTION
 COMPONENTS
 METHODS
 AUTHOR
 COPYRIGHT AND LICENSE

=cut};

my $pod = $pa->pod;

ok(index($pod, $expect) >= 0, "Found expected heading summary in generated POD");

# This example is from Pod::Abstract::Node - should do as advertised.

my ($head) = $pa->select('/head1(2)'); # Grab the third head1 from the document (0 based).
my $heading = $head->param('heading'); # This is the node containing the heading text.
my $plain_text = $heading->text; # This is the plain text version.

is( $plain_text, 'DESCRIPTION', 'Third heading from example is DESCRIPTION');


1;