use strict;

use Test::More;

eval "use Test::Pod 1.00";

if ($@) {
    plan skip_all => "Test::Pod 1.00 required for testing POD";
} else {
    plan tests => 1;
}

pod_file_ok ("bin/vp3", "Valid POD in vp3");
