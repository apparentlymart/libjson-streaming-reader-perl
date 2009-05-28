
=head1 NAME

JSON::Streaming::Reader - Read JSON strings in a streaming manner

=cut

package JSON::Streaming::Reader;

use strict;
use warnings;

sub for_stream {
    my ($class, $stream) = @_;

    my $self = bless {}, $class;
    $self->{stream} = $stream;
}

sub 

1;

=head1 DESCRIPTION

This module is effectively a tokenizer for JSON strings. With it you can process
JSON strings in customizable ways without first creating a Perl data structure
from the data. For some applications, such as those where the expected data
structure is known ahead of time, this may be a more efficient way to process
incoming data.

=head1 SYNOPSIS

    my $jsonr = JSON::Streaming::Reader->for_stream($fh);
    $jsonr->process_tokens(
        start_object => sub {
            ...
        },
        end_object => sub {

        },
        start_property => sub {
            my ($name) = @_;
        },
        # ...
    );

=head1 CALLBACK API

The recommended way to use this library is via the callback-based API. In this
API you make a single method call on the reader object and pass it a CODE ref
for each token type. The reader object will then consume the entire stream
and call the callback responding to the type of each token it encounters.

An error token will be raised on tokenizing errors. However, since this tokenizer
doesn't maintain extensive state only token-level errors will be detected. It
is up to the caller to catch invalid token combinations.

For tokens that themselves have data, the data items will be passed in as arguments
to the callback.

=head2 $jsonr->process_tokens(%callbacks)

Read the whole stream and call a callback corresponding to each token encountered.

=head1 PULL API

A lower-level API is provided that allows the caller to pull single tokens
from the stream as necessary. The callback API is implemented in terms of the
pull API.

=head2 $jsonr->get_token()

Get the next token from the stream and advance. If the end of the stream is reached, this
will return C<undef>. Otherwise it returns an ARRAY ref whose first member is the
token type and its subsequent members are the token type's data items, if any.

=head1 TOKEN TYPES

There are two major classes of token types. Bracketing tokens enclose other tokens
and come in pairs, named with C<start_> and C<end_> prefixes. Leaf tokens stand alone
and have C<add_> prefixes.

For convenience the token type names match the method names used in the "raw" API
of L<JSON::Streaming::Writer>, so it is straightforward to implement a streaming JSON
normalizer by feeding the output from this module into the corresponding methods on that module.

=head2 start_object, end_object

These token types delimit a JSON object. In a valid JSON stream an object will contain
only properties as direct children, which will result in start_property and end_property tokens.

=head2 start_array, end_array

These token types delimit a JSON array. In a valid JSON stream an object will contain
only values as direct children, which will result in one of the value token types described
below.

=head2 start_property($name), end_property

These token types delimit a JSON property. The name of the property is given as an argument.
In a valid JSON stream a start_property token will always be followed by one of the value
token types which will itself be immediately followed by an end_property token.

=head2 add_string($value)

Represents a JSON string. The value of the string is passed as an argument.

=head2 add_number($value)

Represents a JSON number. The value of the number is passed as an argument.

=head2 add_boolean($value)

Represents a JSON boolean. If it's C<true> then 1 is passed as an argument, or if C<false> 0 is passed.

=head2 add_null

Represents a JSON null.

=head1 STREAM BUFFERING

This module doesn't do any buffering. It expects the underlying stream to
do appropriate read buffering if necessary.

=head1 LIMITATIONS

=head2 No Non-blocking API

Currently there is no way to make this module do non-blocking reads. In future
an event-based version of the callback-based API could be added that can be
used in applications that must not block while the whole object is processed, such
as those using L<POE> or L<Danga::Socket>.

This module expects to be able to do blocking reads on the provided stream. It will
not behave well if a read fails with C<EWOULDBLOCK>, so passing non-blocking
L<IO::Socket> objects is not recommended.


