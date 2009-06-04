
=head1 NAME

JSON::Streaming::Reader::TestUtil - Utility functions for the JSON::Streaming::Reader test suite

=head1 DESCRIPTION

This package contains some utility functions for use in the test suite for L<JSON::Streaming::Reader>.
It's not useful outside of this context.

=cut

package JSON::Streaming::Reader::TestUtil;

use JSON::Streaming::Reader;
use Test::More;

use base qw(Exporter);
our @EXPORT = qw(test_parse);

sub test_parse {
    my ($name, $input, $expected_tokens) = @_;

    my $jsonw = JSON::Streaming::Reader->for_string($input);
    my @tokens = ();

    while (my $token = $jsonw->get_token()) {
        push @tokens, $token;
    }

    is_deeply(\@tokens, $expected_tokens, $name);
}

1;
