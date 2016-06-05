use strict;
use warnings FATAL => qw(all);

use Test::More tests => 3;

use VP3;

my ($code, $fh, $p, $error);

my $v = VP3->new ();

######################################################################
#
# Test that we can invoke the parser standalone.

open $fh, "t/preprocessor/ports.v" or die "open: $!";

$p = $v->parse ($fh, 'ports.v', 'ports');

ok (defined ($p) && $p->isa ('VP3::ParseTree'))
    or diag ($error);

######################################################################
#
# File with no trailing whitespace

$code = "module test();endmodule";

open $fh, '<', \$code or die "open: $!";

$p = $v->parse ($fh, 'test.v', 'test', undef, \$error);

ok (defined ($p) && $p->isa ('VP3::ParseTree'))
    or diag ($error);

######################################################################
#
# Macro containing a single identifier
# (macro is parsed as a distinct input stream, so end of macro looks like EOF)

$code = <<END;
`define ENDMODULE endmodule
module test ();
`ENDMODULE
END

open $fh, '<', \$code or die "open: $!";

$p = $v->parse ($fh, 'test.v', 'test', undef, \$error);

ok (defined ($p) && $p->isa ('VP3::ParseTree'))
    or diag ($error);
