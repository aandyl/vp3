use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;
use File::Spec;

WriteMakefile(
    NAME                => 'vp3',
    AUTHOR              => q{Andrew Leiserson <andy@leiserson.org>},
    VERSION_FROM        => 'bin/vp3',
    # This appears to be a recent MakeMaker addition
    #MIN_PERL_VERSION    => "5.008",
    PREREQ_PM => {
        'Test::More' => 0,
        'Parse::Yapp' => 0,
    },
    # Needed to suppress POD for Parser.pm. The default for files that don't
    # exist at POD scan time is to assume they have POD.
    #PM                  => { 'Parser.pm' => File::Spec->catfile ('$(INST_LIBDIR)', 'VP3', 'Parser.pm') },
    # Not sure how to use PMLIBDIRS for auto file scanning and also tell
    # MakeMaker about the generated Parser.pm
    PM                  => { 'lib/VP3.pm' => 'blib/lib/VP3.pm',
                             'lib/VP3/Parser.pm' => 'blib/lib/VP3/Parser.pm',
                             'lib/VP3/Expression.pm' => 'blib/lib/VP3/Expression.pm',
                             'lib/VP3/Lexer.pm' => 'blib/lib/VP3/Lexer.pm',
                             'lib/VP3/ParseTree.pm' => 'blib/lib/VP3/ParseTree.pm',
                             'lib/VP3/ParseTreeMutator.pm' => 'blib/lib/VP3/ParseTreeMutator.pm',
                             'lib/VP3/ParseTreeVisitor.pm' => 'blib/lib/VP3/ParseTreeVisitor.pm',
                             'lib/VP3/RTLTool.pm' => 'blib/lib/VP3/RTLTool.pm',
                             'lib/VP3/RTLTool/Connectivity.pm' => 'blib/lib/VP3/RTLTool/Connectivity.pm',
                             'lib/VP3/RTLTool/Preprocessor.pm' => 'blib/lib/VP3/RTLTool/Preprocessor.pm' },

    #PMLIBDIRS           => [ 'VP3' ],
    MAN3PODS            => { },
    EXE_FILES           => [ 'bin/vp3' ],
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
lib/VP3/Parser.pm: verilog.yapp
	$(YAPP_PREFIX)/bin/yapp -m VP3::Parser -o $@ $<
MAKE_FRAG
}
