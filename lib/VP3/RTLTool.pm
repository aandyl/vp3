{

    package VP3::RTLTool::Expander;
    use base 'VP3::ParseTreeMutator';

    use Getopt::Long;
    use Carp;

    sub new
    {
        my ($class, $vp3) = @_;
        my $self = $class->SUPER::new;
        $self->{vp3} = $vp3;
        bless $self, $class;
    }

    sub visit_vp3_instance_directive
    {

        my ($self, $target) = @_;
        my $rtn;

        # Make regexes for rename rules
        for (@{$target->renames}) {
            if ($_->[0] !~ m{^/(.*)/$}) {
                # Replacements without slashes must match the whole string, add ^ and $ anchors
                $_->[0] = qr/^$_->[0]$/;
            } else {
                # Replacements with slashes can be any regular expression; need
                # to remove the slashes before using it in perl.
                $_->[0] =~ s{(^/)|(/$)}{}g;
                $_->[0] = qr/$_->[0]/;
            }
        }

        my $I;
        my $dtext = VP3::ParseTree->factory ("whitespace", VP3::Utils::directive_comment ($target, \$I));

        my $ports;
        if ($target->file) {
            $ports = $self->{vp3}->ports ($target->module, $target->file);
        } else {
            $ports = $self->{vp3}->ports ($target->module);
        }

        # This error can fire either because the module was not found or
        # because we had a problem parsing it.
        unless ($ports) {
            VP3::error ("Can't auto-instance `" . $target->module . "' without its definition");
            return VP3::ParseTree->factory (whitespace => $target->emit);
        }

        my $comma = " ";

        $rtn .= "${I}" . $target->module . " " . $target->instance_name . " (\n";
        for (@{$ports->all_ports}) { # VP3::Ports
            my $name = $_->{name};
            my $cxn  = $name;
            my $msb = $_->{msb};
            my $lsb = $_->{lsb};
            (defined ($msb) ^ defined ($lsb))
                and confess "Internal error, half-valid range";

            for (@{$target->renames}) {
                # Should put more thought into how exactly to do this
                $cxn =~ s/$_->[0]/"\"$_->[1]\""/ee;
                    #and print STDERR "-connect: $name ( $cxn )\n";
            }

            my $range = "";
            # If the hiconn is an identifier (as opposed to an expression), and
            # the loconn is a vector, then add the range of the loconn vector
            # to the hiconn identifier
            if ($cxn =~ /^(?:
                             (?:[a-zA-Z_][a-zA-Z0-9_\$]*)   # identifier
                            |(?:\\[^\s]+\s)                 # escaped identifier
                          )$/x && defined ($msb)) {
                $range = "[" . $msb . ":" . $lsb . "]";
            }
            $rtn .= "${I}${comma}.$name($cxn$range)\n";
            $comma = ",";
        }
        $rtn .= "${I});\n";

        # Errors here are a bit tricky. If the error results from verilog we
        # generated, then that can be considered a fatal error. If the error
        # results from something the user put in a port connect expression,
        # then it's a normal error.
        my ($tree, $error);
        unless ($tree = $self->parse ("VP3_PARSE_MODE_MODULE_ITEMS", $rtn, \$error)) {
            VP3::error ("While parsing generated instantiation:\n$error\nInstantiation follows:\n$rtn");
            return $dtext;
        }

        $tree->location_set_recursive ($target->directive_keyword->source_file,
                                       $target->directive_keyword->source_line);

        # Return the new tree; will replace the vp3_instance_directive node
        ($dtext, $tree->type ne "null" ? @{$tree->children} : VP3::ParseTree->factory ("whitespace", $rtn));

    }

}

{

    package VP3::RTLTool::Translator;
    use base 'VP3::ParseTreeMutator';

    use Data::Dumper;

    sub new
    {
        my ($class, $rt) = @_;
        my $self = $class->SUPER::new;
        $self->{rt} = $rt;
        bless $self, $class;
    }

    sub visit_module_declaration
    {
        my ($self, $target) = @_;

        $self->{module} = $target;

        $self->{default}->($self, $target);

        undef $self->{module};

        $target;
    }

    sub visit_vp3_module_declaration
    {
        my ($self, $target) = @_;
        my $mod;

        $self->{module} = $target;

        # For v2k-style module headers, we expand the header before the module
        # contents, so that we can suppress duplicate reg/wire declarations for
        # ports. For non-v2k module headers, we expand the header after the
        # module contents, so we can copy whatever @Ports did (or didn't do).

        # Note that, when visiting a vp3_module_directive object, the visitor
        # returns the results of parsing a module_header (which is a partially
        # formed ParseTree::module_declaration object).

        if ($target->vp3_module_directive->v2k) {
            $mod = $self->visit ($target->vp3_module_directive);

            $mod->append_children ($self->visit ($target->module_items));
            $mod->append_children ($self->visit ($target->endmodule_keyword));
        } else {
            my $module_items = $self->visit ($target->module_items);
            my $endmodule_keyword = $self->visit ($target->endmodule_keyword);

            $mod = $self->visit ($target->vp3_module_directive);

            $mod->append_children ($module_items);
            $mod->append_children ($endmodule_keyword);
        }

        undef $self->{module};

        $mod;
    }

    sub visit_vp3_ports_directive
    {
        my ($self, $target) = @_;
        my $output = "";

        my $module = $self->{module}->module_identifier;

        my $indent;
        my $dtext = VP3::ParseTree::factory ("whitespace", VP3::Utils::directive_comment ($target, \$indent));

        my $conndb = $self->{rt}{connectivity}{$module};
        for my $ident (sort $conndb->signals) {
            my $signal_obj = $conndb->signal ($ident);

            next if $self->{module}->symtab->lookup ($ident); # Skip signals declared in source
            my %decl = $signal_obj->implicit_declaration_type;
            my $range = $signal_obj->implicit_declaration_range;
            if ($decl{input}) {
                $output .= "${indent}input "  . $range . " " . $ident . ";\n";
                # Do not insert in symbol table, will be declared later as reg or wire
                #$self->{module}->symtab->insert ($ident => "input");
                my $conn = VP3::Connectivity->new (undef, "input", "source");
                $signal_obj->add_connectivity ($conn);
            }
            if ($decl{output}) {
                $output .= "${indent}output " . $range . " " . $ident . ";\n";
                # Do not insert in symbol table, will be declared later as reg or wire
                #$self->{module}->symtab->insert ($ident => "output");
                my $conn = VP3::Connectivity->new (undef, "output", "sink");
                $signal_obj->add_connectivity ($conn);
            }
        }

        my ($tree, $error);
        $tree = $self->parse ("VP3_PARSE_MODE_MODULE_ITEMS", $output, \$error)
            or die "While parsing generated port declarations:\n$error\nDeclarations follow:\n$output";

        $tree->location_set_recursive ($target->directive_keyword->source_file,
                                       $target->directive_keyword->source_line);

        ($dtext, $tree->type ne "null" ? @{$tree->children} : VP3::ParseTree->factory ("whitespace", $output));
    }

    sub visit_vp3_regs_directive
    {
        my ($self, $target) = @_;
        my $output = "";

        my $module = $self->{module}->module_identifier;

        my $indent;
        my $dtext = VP3::ParseTree::factory ("whitespace", VP3::Utils::directive_comment ($target, \$indent));

        my $conndb = $self->{rt}{connectivity}{$module};
        for my $ident (sort $conndb->signals) {
            my $signal_obj = $conndb->signal ($ident);

            next if $self->{module}->symtab->lookup ($ident); # Skip signals declared in source
            my %decl = $signal_obj->implicit_declaration_type;
            my $range = $signal_obj->implicit_declaration_range;
            $decl{reg} and $output .= "${indent}reg "  . $range . " " . $ident . ";\n";
        }

        my ($tree, $error);
        $tree = $self->parse ("VP3_PARSE_MODE_MODULE_ITEMS", $output, \$error)
            or die "While parsing generated reg declarations:\n$error\nDeclarations follow:\n$output";

        $tree->location_set_recursive ($target->directive_keyword->source_file,
                                       $target->directive_keyword->source_line);

        ($dtext, $tree->type ne "null" ? @{$tree->children} : VP3::ParseTree->factory ("whitespace", $output));
    }

    sub visit_vp3_wires_directive
    {
        my ($self, $target) = @_;
        my $output = "";

        my $module = $self->{module}->module_identifier;

        my $indent;

        my $dtext = VP3::ParseTree::factory ("whitespace", VP3::Utils::directive_comment ($target, \$indent));

        #print Dumper ($self->{rt}{connectivity});
        my $conndb = $self->{rt}{connectivity}{$module};
        for my $ident (sort $conndb->signals) {
            #&VP3::debug && print STDERR "considering $ident\n";
            my $signal_obj = $conndb->signal ($ident);

            next if $self->{module}->symtab->lookup ($ident); # Skip signals declared in source
            my %decl = $signal_obj->implicit_declaration_type;
            my $range = $signal_obj->implicit_declaration_range;
            $decl{wire} and $output .= "${indent}wire "  . $range . " " . $ident . ";\n";
        }

        my ($tree, $error);
        $tree = $self->parse ("VP3_PARSE_MODE_MODULE_ITEMS", $output, \$error)
            or die "While parsing generated wire declarations:\n$error\nDeclarations follow:\n$output";

        $tree->location_set_recursive ($target->directive_keyword->source_file,
                                       $target->directive_keyword->source_line);

        ($dtext, $tree->type ne "null" ? @{$tree->children} : VP3::ParseTree->factory ("whitespace", $output));
    }

    sub visit_passthrough_directive
    {
        my ($self, $target) = @_;
        VP3::ParseTree->factory ("whitespace", VP3::Utils::directive_comment ($target));
    }

    {
        no warnings 'once';

        *visit_vp3_vector_directive = \&visit_passthrough_directive;
        *visit_vp3_force_directive = \&visit_passthrough_directive;
        *visit_vp3_waive_directive = \&visit_passthrough_directive;
    }

    sub visit_vp3_module_directive
    {
        my ($self, $target) = @_;
        my $output = "";

        my $module = $target->module_identifier;
        my $indent;

        my $dtext = VP3::ParseTree::factory ("whitespace", VP3::Utils::directive_comment ($target, \$indent));

        my $tree;

        if ($target->opt_none) {
            $tree = VP3::ParseTree->factory ("null", $dtext);
        } else {
            my $attr = $target->attr;
            if ($attr && length ($attr) > 60) {
                $attr = "(* ${attr} *)\n${indent}";
            } elsif ($attr) {
                # Empty string is false, which is what we want
                $attr = "(* ${attr} *) ";
            } else {
                $attr = "";
            }

            $output .= "${indent}${attr}module " . $module . " (\n";

            my $conndb = $self->{rt}{connectivity}{$module};
            my $comma = "  ";
            for my $ident (sort $conndb->signals) {
                my $signal_obj = $conndb->signal ($ident);
                my $symtab_entry = $self->{module}->symtab->lookup ($ident);
                my %decl = $signal_obj->implicit_declaration_type;

                # The behavior of @Module is different in v2k and non-v2k mode, as
                # described in the documentation. In v2k mode, @Module only
                # generates inferred ports (hence we condition on
                # implicit_declaration_type specifying input or output). In non-v2k
                # mode, we generated explicit and inferred ports, so generation is
                # conditioned on actual connectivity.
                if ($target->v2k && !$symtab_entry && ($decl{input} || $decl{output})) {
                    my $dir   = $decl{input} ? "input"  : "output";
                    my $src   = $decl{input} ? "source" : "sink"  ;
                    my $type  = $decl{reg}   ? "reg"    : "wire"  ;
                    my $range = $signal_obj->implicit_declaration_range;

                    $output .= "${indent}    ${comma}${dir} ${type} ${range} ${ident}\n";
                    $comma = ", ";

                    # Inserting in symbol table here prevents a duplicate
                    # declaration by @Regs/@Wires
                    $self->{module}->symtab->insert ($ident => $dir);
                    my $conn = VP3::Connectivity->new (undef, $dir, $src);
                    $signal_obj->add_connectivity ($conn);
                } elsif (!$target->v2k &&
                         ($signal_obj->input_connection ||
                          $signal_obj->output_connection)) {
                    $output .= "${indent}    ${comma}${ident}\n";
                    $comma = ", ";
                }
            }

            $output .= "${indent});\n";

            my ($error);
            $tree = $self->parse ("VP3_PARSE_MODE_MODULE_HEADER", $output, \$error)
                or die "While parsing generated module header:\n$error\nHeader follow:\n$output";

            $tree->prepend ($dtext);
        }

        $tree->location_set_recursive ($target->directive_keyword->source_file,
                                       $target->directive_keyword->source_line);

        $tree;
    }

} # package VP3::RTLTool::Translator

{
    package VP3::RTLTool::UserFunctions;

    my (@list) = qw(vexpr vports);

    sub install
    {
        my ($where) = $_[0];

        no strict 'refs';

        for my $f (@list) {
            *{$where . '::' . $f} = sub { $f->(${$where . '::vp3'}, @_) };
        }
    }

    sub vexpr {
        my $vp3 = shift;
        my $text = join (" ", @_);

        my $mod = VP3::ParseTree->factory ("module_declaration");

        my $p = VP3::Parser->new;
        $p->scope ($mod);
        $p->YYData->{lexer} = VP3::Lexer->new ("VP3_PARSE_MODE_EXPRESSION");

        open (my $fh, "<", \$text)
            or VP3::fatal ("unable to open string as a filehandle: $!");
        $p->YYData->{lexer}->input ($fh, undef);

        my $expr = $p->YYParse (
            yylex   => sub { $_[0]->YYData->{lexer}->lex (@_[1..$#_]) },
            yyerror => \&VP3::Parser::default_yyerror,
        );

        if (!$expr) {
            VP3::error ("parse error in vexpr: " . $p->YYData->{error});
            return "";
        }

        VP3::Expression::evaluate ($mod, $expr);
    }

    sub vports {
        my $vp3 = shift;
        $vp3->ports (@_);
    }

}

package VP3::RTLTool;

use VP3;
use VP3::RTLTool::Preprocessor;
use VP3::RTLTool::Connectivity;

use Data::Dumper;
use IO::Handle;
use IO::File;
use IO::Seekable; # For SEEK_SET
use Getopt::Long;
use File::Temp qw();
use File::Copy qw();
use Scalar::Util qw(blessed);

# This string is written at the start of generated files. In certain cases, we
# check for this string before overwriting a file, so be careful adding
# versions or timestamps.
our ($signature) = "// Generated by vp3";

sub new
{
    my $class = shift;
    my $self = {
        preprocessor    => "standard",
        output          => "-",
        pp_defines      => [ ],
        pp_includes     => [ "." ],
    };

    my (%vp3_args);

    GetOptions (
        "o=s"           => \$self->{output},
        "depends"       => \$self->{depends_mode},
        "p=s"           => \$self->{preprocessor},
        "debug"         => \$VP3::debug,
        "define=s\@"    => $self->{pp_defines},
        "include=s\@"   => $self->{pp_includes},
        "vdefine=s\@"   => \$vp3_args{v_defines},
        "vinclude=s\@"  => \$vp3_args{v_includes},
        "v=s\@"         => \$vp3_args{library_files},
        "y=s\@"         => \$vp3_args{library_dirs},
        "w"             => \$self->{warnings_as_errors},
    ) or VP3::error ("Invalid command line options");

    if (@ARGV != 1) {
        die "Usage: vp3 [<options>] <input_file>\n" .
            "\n" .
            "Run `perldoc $0` for detailed help.\n";
    }

    unless ($self->{vp3} = VP3->new (%vp3_args)) {
        VP3::error_fatal ("failed to create vp3 object");
    }

    $self->{input}    = $ARGV[0];
    $self->{basename} = $self->{input};
    $self->{basename} =~ s/\..*//;
    $self->{pass1out} = File::Temp->new;

    if ($self->{output} ne "-" && $self->{output} eq $self->{input}) {
        VP3::error_fatal ("will not overwrite input file with output");
    }

    bless $self, $class;
}

# Work around for bug in interaction between File::Copy and File::Temp.
# File::Copy chokes on File::Temp objects because they overload
# stringify but not eq. Believe this is fixed in newer perls.

sub file_copy
{
    my ($a, $b) = @_;

    if (blessed ($a) && $a->isa ("File::Temp")) {
        $a = IO::Handle->new_from_fd ($a->fileno, "r")
            or VP3::error_fatal ("new_from_fd failed: $!");
    }

    if (blessed ($b) && $b->isa ("File::Temp")) {
        $b = IO::Handle->new_from_fd ($b->fileno, "w")
            or VP3::error_fatal ("new_from_fd failed: $!");
    }

    File::Copy::copy ($a, $b);
}

sub write_debug_file
{

    my ($self, $desc, $output) = @_;

    if ($self->{depends_mode}) {
        # Don't generate debug files in depends mode.
        return;
    }

    my $save_file = $self->{input} . ".debug";
    my $fh;

    if (-f $save_file) {
        # File already exists. Overwrite only if it looks like previous VP3 output.

        unless ($fh = IO::File->new ($save_file, "r+")) {
            VP3::error ("couldn't open $save_file: $!");
            print STDERR "${desc} not saved to $save_file due to error\n";
            return;
        }

        my $line = $fh->getline;
        if (!$line || $line ne "$signature\n") {
            print STDERR "${desc} not saved because $save_file already exists\n";
            return;
        }

        unless ($fh->truncate (0) && $fh->seek (0, SEEK_SET)) {
            VP3::error ("error truncating $save_file");
            print STDERR "${desc} not saved to $save_file due to error\n";
            return;
        }
    } else {
        # File doesn't exist.

        unless ($fh = IO::File->new ($save_file, O_WRONLY | O_CREAT | O_EXCL)) {
            VP3::error ("couldn't open $save_file: $!");
            print STDERR "${desc} not saved to $save_file due to error\n";
            return;
        }
    }

    file_copy ($output, $fh);

    print STDERR "${desc} has been saved in $save_file\n";

}

sub parse_pass1out
{
    my ($self) = @_;
    my $error;
    my $vdb;

    {
        # Insert the signature line before we parse, so line numbers in error
        # messages will match up
        my $tmp = File::Temp->new;
        $tmp->print ("$signature\n\n");
        $tmp->flush;

        file_copy ($self->{pass1out}->filename, $tmp);
        $tmp->flush;
        $self->{pass1out} = $tmp;
    }

    my $fh = IO::File->new ($self->{pass1out}->filename, "r")
        or VP3::error_fatal ("can't open " . $self->{pass1out}->filename . " for reading: $!");

    my $depend_cb = sub {
        $self->{vp3}->depend (@_);
    };

    $vdb = $self->{vdb} = $self->{vp3}->parse ($fh,
                                               $self->{input},
                                               $self->{basename},
                                               $depend_cb,
                                               \$error);

    unless ($vdb) {
        VP3::error ($error);
        $self->write_debug_file ("Preprocessor output", $self->{pass1out}->filename);
        return undef;
    }

    return 1;
}

sub analyze
{
    my ($self) = @_;
    my $vdb = $self->{vdb};
    my $conn_db;

    #print STDERR "*** BEGIN analyze $self->{pass1out} parse tree ***\n";
    #print STDERR Dumper ($self->{vdb});
    #print STDERR "*** END analyze $self->{pass1out} parse tree ***\n";

    my %instantiations;

    # Collect the list of all instantiations in each module
    for ($vdb->modules) {
        my $module = $_->module_identifier;

        if (exists ($instantiations{$module})) {
            VP3::error ("Multiple definitions found for module $module");
            next;
        }

        $instantiations{$module} = [ ];

        # !!! does not support generate blocks
        for (@{$_->module_items->children}) {
            #print "examining module_item, type ", $_->type, "\n";
            if ($_->typeis ("vp3_instance_directive")) {
                push @{$instantiations{$module}}, $_->module;
            } elsif ($_->typeis ("module_instantiation")) {
                push @{$instantiations{$module}}, $_->module_identifier->emit_self;
            }
        }
    }

    #print Dumper (\%instantiations);

    # Remove modules that are not defined in this file, we don't care about them
    for my $modlist (values %instantiations) {
        @$modlist = grep { exists $instantiations{$_} } @$modlist;
    }

    while (%instantiations) {
        #print Dumper (\%instantiations);

        my @leaves = grep { 0 == scalar @{$instantiations{$_}} } keys %instantiations;

        if (@leaves == 0) {
            VP3::error ("Circular dependency detected");
            last;
        }

        for my $modname (@leaves) {
            my $modref = $vdb->module_ref ($modname);
            my $have_module = !($$modref->typeis ("vp3_module_declaration") && $$modref->vp3_module_directive->opt_none);
            my $xlate;

            # Expand @Instance
            $xlate = VP3::RTLTool::Expander->new ($self->{vp3});
            $$modref = $xlate->visit ($$modref);

            $VP3::debug && print STDERR "Analyzing ", $modname, "\n";
            $conn_db = VP3::RTLTool::ConnectivityAnalyzer::analyze ($self, $$modref);
            $self->{connectivity}{$modname} = $conn_db;

            #print STDERR "*** BEGIN analyze connectivity DB dump ***\n";
            #print STDERR Dumper ($conn_db);
            #print STDERR "*** END analyze connectivity DB dump ***\n";

            # Expand directives other than @Instance
            $xlate = VP3::RTLTool::Translator->new ($self);
            $$modref = $xlate->visit ($$modref);

            #print STDERR "*** BEGIN translated parse tree ***\n";
            #print STDERR Dumper ($$modref);
            #print STDERR "*** END translated parse tree ***\n";

            if ($have_module) {
                $VP3::debug && print STDERR "Validating connectivity in ", $modname, "\n";
                $self->{connectivity}{$modname}->validate;

                #print Dumper ($modref);

                # Save module information in the cache (in case there are multiple modules in the file)
                $VP3::debug && print STDERR "Adding ", $modname, " to cache\n";
                $self->{vp3}->add_module_to_cache ($$modref, 0, $self->{input});
            } else {
                $VP3::debug && print STDERR "Not validating connectivity in module generated with -none\n";
            }

            # The current module is now considered a leaf, i.e. now that it is
            # processed we can work on any modules that instantiate it.
            delete $instantiations{$modname};
        }

        for my $modlist (values %instantiations) {
            @$modlist = grep { exists $instantiations{$_} } @$modlist;
        }
    }

    if ($self->{warnings_as_errors} && $VP3::warning_count) {
        VP3::error ("warnings being treated as errors");
    }

    if ($VP3::error_count) {
        return undef;
    }

    1;
}

# Write the output verilog to a temp file, and return the temp file object.

sub generate_verilog
{
    my $self = $_[0];
    my $output;

    my $emit = sub {
        no warnings 'recursion';

        my ($self, $target) = @_;

        if (!@{$target->children}) {
            $output .= $target->emit (&VP3::ParseTree::VISIBLE_ONLY);
        } else {
            goto $self->can ("visit_children");
        }
    };

    my $v = VP3::ParseTreeVisitor->new ($emit);
    $v->visit ($self->{vdb});

    my $fh = File::Temp->new or VP3::error_fatal ("can't create temporary file");

    $fh->print ($output);
    $fh->flush;

    $fh;
}

sub output_verilog
{

    my $self = $_[0];
    my $tmp = $_[1];
    my $fh;

    if ($self->{output} ne "-") {
        $fh = IO::File->new ($self->{output}, "w")
            or VP3::error_fatal ("can't open `" . $self->{output} . "' for writing: $!");
    } else {
        $fh = *STDOUT{IO};
    }

    file_copy ($tmp, $fh);

}

sub output_depends
{

    my $self = $_[0];

    my $fh;

    if ($self->{output} ne "-") {
        $fh = IO::File->new ($self->{output}, "w")
            or VP3::error_fatal ("can't open `$self->{output}' for writing: $!");
    } else {
        $fh = *STDOUT{IO};
    }

    my %printed;

    for (@{$self->{vp3}->depends}) {
        my $tag = $_->[0] . ":" . $_->[1];
        next if $printed{$tag}++;
        print $fh "$_->[0] $_->[1]\n";
    }

}

sub process
{

    my ($self) = @_;

    # First pass - preprocessor

    my $pp_class = "VP3::RTLTool::Preprocessor::" . $self->{preprocessor};
    $pp_class->can ("new") or VP3::error_fatal ("unknown preprocessor " . $self->{preprocessor});

    my $pp = $pp_class->new ($self->{vp3}) or die "Failed to create preprocessor object";

    $pp->depends_mode ($self->{depends_mode});
    $pp->includes (@{$self->{pp_includes}});

    for (@{$self->{pp_defines}}) {
        my ($name, $value) = split ('=', $_);
        # $value is undefined if there was no =, that's what we want
        $pp->define ($name, $value);
    }

    my $pp_result = $pp->process ({
        input => $self->{input},
        output => $self->{pass1out}->filename,
    });

    if ($self->{depends_mode}) {
        $self->{vp3}->depend (@$_) for $pp->depends;
    }

    if (!$pp_result) {
        if ($self->{depends_mode}) {
            $self->output_depends;
        }
        return undef;
    }

    # Verilog parse

    my $parse_result = $self->parse_pass1out;

    if (!$parse_result) {
        if ($self->{depends_mode}) {
            $self->output_depends;
        }
        return undef;
    }

    # Second pass - verilog analysis and generation

    my $analyze_result = $self->analyze;

    if ($self->{depends_mode}) {
        $self->output_depends;
    } else {
        my $tmp = $self->generate_verilog;

        if ($analyze_result) {
            $self->output_verilog ($tmp->filename);
        } else {
            $self->write_debug_file ("Expanded Verilog", $tmp->filename);
        }
    }

    return $analyze_result

}

1;

# vim: sts=4 sw=4 et
