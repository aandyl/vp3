use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;
use File::Spec;

WriteMakefile(
    NAME                => 'vp3',
    AUTHOR              => q{Andrew Leiserson <andy@leiserson.org>},
    VERSION_FROM        => 'vp3',
    # This appears to be a recent MakeMaker addition
    #MIN_PERL_VERSION    => "5.008",
    PREREQ_PM => {
        'Test::More' => 0,
        'Parse::Yapp' => 0,
    },
    # Needed to suppress POD for Parser.pm. The default for files that don't
    # exist at POD scan time is to assume they have POD.
    PM                  => { 'Parser.pm' => File::Spec->catfile ('$(INST_LIBDIR)', 'VP3', 'Parser.pm') },
    MAN3PODS            => { },
    EXE_FILES           => [ 'vp3' ],
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
);

package MY;

sub post_constants {
    return <<'MAKE_FRAG';
YAPP_PREFIX ?= $(PREFIX)
MAKE_FRAG
}

sub postamble {
    return <<'MAKE_FRAG';
Parser.pm: verilog.yapp
	$(YAPP_PREFIX)/bin/yapp -m VP3::Parser -o $@ $<
MAKE_FRAG
}
