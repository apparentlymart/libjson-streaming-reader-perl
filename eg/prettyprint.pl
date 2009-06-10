
use strict;
use warnings;
use JSON::Streaming::Reader;
use JSON::Streaming::Writer;
use IO::Handle;

my $in_stream = IO::Handle->new_from_fd(fileno(STDIN), '<');
my $out_stream = IO::Handle->new_from_fd(fileno(STDOUT), '>');

my $jsonr = JSON::Streaming::Reader->for_stream($in_stream);
my $jsonw = JSON::Streaming::Writer->for_stream($out_stream);
$jsonw->pretty_output(1);

my $indent_level = 0;
my $on_bracket = 0;

$| = 1;

while (my $tok = $jsonr->get_token()) {

    my $toktype = shift @$tok;

    if ($toktype eq 'error') {
        print STDERR "\nParse error: ", @$tok, "\n";
        $jsonw->intentionally_ending_early();
        exit(2);
    }

    $jsonw->$toktype(@$tok);

}


