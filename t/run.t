use strict;
use warnings FATAL => qw(all);

our @dirs;

BEGIN {
    # This needs to be ready for "use Test::Simple"
    @dirs = qw(basic depends general preprocessor errors instance eval);
}

use Test::Simple tests => scalar (@dirs);

for my $dir (@dirs) {
    ok (system ("make -C t/$dir") == 0, "tests in t/$dir");
}

# vim: sts=4 sw=4 et
