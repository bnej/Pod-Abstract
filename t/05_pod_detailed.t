#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
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

=cut
}};

my $pa = Pod::Abstract->load_string($pod);

ok($pa, "Sample POD parsed");

my @links = $pa->select('//:L');
ok(@links == 5, "Found 5 links in the document");

my @list_numbered = $pa->select("//head2/over//over/item");
ok(@list_numbered == 2, "Found 2 nested list items");


done_testing;

1;