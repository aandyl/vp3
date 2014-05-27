{
    package VP3::RTLTool::Preprocessor::standard;

    # This routine requires a clean lexical environment
    sub _eval
    {
        eval "package $_[0]->{pkg_name}; $_[1]";
    }

    use IO::File;
    use Getopt::Long;
    use Carp;
    use File::Spec;

    use Symbol qw();

    use constant {
        ST_DEFAULT => 0,
        ST_COMMENT => 1,
        ST_PERL    => 2,
    };

    my $package_counter = 0;

    my %defer_directives;
    for (qw(Module Ports Regs Wires Vector Input Output Waive Unparsed Instance)) {
        $defer_directives{$_} = 1;
    }

    # This is a reduced version of the full Verilog lexer in VP3::Lexer. The
    # two need to be kept roughly in sync.

    # In /* */ comments
    my $re_comment_body = qr/\G(?:
         (.*?\*\/)              # $1: comment terminator
        |((?s).*$)              # $2: anything else
    )/x;

    my $re_directive = qr/\G^(\s*)\@(\w+)\s*(.*\n)$/;

    my $re_default = qr/\G(.*?)(?:                  # $1: unparsed text
         (\/\*)                                     # $2: start of multiline comment
        |(\/\/.*\n)                                 # $3: single line comment
        |(")                                        # $4: string
        |(?:(\\[^\s]+)(?=\s))                       # $5: escaped identifier
        |(\n$)                                      # $6: end-of-line
    )/x;

    sub new
    {
        my ($class, $vp3) = @_;

        my $pkg_name  = "VP3::RTLTool::Preprocessor::standard::GEN" . $package_counter++;

        my $self = {
            conditionals    => VP3::Conditionals->new,
            include_paths   => [ ],
            defines         => { },
            enabled         => 1,
            stack           => [ ],
            state           => ST_DEFAULT,
            fh              => undef,
            perl_start      => undef,
            pkg_name        => $pkg_name,
            pkg_stash       => do { no strict 'refs'; \%{$pkg_name . '::'} },
            depends         => [ ],
            depends_mode    => 0,
        };
        bless $self, $class;

        no strict 'refs';
        *{$self->{pkg_name} . '::vprint'} = sub {
            print { $self->{output} } @_;
        };

        ${$self->{pkg_name} . '::vp3'} = $vp3;

        VP3::RTLTool::UserFunctions::install ($self->{pkg_name});

        $self;
    }

    sub DESTROY
    {
        Symbol::delete_package ($_[0]->{pkg_name});
    }

    sub depends_mode {
        $_[0]->{depends_mode} = $_[1];
    }

    sub depends {
        @{$_[0]->{depends}};
    }

    sub depend {
        push @{$_[0]->{depends}}, [ @_[1..$#_] ];
    }

    sub includes { push @{$_[0]->{include_paths}}, @_[1..$#_]; }

    sub include
    {
        my ($self, $ifile) = @_;
        my $fh;
        my @search;

        $self->depend ("inc", $ifile);

        push @search, grep { -f $_ } map (File::Spec->catfile ($_, $ifile), @{$self->{include_paths}});
        push @search, $ifile if -f $ifile;

        for (@search) {
            unless ($fh = IO::File->new ($_)) {
                VP3::warning ("can't open $_: $!");
                next;
            }

            push @{$self->{stack}}, $self->{fh};
            $self->{fh} = $fh;
            return;
        }

        VP3::error ("couldn't find include file $ifile");
    }

    sub define
    {
        my ($self, $name, $value) = @_;

        $self->{defines}->{$name} = { value => $value };
    }

    # sub _eval is defined at the start of the file, to provide a clean lexical
    # environment

    sub emit_line_marker
    {
        my $self = shift;

        print { $self->{output} } qq{`line },
                                  $self->{fh}->input_line_number,
                                  qq{ "}, $self->{filename}, qq{" 0\n};
    }

    sub expand_macros
    {
        my $self = shift;

        # !!! detect recursion
        while ($_[0] =~ /\G\W*\b(\w+)\b/gc) {
            if (exists ($self->{defines}->{$1})) {
                my $start = $-[1];
                my $end = $+[1];

                my $name = $1;
                my $d = $self->{defines}->{$name};
                if (!$d->{args}) {
                    &VP3::debug && print STDERR "expand $name as $d->{value}\n";
                    substr ($_[0], $start, $end - $start) = $d->{value};
                } else {
                    my (@supplied_args, $va_args);

                    unless ($_[0] =~ /\G\s*\(([^\(\)]*)\)/gc) {
                        VP3::error ("Expected arguments for macro $name");
                        next;
                    }

                    $end = $+[0];

                    @supplied_args = split (',', $1, -1);

                    if ($d->{args}->[-1] eq "...") {
                        $va_args = join (",", @supplied_args[$#{$d->{args}} .. $#supplied_args]);
                        $#supplied_args = $#{$d->{args}} - 1;
                    }

                    my $expansion = $d->{value};

                    if (defined ($va_args)) {
                        $expansion =~ s/\b__VA_ARGS__\b/$va_args/g;
                    }

                    # @supplied_args is one shorter than @{$d->{args}} in the
                    # $va_args case.
                    for (my $i = 0; $i <= $#supplied_args; $i++) {
                        my $arg = $d->{args}->[$i];
                        $expansion =~ s/\b$arg\b/$supplied_args[$i]/g;
                    }

                    $expansion =~ s/##//g; # token paste
                    $expansion =~ s/_&nl&_/\n/g;

                    &VP3::debug && print STDERR "expand $name (" . join (",", @supplied_args) . ") as $expansion\n";
                    substr ($_[0], $start, $end - $start) = $expansion;

                }

                pos ($_[0]) = $start;
            }
        }
    }

    sub getline
    {
        my $self = shift;

        while (1) {
            my $tmp = $self->{fh}->getline;

            return $tmp if defined ($tmp);

            if (@{$self->{stack}}) {
                $self->{fh} = pop @{$self->{stack}};
                next;
            } else {
                return undef;
            }
        }

    }

    sub process
    {
        my ($self, $args) = @_;

        $self->{filename} = $args->{input};

        $self->{fh} = IO::File->new ($self->{filename}, "r")
            or die "Couldn't open `$self->{filename}': $!";

        $self->{output} = IO::File->new ($args->{output}, "w")
            or die "Couldn't open `$args->{output}': $!";

        my $line = "";
        my $emit_line_marker = 1;

        while (1) {

            if ($line eq "" || $line =~ /\G\z/) {
                $line = $self->getline;
                last unless defined ($line);
            }

            if ($emit_line_marker) {
                $self->emit_line_marker;
                $emit_line_marker = 0;
            }

            if ($self->{state} == ST_COMMENT && $line =~ m/$re_comment_body/gc) {

                if ($1) {
                    # comment ends
                    print { $self->{output} } $1;
                    $self->{state} = ST_DEFAULT;
                    next;
                } elsif ($2) {
                    # comment continues
                    print { $self->{output} } $2;
                    next;
                } else {
                    VP3::fatal ("in preprocessor, ST_COMMENT");
                }

            } elsif ($self->{state} == ST_PERL) {

                $line =~ m/$re_directive/gc;
                my ($indent, $directive, $rest) = ($1, $2, $3);

                if (!defined ($directive) || $directive ne "perl_end") {
                    $self->expand_macros ($line);
                    $self->{perl_text} .= $line;
                    $line = "";
                    next;
                } else {
                    $self->_eval ($self->{perl_text});
                    if ($@) {
                        chomp $@;
                        VP3::error ("in perl section starting on line " . $self->{perl_start} . ":",
                                    $@);
                    }
                    $self->{perl_text} = "";
                    $self->{state} = ST_DEFAULT;
                    $self->{perl_start} = undef;
                    $line = "";
                    $emit_line_marker = 1;
                    next;
                }

            } elsif ($self->{state} == ST_DEFAULT && $line =~ m/$re_directive/gc) {

                my $more = "";

                while ($line =~ /\\\n$/ && defined ($more)) {
                    $more = $self->getline;
                    $line .= $more if defined ($more);
                }

                # Re-match after reading continuation lines
                $line =~ m/$re_directive/;
                my ($indent, $directive, $rest) = ($1, $2, $3);

                if ($directive eq "include") {
                    if ($rest =~ /^"(.+)"\s*$/) {
                        $self->include ($1);
                    } else {
                        VP3::error ("Illegal \@include directive");
                    }

                    next;
                } elsif ($directive eq "depend") {
                    if ($rest =~ /^"(.+)"\s*$/) {
                        # Note that $self->depend is not purely a
                        # directive-implementing function
                        $self->depend ("inc", $1);
                    } else {
                        VP3::error ("Illegal \@depend directive");
                    }

                    next;
                } elsif ($directive eq "ifdef") {
                    if ($rest =~ /^(\w+)\s*$/) {
                        my $cond = exists ($self->{defines}->{$1});

                        $self->{enabled} = $self->{conditionals}->ifdef ($cond);

                        print { $self->{output} } ("\n");
                    } else {
                        VP3::error ("Illegal \@ifdef directive");
                    }

                    next;
                } elsif ($directive eq "ifndef") {
                    if ($rest =~ /^(\w+)\s*$/) {
                        my $cond = !exists ($self->{defines}->{$1});

                        $self->{enabled} = $self->{conditionals}->ifdef ($cond);

                        print { $self->{output} } ("\n");
                    } else {
                        VP3::error ("Illegal \@ifndef directive");
                    }

                    next;
                } elsif ($directive eq "elsif" && $rest =~ /^(\w+)\s*$/) {
                    # Only "@elsif FOO" handled here (i.e., else ifdef FOO).
                    # Otherwise the line is macro-expanded before the directive is
                    # processed.
                    my $cond = exists ($self->{defines}->{$1});

                    $self->{enabled} = $self->{conditionals}->elsif ($cond);

                    print { $self->{output} } ("\n");
                    $emit_line_marker = 1;
                    next;
                } elsif ($directive eq "else") {
                    $self->{enabled} = $self->{conditionals}->else;
                    print { $self->{output} } ("\n");
                    $emit_line_marker = 1;
                    next;
                } elsif ($directive eq "endif") {
                    $self->{enabled} = $self->{conditionals}->endif;
                    print { $self->{output} } ("\n");
                    $emit_line_marker = 1;
                    next;
                } elsif ($directive eq "define") {
                    unless ($rest =~ /^(\w+)\s(.*)$/) {
                        VP3::error ("Illegal \@define directive: $rest");
                        next;
                    }

                    my ($name, $value) = ($1, $2);
                    if (exists ($self->{defines}->{$name})) {
                        # !!! give location
                        VP3::warning ("Redefinition of $name");
                    }

                    &VP3::debug && print STDERR "define $name as $value\n";

                    $self->{defines}->{$name} = { value => $value };

                    print { $self->{output} } ("\n");
                    next;
                } elsif ($directive eq "macro") {
                    $rest =~ /^(\w+)\(([\w,]+(?:\.\.\.)?)\)\s(.*)$/ or do { VP3::error ("Illegal \@macro directive: $rest"); next };
                    my ($name, $args, $value) = ($1, $2, $3);

                    if (exists ($self->{defines}->{$name})) {
                        # !!! give location
                        VP3::warning ("Redefinition of $name");
                    }

                    &VP3::debug && print STDERR "define $name as $value\n";

                    $self->{defines}->{$name} = {
                        value => $value,
                        args => [ split (',', $args) ],
                    };

                    print { $self->{output} } ("\n");
                    next;
                } elsif ($directive eq "perl_begin") {
                    $rest =~ /^$/ or VP3::error ("Illegal \@perl_begin directive");
                    $self->{state} = ST_PERL;
                    $self->{perl_start} = $self->{fh}->input_line_number;
                    next;
                } elsif ($directive eq "if") {
                    $self->expand_macros ($rest);

                    my $cond = $self->_eval ($rest);

                    if ($@) {
                        chomp $@;
                        VP3::error ("while evaluating conditional:",
                                    $@);
                        $cond = 0;
                    }

                    $self->{enabled} = $self->{conditionals}->ifdef ($cond);

                    print { $self->{output} } ("\n");
                    next;
                } elsif ($directive eq "elsif") {
                    $self->expand_macros ($rest);

                    my $cond = $self->_eval ($rest);

                    if ($@) {
                        chomp $@;
                        VP3::error ("while evaluating conditional:",
                                    $@);
                        $cond = 0;
                    }

                    $self->{enabled} = $self->{conditionals}->elsif ($cond);

                    print { $self->{output} } ("\n");
                    next;
                } elsif (exists ($self->{pkg_stash}->{$directive}) && defined (*{$self->{pkg_stash}->{$directive}}{CODE})) {
                    $self->expand_macros ($rest);

                    eval "package $self->{pkg_name}; $directive (\$rest)";

                    if ($@) {
                        chomp $@;
                        VP3::error ("while expanding directive:",
                                    $@);
                    }

                    $emit_line_marker = 1;
                    next;
                } elsif (!exists ($defer_directives{$directive})) {
                    VP3::error ("unknown directive $directive");
                    next;
                } else {
                    $self->expand_macros ($rest);
                    print { $self->{output} } $line;
                }

            } else {

                $line =~ m/$re_default/gc;

                my $lead_text;

                if ($self->{enabled}) {
                    $lead_text = $1;
                    $self->expand_macros ($lead_text);
                    print { $self->{output} } $lead_text;
                }

                if ($2) {
                    # Start of multiline comment

                    print { $self->{output} } $2;
                    $self->{state} = ST_COMMENT;
                    next;
                } elsif ($3) {
                    # Single-line comment

                    print { $self->{output} } $3;
                    next;
                } elsif ($4) {
                    # String

                    if ($line =~ m/\G([^"]*)"/gc) {

                        if ($self->{enabled}) {
                            print { $self->{output} } q{"}, $1, q{"};
                        }

                        next;

                    } else {
                        VP3::error ("Syntax error, unterminated string"); # !!! better error

                        # Assume the string was to terminate at EOL

                        if ($self->{enabled}) {
                            print { $self->{output} } q{"}, $line;
                        }

                        $line = "";
                        next;
                    }
                } elsif ($5) {
                    # Escaped identifier

                    if ($self->{enabled}) {
                        print { $self->{output} } $5;
                    }
                } elsif ($6) {
                    # Reached end-of-line.

                    print { $self->{output} } $6;
                }

            }

        }

        $self->{fh}->close;
        $self->{output}->close;

        return !$VP3::error_count ? 1 : undef;
    }

} # package VP3::RTLTool::Preprocessor::standard

{
    package VP3::RTLTool::Preprocessor::ep3;

    use File::Temp qw();

    for (qw(Module Ports Regs Wires Vector Input Output Waive Unparsed Instance)) {
        # In depends mode, EP3 closes the default filehandle.
        no warnings 'unopened';
        eval "sub Text::EP3::$_ { print \$_[1] }";
    }

    sub new
    {
        require Text::EP3;

        VP3::RTLTool::UserFunctions::install ("Text::EP3");

        my ($class, $vp3) = @_;
        my $self = {
            ep3 => Text::EP3->new,
            defines => [ ],
            vp3 => $vp3,
        };
        bless $self, $class;
    }

    sub depends_mode
    {
        $_[0]->{depends_mode} = $_[1];
    }

    sub depends
    {
        return map [ "inc", $_ ], @{$_[0]->{depends}};
    }

    sub includes { $_[0]->{ep3}->ep3_includes (@_[1..$#_]); }

    sub define
    {
        my ($self, $key, $value) = @_;

        # EP3 chokes if there's no value (no equals sign) when defining things
        # via ep3_defines, so always include the equals sign.
        push @{$self->{defines}}, join ("=", $key, defined ($value) ? $value : "");
    }

    sub process
    {
        my ($self, $args) = @_;

        no warnings 'once';
        local $Text::EP3::vp3 = $self->{vp3};

        if ($self->{depends_mode}) {
            my $depends_output = File::Temp->new;

            # In depends mode, run ep3 twice: once to get the dependencies, and
            # again to get the output. Need to run the depends pass in a
            # subprocess so the second pass has a clean namespace.
            my $pid = fork;

            unless (defined ($pid)) {
                VP3::error_fatal ("Failed to fork: $!");
            }

            if (!$pid) {
                # Child

                $depends_output->unlink_on_destroy (0);

                $self->{ep3}->ep3_gen_depend_list (1);
                $self->{ep3}->ep3_output_file ($depends_output->filename);
                @{$self->{ep3}->{Defines}} = @{$self->{defines}};
                $self->{ep3}->ep3_defines;
                my $result = eval { $self->{ep3}->ep3_process ($args->{input}); };

                if (!defined ($result)) {
                    chomp $@;
                    print STDERR "EP3 error: $@";
                    exit 1;
                }

                # The following can be used when running ep3 in-process to
                # force it to flush and close the file so we get all the
                # dependencies.
                #$self->{ep3}->ep3_output_file ("STDOUT");

                exit 0;
            } else {
                # Parent

                if (wait() == -1) {
                    VP3::error_fatal ("Should have a child process here.");
                }

                my $result = $?;

                open (my $fh, "<", $depends_output)
                    or VP3::error_fatal ("Failed to open ep3 depends output: $!");

                chomp (@{$self->{depends}} = <$fh>);

                if ($?) {
                    return undef;
                }

            }
        }

        $self->{ep3}->ep3_output_file ($args->{output});
        @{$self->{ep3}->{Defines}} = @{$self->{defines}};
        $self->{ep3}->ep3_defines;
        my $result = eval { $self->{ep3}->ep3_process ($args->{input}); };

        if (!defined ($result)) {
            chomp $@;
            VP3::error ("EP3 error: $@");
            return undef;
        }

        # Close the output
        $self->{ep3}->ep3_output_file ("STDOUT");

        return 1;
    }

} # package VP3::RTLTool::Preprocessor::ep3

1;

# vim: sts=4 sw=4 et
