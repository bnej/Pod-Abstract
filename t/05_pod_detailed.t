#!/usr/bin/perl
use strict;
use warnings;

use Test::More tests => 3;
use Pod::Abstract;

my $pod = q{{;
=head1 NAME

Example - Example POD document.

=head1 DESCRIPTION

This is an I<example POD document> for testing purposes. We are going
to parse and traverse it.

=head1 FUNCTIONS

=head2 example_method

 my $v = sample_call($x); # Gives a result

This would be typical for a perl module.

=over

=item *

This would be a bulleted list

=item *

Explaining what to do

=over

=item 1

This one would be a nested numbered list

=item 2

This would also

=back

=item *

Back in the bullets

=back

=cut

sub sample_call {
    # Do some code. This is a "cut" node.
}

=head1 SEE ALSO

L<perlfunc/wantarray> is a link to a function inside a standard document.

L<Pod::Abstract> is a link to a module.

L<Pod::Abstract/load_string> is a link to a section in a module.

L<perlsyn/"For Loops"> is a quoted section name.

L<Pod Abstract is Great|Pod::Abstract> has link text.

L<Test Hyperlink|https://metacpan.org/>

=cut
}};

my $pa = Pod::Abstract->load_string($pod);

ok($pa, "Sample POD parsed");

subtest 'Document Links' => sub {
    my @links = $pa->select('//:L');
    ok(@links == 6, "Found 5 links in the document");

    my $li = $links[0]->link_info;
    is( $li->{text}, 'perlfunc', 'Perlfunc link had expected text' );
    is( $li->{section}, 'wantarray', 'And linked to "wantarray"' );

    $li = $links[1]->link_info;
    is( $li->{text}, 'Pod::Abstract', 'Module link is Pod::Abstract' );
    is( $li->{document}, 'Pod::Abstract', 'Document is same');
    ok( !$li->{section}, 'Section is not defined');

    $li = $links[2]->link_info;
    is( $li->{text}, 'Pod::Abstract', 'Module link is Pod::Abstract' );
    is( $li->{document}, 'Pod::Abstract', 'Document is same');
    is( $li->{section}, 'load_string', 'Section is load_string');

    $li = $links[3]->link_info;
    is( $li->{text}, 'perlsyn', 'Link text is perlsyn');
    is( $li->{section}, '"For Loops"', 'Section is "For Loops"');

    $li = $links[4]->link_info;
    is( $li->{text}, "Pod Abstract is Great", 'Link text is "Pod Abstract is Great"');
    is( $li->{document}, "Pod::Abstract", 'Document is Pod::Abstract');

    $li = $links[5]->link_info;
    is( $li->{text}, 'Test Hyperlink', 'Link text is "Test Hyperlink"' );
    is( $li->{url}, 'https://metacpan.org/', 'Link to metacpan' );
};

subtest 'List Items' => sub {
    my @list_numbered = $pa->select("//head2/over//over/item");
    ok(@list_numbered == 2, "Found 2 nested list items");
};

1;