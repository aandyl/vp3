use strict;
use warnings FATAL => qw(all);

use Test::Simple tests => 2;

use VP3;

my $v = VP3->new (library_dirs => [ 't/preprocessor' ]);

open my $fh, "t/preprocessor/ports.v" or die "open: $!";

my $p = $v->parse ($fh, 'ports.v', 'ports');

ok (defined ($p));
ok ($p->isa ('VP3::ParseTree'));
