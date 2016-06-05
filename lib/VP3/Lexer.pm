package VP3::Lexer;

use VP3::ParseTree;

use IO::File;
use Data::Dumper;
use Carp;

use constant {
    ST_INSERT       => 0,
    ST_DEFAULT      => 1,
    ST_COMMENT      => 2,
    ST_DIRECTIVE    => 3,
    ST_UNPARSED     => 4,
    ST_IFDEF_SKIP   => 5,
    ST_EOF          => 6,
};

# Special tokens
my $unparsed = qr/\@Unparsed/;

# These tokens introduce directives containing arbitrary text, terminated by a ;
# Upon encountering a token in this list, the lexer will slurp text up to the next ;
my $dtok = sub { my $x = join ("|", map { quotemeta $_ } @_); qr/(?:$x)(?![\w\$])/ }->(
    '@Module',
    '@Instance',
);

# Operator tokens. When multiple operators share a common prefix, the
# longest must be listed first.
my $otok = sub { my $x = join ("|", map { quotemeta $_ } @_); qr/(?:$x)/ }->(
    '@',
    '#',
    '.',
    ';',
    ',',
    '?',
    '<=',
    '<<<',
    '<<',
    '<',
    '>=',
    '>>>',
    '>>',
    '>',
    '(*)',
    '(*',
    '(',
    ')',
    '[',
    ']',
    ':',
    '{',
    '}',
    '+:',
    '+',
    '-:',
    '-',
    '~^',
    '~|',
    '~&',
    '~',
    '&&',
    '&',
    '||',
    '|',
    '^~',
    '^',
    '*)',
    '**',
    '*>',
    '*',
    '!==',
    '!=',
    '!',
    '/',
    '%',
    '===',
    '==',
    '=',
);

# Keyword tokens. Recognized only when not followed by an identifier character,
# so that we don't identify something like "edge_count" as a keyword.
my $ktok = sub { my $x = join ("|", map { quotemeta $_ } @_); qr/(?:$x)(?![\w\$])/ }->(qw(
    @Ports
    @Regs
    @Wires
    @Vector
    @Input
    @Output
    @Waive
    always
    and
    assign
    automatic
    begin
    buf
    bufif0
    bufif1
    case
    casex
    casez
    cell
    cmos
    config
    deassign
    default
    defparam
    design
    disable
    edge
    else
    endcase
    endconfig
    endfunction
    endgenerate
    endmodule
    endprimitive
    endspecify
    endtable
    endtask
    end
    event
    force
    forever
    fork
    for
    function
    generate
    genvar
    highz0
    highz1
    ifnone
    if
    incdir
    include
    initial
    inout
    input
    instance
    integer
    join
    large
    liblist
    library
    localparam
    macromodule
    medium
    module
    nand
    negedge
    nmos
    nor
    noshowcancelled
    not
    notif0
    notif1
    or
    output
    parameter
    pmos
    posedge
    primitive
    pull0
    pull1
    pulldown
    pullup
    real
    pulsestyle_onevent
    pulsestyle_ondetect
    rcmos
    realtime
    real
    reg
    release
    repeat
    rnmos
    rpmos
    rtran
    rtranif0
    rtranif1
    scalared
    showcancelled
    signed
    small
    specify
    specparam
    strong0
    strong1
    supply0
    supply1
    table
    task
    time
    tran
    tranif0
    tranif1
    tri
    tri0
    tri1
    triand
    trior
    trireg
    use
    vectored
    wait
    wand
    weak0
    weak1
    while
    wire
    wor
    xnor
    xor
));

#               Default     Comment     Directive   Unparsed
# @Unparsed     X           -           -           X (SOL)
# .*            -           X           X           X
# Whitespace    X           -           -           -
# /*            X           -           X           -
# */            -           X           -           -
# //            X           -           X           -
# `include      X (SOL)     -           -           -
# All others    X           -           -           -

# Portions of the lexer here are duplicated in VP3::RTLTool::Preprocessor::standard

# Parser-disabled sections. The (\s*) at the start of the first case works
# because we always match one or the other of the alternatives the first
# time the input line is matched. (i.e. this regex is only matched against
# strings where the start-of-string is also start-of-line in the input)
my $re_unparsed = qr/^(?:
     (?:(\s*)($unparsed\s*(\S+)\s*;\s*$))
    |((?s).*$)
)/x;

# In /* */ comments
my $re_comment_body = qr/^(?:
     (.*?\*\/)              # $1: comment terminator
    |((?s).*$)              # $2: anything else
)/x;

my $re_comment_start = qr/^(?:
     (\/\*)                 # $1: start of multiline comment
    |(\/\/.*\n)             # $2: single line comment
)/x;

my $re_directive = qr/^(?:
     (?:([^;]+?)(?=\/\/|\/\*|$|;))  # $1: slurp up to comment, newline, or semicolon
    |(;)                            # $2: semicolon
)/x;

# !!! Many of these use \w incorrectly to match identifiers

my $re_conditional = qr/^(?:
     (\s*`endif(?=[^\w\$]))     # $1: endif
    |(\s*`if(n)?def\s+(\w+))    # $2, $3, $4: ifdef or ifndef
    |(\s*`elsif\s+(\w+))        # $5, $6: elsif
    |(\s*`else(?=[^\w\$]))      # $7: else
)/x;

my $re_default = qr/^(?:
     ($unparsed\s*(\S+)\s*;\s*$)                # $1, $2: start of unparsed section
    |(\s+)                                      # $3: whitespace
    |($dtok)                                    # $4: directive-starting tokens
    |(`timescale\s.*\n)                         # $5: `timescale
    |(`include\s+"(.*)"\s*\n)                   # $6, $7: `include
    |(`define\s+(\w+)(?:\s+(.*)\n)?)            # $8, $9, $10: `define
    |(?:`line\s+(\d+)\s+"(.*)"\s+(\d)\s*\n)     # $11, $12, $13: `line
    |(")                                        # $14: string
    |(?i:'(s)?([bodh])(\s*)
      ([0-9a-fxz?][0-9a-fxz?_]*))               # $15, $16, $17, $18: based number
    |([0-9][0-9_]*)                             # $19: unsigned number
    |($ktok)                                    # $20: keywords
    |($otok)                                    # $21: operator tokens
    |([a-zA-Z_][a-zA-Z0-9_\$]*)                 # $22: identifier
    |(?:(\\[^\s]+)(?=\s))                       # $23: escaped identifier
    |(\$[a-zA-Z0-9_\$]+)                        # $24: system identifier
    |(`undef\s+(\w+)\s*\n)                      # $25, $26: `undef
    |(?:`(\w+)(?=\W))                           # $27: text macro reference
                                                #      (must be after preprocessor directives)
)/x;

sub new
{
    my ($class, $parse_mode) = @_;

    $parse_mode ||= "VP3_PARSE_MODE_SOURCE_TEXT";

    my $self = {
        source          => [ ],
        file            => undef,
        fh              => undef,
        buffer          => undef,
        line            => 0,
        ws_text         => "",
        ws_toks         => [ ],
        state           => ST_INSERT,
        states          => [ ],
        #start_of_line   => 0,
        ifdefs          => VP3::Conditionals->new,
        defines         => { },
        includes        => [ ],
        insert_toks     => [ $parse_mode ],
    };
    return bless $self, $class;
}

sub input
{
    use Scalar::Util qw(openhandle);

    my ($self, $fh, $name) = @_;

    if ($self->{fh} || @{$self->{source}}) {
        VP3::fatal ("lexer input stream is already open");
    }

    unless (openhandle ($fh)) {
        VP3::fatal ("\$fh argument isn't an open handle");
    }

    $self->{fh}     = $fh;
    $self->{file}   = $name;
    $self->{buffer} = "";

    1;
}

sub depend_cb
{
    $_[0]->{depend_cb} = $_[1];
}

sub lex
{

    my ($self) = shift;
    my $tobj;

    while (1) {

        if ($self->{state} == ST_INSERT) {
            my $tok = shift @{$self->{insert_toks}};
            if (!@{$self->{insert_toks}}) {
                $self->{state} = ST_DEFAULT;
            }
            return ($tok, undef);
        } elsif ($self->{state} == ST_EOF) {
            return ('', undef);
        }

        while ($self->{buffer} eq "") {

            $self->{buffer} = $self->{fh}->getline;
            $self->{line}++;
            #$self->{start_of_line} = 1;

            if (!defined $self->{buffer}) {

                # Is splitting of `ifdefs across include file boundaries
                # allowed? Assuming yes. Otherwise unterminated ifdefs
                # should be checked outside this conditional.

                if (@{$self->{source}}) {
                    # Reached end of an include file or `define, pop the stack
                    $self->flush_whitespace;
                    ($self->{file}, $self->{fh}, $self->{buffer}, $self->{line}) = @{pop @{$self->{source}}};
                    #$self->{start_of_line} = 0;
                } else {
                    # Reached end of top-level source file

                    # !!! Need to more thoroughly handle all cases where $self->{states} is non-empty

                    if ($self->{ifdefs}->depth) {
                        # !!! Should report where the ifdef started
                        VP3::error ("Unterminated `ifdef");
                    }

                    $self->{state} = ST_EOF;
                    $tobj = VP3::ParseTree->factory ("eof", "");
                    $self->token ($tobj);
                    return ('EOF', $tobj);
                }
            }

        }

        #print "buffer ($self->{line}, $self->{state}): >" . $self->{buffer} . "<\n";

        if ($self->{state} == ST_UNPARSED && $self->{buffer} =~ s/$re_unparsed//) {

            if ($2) {
                my ($ws, $text, $command) = ($1, $2, $3);
                if ($command eq "end") {
                    $self->{state} = pop @{$self->{states}};
                    $self->{ws_text} .= $ws . VP3::Utils::block_comment ($text);
                    next;
                } elsif ($command eq "begin") {
                    VP3::error ("\@Unparsed sections cannot be nested");
                    # continue, still in @Unparsed section
                } else {
                    VP3::error ("Valid commands for \@Unparsed are `begin' and `end'");
                    # continue, still in @Unparsed section
                }
            } elsif ($4) {
                $self->{ws_text} .= $4;
                next;
            } else {
                VP3::fatal ("in lexer, ST_UNPARSED");
            }

        } elsif ($self->{state} == ST_COMMENT && $self->{buffer} =~ s/$re_comment_body//) {

            if ($1) {
                $self->{ws_text}    .= $1;
                $self->{state}      = pop @{$self->{states}};
                next;
            } elsif ($2) {
                $self->{ws_text}    .= $2;
                next;
            } else {
                VP3::fatal ("in lexer, ST_COMMENT");
            }

        } elsif (($self->{state} == ST_DIRECTIVE || $self->{state} == ST_DEFAULT) &&
                 $self->{buffer} =~ s/$re_comment_start//) {

            if ($1) {
                $self->{ws_text}    .= $1;

                push @{$self->{states}}, $self->{state};
                $self->{state} = ST_COMMENT;
                next;
            } elsif ($2) {
                $self->{ws_text}    .= $2;
                next;
            } else {
                VP3::fatal ("in lexer, ST_DIRECTIVE || ST_DEFAULT");
            }

         } elsif ($self->{state} == ST_DIRECTIVE && $self->{buffer} =~ s/$re_directive//) {

            if ($1) {
                $tobj = VP3::ParseTree->factory ("vp3_directive_text", $1);
                $self->token ($tobj);
                return ('vp3_directive_text', $tobj);
            } elsif ($2) {
                $self->{state} = pop @{$self->{states}};
                $tobj = VP3::ParseTree->factory ("token", ';');
                $self->token ($tobj);
                return (';', $tobj);
            } else {
                VP3::fatal ("in lexer, ST_DIRECTIVE");
            }

        } elsif (($self->{state} == ST_DEFAULT || $self->{state} == ST_IFDEF_SKIP) &&
                 $self->{buffer} =~ s/$re_conditional//) {

            if ($1) {
                # `endif

                $self->{ws_text} .= $1;

                $self->{state} = $self->{ifdefs}->endif ? ST_DEFAULT : ST_IFDEF_SKIP;
                next;

            } elsif ($2) {
                # `ifdef or `ifndef

                my ($command, $sense, $name) = ($2, $3, $4);

                $self->{ws_text} .= $command;

                my $cond = defined ($sense) ^ exists ($self->{defines}->{$name});

                $self->{state} = $self->{ifdefs}->ifdef ($cond) ? ST_DEFAULT : ST_IFDEF_SKIP;
                next;

            } elsif ($5) {
                # `elsif
                my ($command, $name) = ($5, $6);

                $self->{ws_text} .= $command;

                my $cond = exists ($self->{defines}->{$name});

                $self->{state} = $self->{ifdefs}->elsif ($cond) ? ST_DEFAULT : ST_IFDEF_SKIP;
                next;

            } elsif ($7) {
                # `else

                $self->{ws_text} .= $7;

                $self->{state} = $self->{ifdefs}->else ? ST_DEFAULT : ST_IFDEF_SKIP;
                next;

            } else {

                VP3::fatal ("in lexer, ST_DEFAULT || ST_IFDEF_SKIP");

            }

        } elsif ($self->{state} == ST_IFDEF_SKIP) {

            # The LRM says (19.4) "NOTE--Any group of lines that the
            # compiler ignores still has to follow the Verilog HDL lexical
            # conventions for white space, comments, numbers, strings,
            # identifiers, keywords, and operators."

            # It's not clear from that whether we are required to raise an
            # error if the ifdef-disabled source is not valid, or just that
            # we are entitled to. Currently no error is raised.

            $self->{ws_text} .= $self->{buffer};
            $self->{buffer} = "";
            next;

        } elsif ($self->{state} == ST_DEFAULT && $self->{buffer} =~ s/$re_default//) {

            if ($1) {
                # @Unparsed directive
                my ($text, $command) = ($1, $2);

                if ($command eq "begin") {
                    push @{$self->{states}}, $self->{state};
                    $self->{state} = ST_UNPARSED;
                    $self->{ws_text} .= VP3::Utils::block_comment ($text);
                    next;
                } elsif ($command eq "end") {
                    VP3::error ("Found `\@Unparsed end' without matching `\@Unparsed begin'");
                    # continue, not in unparsed section
                } else {
                    VP3::error ("Valid commands for \@Unparsed are `begin' and `end'");
                    # continue, not in unparsed section
                }

            } elsif ($3) {
                # Whitespace

                $self->{ws_text} .= $3;
                next;

            } elsif ($4) {
                # Unparsed vp3 directives

                my $tok = $4;

                $tobj = VP3::ParseTree->factory ("token", $tok);
                $self->token ($tobj);

                push @{$self->{states}}, $self->{state};
                $self->{state} = ST_DIRECTIVE;

                return ($tok, $tobj);

            } elsif ($5) {
                # `timescale

                $self->{ws_text} .= $5;
                next;

            } elsif ($6) {
                # `include

                # !!! spec says only whitespace and comment is allowed on
                # the line, need to anchor to start-of-line somehow

                $self->{ws_text}    .= $6;

                $self->include ($7);
                next;

            } elsif ($8) {
                # `define

                $self->{ws_text} .= $8;

                $self->define ($9, defined ($10) ? $10 : "");
                next;

            } elsif ($25) {

                $self->{ws_text} .= $25;
                $self->undefine ($26);
                next;

            } elsif (defined ($11)) {

                # The `line directive specifies the line number of the next
                # line. Subtract one here; the line counter will be
                # incremented when the next line is read.
                $self->{line} = $11 - 1;
                $self->{file} = $12;

                # $13 is "level", with the following meanings:
                # 1: start of include file
                # 2: end of include file
                # 0: neither of the previous cases applies

                next;

            } elsif ($27) {
                # text macro reference

                $self->{ws_text}    .= "`$27";

                if (!$self->expand ($27)) {
                    VP3::error ("Undefined text macro, or unsupported compiler directive `$27");
                }

                next;

            } elsif ($14) {

                # !!! escape sequences

                if ($self->{buffer} =~ s/^([^"]*)"//) {
                    $tobj = VP3::ParseTree->factory ("string", $1);
                    $self->token ($tobj);
                    return ('STRING', $tobj);
                } else {
                    VP3::error ("Syntax error, unterminated string"); # !!! better error

                    # Assume the string was to terminate at EOL
                    $self->{buffer} =~ s/(.*)//;
                    $tobj = VP3::ParseTree->factory ("string", $1);
                    $self->token ($tobj);
                    return ('STRING', $tobj);
                }

            } elsif (defined ($18)) {

                $tobj = VP3::ParseTree->factory ("based_number", $15, $16, $17, $18);
                $self->token ($tobj);
                return ('BASED_NUMBER', $tobj);

            } elsif (defined ($19)) {

                $tobj = VP3::ParseTree->factory ("unsigned_number", $19);
                $self->token ($tobj);
                return ('UNSIGNED_NUMBER', $tobj);

            } elsif ($20) {

                my $tok = $20;
                $tobj = VP3::ParseTree->factory ("token", $tok);
                $self->token ($tobj);
                return ($tok, $tobj);

            } elsif ($21) {

                my $tok = $21;
                $tobj = VP3::ParseTree->factory ("token", $tok);
                $self->token ($tobj);
                return ($tok, $tobj);

            } elsif ($22) {

                $tobj = VP3::ParseTree->factory ("identifier", $22);
                $self->token ($tobj);
                return ('IDENTIFIER', $tobj);

            } elsif ($23) {

                $tobj = VP3::ParseTree->factory ("identifier", $23);
                $self->token ($tobj);
                return ('IDENTIFIER', $tobj);

            } elsif ($24) {

                $tobj = VP3::ParseTree->factory ("identifier", $24);
                $self->token ($tobj);
                return ('SYSTEM_IDENTIFIER', $tobj);

            } else {

                VP3::fatal ("in lexer, ST_DEFAULT, line $self->{line}, buffer: $self->{buffer}");

            }

        } else {

            # !!! high priority to make this non-fatal
            VP3::error_fatal ("Syntax error at:\n" . $self->{buffer});

        }

    } # while (1)

} # sub lex

sub flush_whitespace
{
    my ($self) = @_;

    return unless length $self->{ws_text};

    my $tobj = VP3::ParseTree->factory ("whitespace", $self->{ws_text});
    $self->{ws_text} = "";

    if (@{$self->{source}}) {
        # Preprocessor-generated tokens should not appear in output
        $tobj->visible (0);
    }

    #print Data::Dumper->Dump ([$tobj], ["ws_tok"]);

    push @{$self->{ws_toks}}, $tobj;
}

sub token
{
    my ($self, $tobj) = @_;
    $tobj->source_line ($self->{line});
    $tobj->source_file ($self->{file});

    $self->flush_whitespace;

    #print Data::Dumper->Dump ([$tobj], ["token"]);

    while (@{$self->{ws_toks}}) {
        $tobj->prepend (pop @{$self->{ws_toks}});
    }

    if (@{$self->{source}}) {
        # Preprocessor-generated tokens should not appear in output
        $tobj->visible (0);
    }

    # Grab whitespace after token up to newline. This allows more accurate
    # transcription of commented source in output (the single token has
    # enough information to determine whether adding an extra newline after
    # the directive is required)

    if ($self->{buffer} && $self->{buffer} =~ s/^(\s*\n)//) {
        $tobj->append_text ($1);
    }
}

sub depend
{
    my $self = shift;
    $self->{depend_cb} && $self->{depend_cb}->(@_);
}

sub include_path
{
    my ($self, $path) = @_;

    push @{$self->{includes}}, $path;
}

sub find_include
{
    my ($self, $file) = @_;

    $self->depend ("vinc", $file);

    for (@{$self->{includes}}) {
        my $path = File::Spec->catfile ($_, $file);

        return $path if -f $path;
    }

    return undef;
}

sub include
{
    my ($self, $ifile) = @_;
    my ($fh);

    my $file = $self->find_include ($ifile);
    unless ($file) {
        VP3::error ("Couldn't find include file $ifile");
        return;
    }

    &VP3::debug && print STDERR "Including $ifile ($file)\n";

    $self->flush_whitespace;
    unless ($fh = IO::File->new ($file)) {
        VP3::error ("can't open $file");
        return;
    }

    push @{$self->{source}}, [ $self->{file}, $self->{fh}, $self->{buffer}, $self->{line} ];

    $self->{fh} = $fh;
    $self->{buffer} = "";
    $self->{line} = 0;
}

sub define
{
    my ($self, $name, $value) = @_;

    &VP3::debug && print STDERR "Defining $name as `$value'\n";

    $self->{defines}->{$name} = $value;
}

sub undefine
{
    my ($self, $name) = @_;

    &VP3::debug && print STDERR "undef-ing $name\n";

    if (exists ($self->{defines}->{$name})) {
        delete $self->{defines}->{$name};
    } else {
        VP3::warning ("argument `$name' to `undef has not been defined");
    }
}

sub ifdef
{
    my ($self, $name) = @_;

}

sub expand
{
    my ($self, $name) = @_;
    my ($fh);

    if (!exists ($self->{defines}->{$name})) {
        return undef;
    }

    my $expn = $self->{defines}->{$name};

    # !!! detect recursion
    while ($expn =~ /`(\w+)/g) {
        if (!exists ($self->{defines}->{$1})) {
            VP3::error ("Undefined text macro `$1");
            return 1; # Suppress error
        }

        &VP3::debug && print STDERR "expand $1 as ", $self->{defines}->{$1}, "\n";
        substr ($expn, $-[1] - 1, $+[1] - $-[1] + 1) = $self->{defines}->{$1};
        pos ($expn) = $-[1] - 1;
    }

    $self->flush_whitespace;
    $fh = IO::File->new;

    # Calling IO::File->open to read from a scalar works in 5.10 but not 5.8.8

    CORE::open ($fh, "<", \$expn)
        or VP3::fatal ("unable to open string as a filehandle: $!");

    push @{$self->{source}}, [ $self->{file}, $self->{fh}, $self->{buffer}, $self->{line} ];

    $self->{file} = undef;
    $self->{fh} = $fh;
    $self->{buffer} = "";
    $self->{line} = 0;

    return 1;
}

1;

# vim: sts=4 sw=4 et
