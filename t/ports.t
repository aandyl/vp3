use strict;
use warnings FATAL => qw(all);

use Test::Simple tests => 8;

use VP3;

my $v = VP3->new (library_dirs => [ 't/preprocessor' ]);

my $p = $v->ports ('ports');

ok (defined ($p));
ok ($p->isa ('VP3::Ports'));
ok (exists ($p->{output_scalar}));
ok (exists ($p->{output_vector}));
ok (exists ($p->{input_scalar}));
ok (exists ($p->{input_vector}));
ok ($p->{output_vector}->{lsb} == 0);
ok ($p->{output_vector}->{msb} == 9);
