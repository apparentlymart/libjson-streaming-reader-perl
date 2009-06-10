
# This is not actually a Reader example, but rather a utility to add a line-by-line
# delay to a pipe so that the streamingness of the streaming reader can be observed
# more easily.

$| = 1;

while (<>) {
    print $_;
    sleep 1;
}

