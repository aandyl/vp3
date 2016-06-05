{
    package VP3::Symtab;

    use Carp;

    sub new
    {
        my ($class) = $_[0];
        return bless { }, $class;
    }

    sub insert
    {
        my ($self, $sym, $val) = @_;

        exists $self->{table}{sym} and croak "Attempt to redefine $sym";

        #$val && ref ($val) eq "VP3::Symbol" or croak "Argument to VP3::Symtab::insert must be a VP3::Symbol";
        if ($val && ref ($val) ne "VP3::Symbol") {
            # !!! fix users of this form
            $self->{table}{$sym} = VP3::Symbol->new ($val);
        } else {
            $self->{table}{$sym} = $val;
        }

        $self->{table}{$sym};
    }

    sub lookup
    {
        my ($self, $sym) = @_;

        $self->{table}{$sym};
    }

} # package VP3::Symtab;

{
    package VP3::Symbol;

    # This should be improved. Currently the "data" member is only used for
    # parameters, to store the definition in case the parameter needs to be
    # evaluated.

    sub new
    {
        my ($class, $type, $data) = @_;
        return bless { type => $type, data => $data }, $class;
    }

    sub type : lvalue { $_[0]->{type} }
    sub data : lvalue { $_[0]->{data} }

} # package VP3::Symbol

{

    package VP3::Signal;

    sub new
    {
        my ($class, $identifier) = @_;
        my $self = {
            identifier      => $identifier,
            connectivity    => [ ],
            force_type      => "",
        };
        return bless $self, $class;
    }

    sub add_connectivity
    {
        my ($self, $conn) = @_;

        defined ($conn->msb) and $self->update_msb ($conn->msb);
        defined ($conn->lsb) and $self->update_lsb ($conn->lsb);

        push @{$self->{connectivity}}, $conn;
    }

    sub connectivity
    {
        return @{$_[0]->{connectivity}};
    }

    sub identifier
    {
        $_[0]->{identifier};
    }

    # !!! very primitive
    sub set_width
    {
        $_[0]->{msb} = $_[1] - 1;
        $_[0]->{lsb} = 0;
    }

    sub width
    {
        $_[0]->{msb} - $_[0]->{lsb} + 1;
    }

    # Not right for big-endian vectors !!!
    sub update_lsb
    {
        my ($self, $new_lsb) = @_;

        #print STDERR "update_lsb $self->{identifier} $new_lsb\n";
        if (!defined ($self->{lsb}) || $new_lsb < $self->{lsb}) {
            $self->{lsb} = $new_lsb;
        }
    }

    sub update_msb
    {
        my ($self, $new_msb) = @_;

        #print STDERR "update_msb $self->{identifier} $new_msb\n";
        if (!defined ($self->{msb}) || $new_msb > $self->{msb}) {
            $self->{msb} = $new_msb;
        }
    }

    sub set_force_type
    {
        $_[0]->{force_type} = $_[1];
    }

    sub force_type
    {
        $_[0]->{force_type};
    }

    sub declaration
    {
        if ($_[1]) {
            if ($_[0]->{declaration}) {
                die "Attempt to redefine " . $_[0]->identifier;
            }

            $_[0]->{declaration} = $_[1];
        }

        $_[0]->{declaration};
    }

    sub sources { grep { $_->{direction} eq "source" } @{$_[0]->{connectivity}}; }
    sub sinks   { grep { $_->{direction} eq "sink"   } @{$_[0]->{connectivity}}; }

    sub input_connection  { grep { $_->{type} && $_->{type} eq "input"  } @{$_[0]->{connectivity}}; }
    sub output_connection { grep { $_->{type} && $_->{type} eq "output" } @{$_[0]->{connectivity}}; }

    # Returns the type that this signal should be declared as, based on usage.
    # "input", "output", "reg", "wire"
    sub implicit_declaration_type
    {
        my ($self) = @_;
        my ($input, $output, $reg, $wire);

        if ($self->{force_type} eq "input") {
            $input = 1;
        } elsif ($self->{force_type} eq "output") {
            $output = 1;
        } elsif ($self->{force_type}) {
            die "Unknown forced declaration type: $self->{force_type}";
        } elsif (0 == $self->sources) {
            $input = 1;
        } elsif (0 == $self->sinks) {
            $output = 1;
        }

        if (grep { $_->{direction} eq "source" && $_->{type} eq "variable" } @{$self->{connectivity}}) {
            $reg = 1;
        }

        # !!! For now declare all wires, even signals also declared as input/output. Review.
        #if (!$input && !$output && !$reg) {
        if (!$reg) {
            $wire = 1;
        }

        (input => $input, output => $output, reg => $reg, wire => $wire);
    }

    # Returns the width that this signal should be declared with, if known
    sub implicit_declaration_range
    {
        my ($self) = @_;

        if (defined ($self->{msb})) {
            return "[$self->{msb}:$self->{lsb}]";
        } else {
            return "";
        }
    }

} # package VP3::Signal


{
    package VP3::Port;

    use constant {
        DIR_INPUT  => 1,
        DIR_OUTPUT => 2,
        DIR_INOUT  => 3,
    };

    sub new
    {
        my ($class) = shift;
        my $self = { @_ };
        bless $self, $class;
    }

} # package VP3::Port

{

    # This class exists to preserve ordering of port collections. Tie::IxHash
    # or similar could also be used but isn't part of the core perl
    # distribution. Calls to `keys' and `values' on VP3::Ports objects have
    # been cleaned, but the code does perform direct lookups into the hash.
    # Any class variables should be prefixed with ! to avoid possible
    # collisions with verilog identifiers. Removal from the port collection is
    # not supported.

    package VP3::Ports;

    sub new
    {
        my ($class) = @_;
        my $self = { '!list' => [ ] };
        bless $self, $class;
    }

    sub location
    {
        defined ($_[1]) and $_[0]->{'!location'} = $_[1];
        $_[0]->{'!location'};
    }

    sub add
    {
        my ($self, $port) = @_;
        push @{$self->{'!list'}}, $port;
        $self->{$port->{name}} = $port;
    }

    sub all_ports { $_[0]->{'!list'}; }

} # package VP3::Ports

######################################################################

# Lexical analysis and parsing

{
    package VP3::Conditionals;

    # For "else if" sections, we need to keep track of whether we are skipping
    # because we already included a section for this conditional, or because
    # all of the conditionals so far have been false. (This determines whether
    # we will include an "else" section.) For the actual "else", we don't need
    # to track this information, so just INCL/EXCL is sufficient.
    # IFDEF_COND_SKIP is for nested ifdefs within excluded sections.
    use constant {
        IFDEF_COND_INCL  => 0,
        IFDEF_COND_EXCL  => 1,
        IFDEF_COND_SKIP  => 2,
        IFDEF_ELSIF_INCL => 3,
        IFDEF_ELSIF_EXCL => 4,
        IFDEF_ELSIF_SKIP => 5,
        IFDEF_ELSE_INCL  => 6,
        IFDEF_ELSE_EXCL  => 7,
    };

    sub new
    {
        my $class = shift;
        my $self = {
            stack => [ ],
        };
        return bless $self, $class;
    }

    sub ifdef
    {
        my ($self, $cond) = @_;

        if (0 == @{$self->{stack}}) {
            push @{$self->{stack}}, $cond ? IFDEF_COND_INCL : IFDEF_COND_EXCL;
        } else {
            my ($last, $next);
            $last = $self->{stack}->[-1];

            if ($last == IFDEF_COND_EXCL ||
                $last == IFDEF_COND_SKIP ||
                $last == IFDEF_ELSIF_EXCL ||
                $last == IFDEF_ELSIF_SKIP ||
                $last == IFDEF_ELSE_EXCL) {

                $next = IFDEF_COND_SKIP;
            } else {
                $next = $cond ? IFDEF_COND_INCL : IFDEF_COND_EXCL;
            }

            push @{$self->{stack}}, $next;
        }

        &VP3::debug && print STDERR "ifdef/ifndef: stack=" . join (",", @{$self->{stack}}) . "\n";

        $self->is_enabled;
    }

    sub elsif
    {
        my ($self, $cond) = @_;

        if (0 == @{$self->{stack}}) {
            VP3::error ("elsif not within ifdef or ifndef");
            return $self->is_enabled;
        }

        my ($last, $next);
        $last = $self->{stack}->[-1];

        $last == IFDEF_COND_EXCL  ||
        $last == IFDEF_ELSIF_EXCL    and $next = $cond ? IFDEF_ELSIF_INCL : IFDEF_ELSIF_EXCL;

        $last == IFDEF_COND_INCL  ||
        $last == IFDEF_COND_SKIP  ||
        $last == IFDEF_ELSIF_INCL ||
        $last == IFDEF_ELSIF_SKIP    and $next = IFDEF_ELSIF_SKIP;

        $last == IFDEF_ELSE_INCL  ||
        $last == IFDEF_ELSE_EXCL     and do { VP3::error ("else followed by elsif"); return $self->is_enabled };

        $self->{stack}->[-1] = $next;

        &VP3::debug && print STDERR "`elsif: stack=" . join (",", @{$self->{stack}}) . "\n";

        $self->is_enabled;
    }

    sub else
    {
        my $self = shift;

        if (0 == @{$self->{stack}}) {
            VP3::error ("else not within ifdef or ifndef");
            return $self->is_enabled;
        }

        my ($last, $next);
        $last = $self->{stack}->[-1];

        $last == IFDEF_COND_EXCL  ||
        $last == IFDEF_ELSIF_EXCL    and $next = IFDEF_ELSE_INCL;

        $last == IFDEF_COND_INCL  ||
        $last == IFDEF_COND_SKIP  ||
        $last == IFDEF_ELSIF_INCL ||
        $last == IFDEF_ELSIF_SKIP    and $next = IFDEF_ELSE_EXCL;

        $last == IFDEF_ELSE_INCL  ||
        $last == IFDEF_ELSE_EXCL     and do { VP3::error ("Multiple else directives for one ifdef"); return $self->is_enabled };

        $self->{stack}->[-1] = $next;

        &VP3::debug && print STDERR "`else: stack=" . join (",", @{$self->{stack}}) . "\n";

        $self->is_enabled;
    }

    sub endif
    {
        my $self = shift;

        if (0 == @{$self->{stack}}) {
            VP3::error ("endif without matching ifdef / ifndef");
            return $self->is_enabled;
        }

        pop @{$self->{stack}};

        &VP3::debug && print STDERR "endif: stack=" . join (",", @{$self->{stack}}) . "\n";

        $self->is_enabled;
    }

    # Returns 1 if processing is currently active, 0 if not
    sub is_enabled
    {
        my $self = shift;

        if (0 == @{$self->{stack}}) {
            return 1;
        } else {
            my $state = $self->{stack}->[-1];

            if ($state == IFDEF_COND_EXCL ||
                $state == IFDEF_COND_SKIP ||
                $state == IFDEF_ELSIF_EXCL ||
                $state == IFDEF_ELSIF_SKIP ||
                $state == IFDEF_ELSE_EXCL) {
                return 0;
            } else {
                return 1;
            }
        }
    }

    # Return the current depth of ifdefs (0 = not within any ifdefs)
    sub depth { @{$_[0]->{stack}} }

} # package VP3::Conditionals

{

    package VP3::Utils;

    use Data::Dumper;

    # This was originally used for commenting directives in the output, but has
    # been replaced by the more sophisticated directive_comment routing. It is
    # currently used by the lexer for quoting @Unparsed directives, but not
    # clear that directive_comment doesn't apply there too.
    sub block_comment
    {
        my $text = $_[0];

        #$text =~ s{^}{// }mg;
        # Comment any non-blank lines
        $text =~ s{^(?=.*\S)}{//|}mg;

        # Add trailing newline if last line is not whitespace
        $text .= "\n" if $text =~ /\S.*(?!\n)$/m;

        $text;
    }

    # Returns commented version of directive for output.
    # First argument is a VP3::ParseTree object
    # Second argument, if given, will be filled with the indent found on the
    # source directive.
    sub directive_comment
    {
        my $debug = 0;
        my ($directive, $indent_ref) = @_;

        my ($front, $self, $back) = ("", "", "");

        $debug and print Dumper ($directive);

        my @front = @{$directive->front};
        my @back  = @{$directive->back};

        my $node;

        while ($node = shift @front) {
            if ($node->type eq "whitespace") {
                $front .= $node->emit (&VP3::ParseTree::VISIBLE_ONLY);
            } else {
                $self .= $node->emit;
                last;
            }
        }

        for $node (@front) {
            $self .= $node->emit;
        }

        $self .= $directive->emit_self;

        while ($node = pop @back) {
            if ($node->type eq "whitespace") {
                $back = $node->emit (&VP3::ParseTree::VISIBLE_ONLY) . $back;
            } else {
                push @back, $node;
                last;
            }
        }

        for $node (@back) {
            $self .= $node->emit;
        }

        $debug and print "F: >$front<\nS: >$self<\nB: >$back<\n";

        # Make $self consist of complete lines (!!! test)
        if ($front =~ s/^(.*)\z//m) {
            $self = $1 . $self;
        }

        if ("\n" ne substr ($self, -1)) {
            if ($back =~ s/\A(.*\n)//) {
                $self = $self . $1;
            } else {
                $self .= $back . "\n";
                $back = "";
            }
        }

        $debug and print "F: >$front<\nS: >$self<\nB: >$back<\n";

        my ($spaces, $tabs, $indent);

        # Determine the minimum whitespace on any lines (consider either spaces or tabs)
        while ($self =~ /^( *)/gm) {
            my $l = length $1;
            $spaces = $l if (!defined ($spaces) || $l < $spaces);
        }

        while ($self =~ /^(\t*)/gm) {
            my $l = length $1;
            $tabs = $l if (!defined ($tabs) || $l < $tabs);
        }

        if (defined ($spaces) && $spaces > 0) {
            $indent = " " x $spaces;
        } elsif (defined ($tabs) && $tabs > 0) {
            $indent = "\t" x $tabs;
        } else {
            $indent = "";
        }

        $self =~ s{(?<=^$indent)}{//|}mg;

        # Return indentation to caller if desired
        $$indent_ref = $indent if $indent_ref;

        $front . $self . $back;
    }

    # Word splitting for directive arguments.
    #  * words are separated by white space
    #  * white space within double quotes is ignored
    #  * a double quote within double quotes may be specified by backslash-escaping it
    #  * single quotes do not have special treatment
    sub directive_words
    {
        my $text = $_[0];

        $text =~ s/^\s*//;
        $text =~ s/\s*$//;

        my $word = "";
        my @rtn;

        while ($text =~ m/\G
                          (?:
                               ([^"\s]+)            # anything other than quote or whitespace
                              |(?:                  # a quoted section, which:
                                  "                 #   starts with a quote,
                                  ((?:\\"|[^"])*)   #   contains backslash-escaped quotes or non-quote chars, and
                                  "                 #   ends with a quote
                               )
                              |(\s*)
                          )
                         /gsx) {

            if (defined ($1))    { $word .= $1 }
            elsif (defined ($2)) { $word .= $2 }
            else {
                # Process backslash-escaped quotes
                $word =~ s/\\"/"/g;
                push @rtn, $word;
                $word = "";
            }

        }

        @rtn;
    }

} # package VP3::Utils

package VP3;

use VP3::Parser;
use Data::Dumper;
use IO::File;
use Getopt::Long;
use Carp qw(carp cluck croak confess);
use File::Temp qw();
use File::Copy qw();
use File::Spec;
use Class::Struct;

BEGIN {
    struct (
        'VP3::ModuleCacheEntry' => [
            # Parse tree for the module
            module => '$',

            # True if the module was found incidentally, e.g. while looking
            # for a different module. Opportunistically cached modules have
            # not had their dependencies recorded and might not be found if
            # they were independently sought using only library specifications
            # # (-v and -y) from the command line.
            is_opp => '$',

            # Source file from which we parsed the module. Unset if the module
            # is from the current file.
            source_file => '$',

            # List of dependencies. Unset if the module is from the current
            # file.
            depends => '@',
        ]
    );
}

our ($debug);

# Error infrastructure

our ($warning_count) = 0;
our ($error_count)   = 0;

sub warning {
    $warning_count++;

    my $msg = "WARNING: " . join ("\n         ", @_) . "\n";

    if ($debug) {
        my ($package, $filename, $line) = caller;
        $msg .= "         raised at $filename line $line\n";
    }

    warn $msg;
}

sub error {
    $error_count++;

    my $msg = "ERROR: " . join ("\n       ", @_) . "\n";

    if ($debug) {
        cluck $msg;
    } else {
        warn $msg;
    }
}

sub error_fatal {
    my $msg = "ERROR (fatal): " . join ("\n               ", @_) . "\n";

    if ($debug) {
        confess $msg;
    } else {
        die $msg;
    }
}

# Calling this "error_internal" would be more appropriate
sub fatal {
    my $msg = "INTERNAL ERROR: " . join ("\n                ", @_) . "\n";
    confess $msg;
}

##

sub depend
{
    push @{$_[0]->{depends}}, [ @_[1..$#_] ];
}

sub depends { $_[0]->{depends} }

##

sub new
{
    my $class = shift;
    my %args = @_;
    my $self = {
        depends         => [ ],
        module_cache    => { },
        v_defines       => [ ],
        v_includes      => [ "." ],
        library_files   => [ ],
        library_dirs    => [ ],
    };

    for (qw(v_defines v_includes library_files library_dirs)) {
        if (exists ($args{$_})) {
            push @{$self->{$_}}, @{$args{$_}};
        }
    }
    
    bless $self, $class;
}

sub debug { $debug }

sub parse
{
    my ($self, $fh, $name, $basename, $depend_cb, $error_ref) = @_;

    my $p = VP3::Parser->new;
    $p->YYData->{lexer} = VP3::Lexer->new;
    $p->YYData->{lexer}->depend_cb ($depend_cb);
    $p->YYData->{lexer}->input ($fh, $name);

    for (@{$self->{v_defines}}) {
        my ($name, $value) = split ('=', $_);
        defined ($value) or $value = "";

        $p->YYData->{lexer}->define ($name, $value);
    }

    for (@{$self->{v_includes}}) {
        $p->YYData->{lexer}->include_path ($_);
    }

    $p->YYData->{basename} = $basename;

    $p->YYParse (
                 yylex   => sub { $_[0]->YYData->{lexer}->lex (@_[1..$#_]) },
                 yyerror => \&VP3::Parser::default_yyerror,
                 #yydebug => 0xF,
                )
        or ($$error_ref = $p->YYData->{error}, undef);
}

# Helpers for ports(). Not geared for general use.

use Cwd qw();

sub find_module_in_cache
{
    my ($self, $module, $file) = @_;

    return undef unless (my $cache_entry = $self->{module_cache}->{$module});

    my $cache_source_file = Cwd::abs_path ($cache_entry->source_file);
    my $current_source_file = Cwd::abs_path ($file);

    return undef if ($cache_source_file ne $current_source_file);

    $debug && print STDERR "using cached description of $module (after search)\n";

    return $cache_entry;
}

sub add_module_to_cache
{
    my ($self, $module, $is_opp, $file, $depends) = @_;

    my $name = $module->module_identifier;
    my $cache = $self->{module_cache};

    if (!$cache->{$name}) {
        $debug && print STDERR "Adding $name to module cache\n";

        $cache->{$name} = VP3::ModuleCacheEntry->new (
            module      => $module,
            is_opp      => $is_opp,
            source_file => $file,
            depends     => $depends,
        );

        return 1;
    } else {
        my $cache_source_file = Cwd::abs_path ($cache->{$name}->source_file);
        my $current_source_file = Cwd::abs_path ($file);

        if ($cache_source_file ne $current_source_file) {
            VP3::warning ("module `$name' has been read from both " .
                          "`$cache_source_file' and `$current_source_file'");
        } elsif ($debug) {
            print STDERR "module `$name' should have been retrieved from cache. possible bug.\n";
        }

        return undef;
    }
}

# This function is often called twice for instantiated modules, once when
# expanding the @Instance directive, and again when doing connectivity
# analysis. For @Instance, the file to read may be specified manually with
# -file, but that information doesn't propagate to the connectivity analyzer.

sub ports
{

    my ($self, $module, @search_files) = @_;

    my $cache = $self->{module_cache};

    if ($cache->{$module} && !$cache->{$module}->is_opp) {
        $debug && print STDERR "using cached description of module $module (search bypassed)\n";
        return $cache->{$module}->module->ports;
    }

    if (@search_files) {
        @search_files = map [ "vlib", $_ ], @search_files;
    } else {
        @search_files = map [ "vmod", File::Spec->catfile ($_, "${module}.v") ], @{$self->{library_dirs}};
        push @search_files, map [ "vlib", $_ ], @{$self->{library_files}};
    }

    # !!! should give a better error message
    unless (@search_files) {
        VP3::warning ("No files known in which to look for `$module'");
        return undef;
    }

    for (@search_files) {
        my ($dep_type, $file) = @$_;
        my $fh;

        next unless -f $file;

        unless ($fh = IO::File->new ($file)) {
            VP3::warning ("while searching for $module, couldn't open $file: $!");
            next;
        }

        # If we happened to parse this module previously, record the
        # dependencies, and then return the cached copy.
        if (my $cached_module = $self->find_module_in_cache ($module, $file)) {
            if ($cached_module->is_opp) {
                $self->depend ($dep_type, $dep_type eq "vlib" ? $file : $module);
                $self->depend (@$_) for @{$cached_module->depends};
            }
            return $cached_module->module->ports;
        }

        $debug && print STDERR "Looking for ports of $module in $file\n";

        # Collect dependencies in this list, but don't record them until we
        # know we're going to use the module.
        my @depends;
        my $depend_cb = sub {
            push @depends, [ @_ ];
        };

        my $error;
        my $vroot = $self->parse ($fh, $file, undef, $depend_cb, \$error);

        if (!$vroot) {
            VP3::warning ("While searching for $module, couldn't parse $file:\n$error");
            next;
        }

        my $result;

        for ($vroot->modules) {
            my $opp;

            if ($_->module_identifier eq $module) {
                $opp = 0;
                $result = $_;
            } else {
                $opp = 1;
            }

            $self->add_module_to_cache ($_, $opp, $file, \@depends);
        }

        if (!$result) {
            $debug && print STDERR "Module $module not found in $file\n";
            next;
        }

        # Record dependencies, since we're actually going to use the module.
        $self->depend ($dep_type, $dep_type eq "vlib" ? $file : $module);
        $self->depend (@$_) for @depends;

        #if ($debug) {
        #    print STDERR "*** BEGIN $file parse tree ***\n";
        #    print STDERR Dumper ($vroot);
        #    print STDERR "*** END $file parse tree ***\n";
        #}

        # If we got here, we found the module defn, so we're done
        return $result->ports;
    }

    VP3::error ("Couldn't find definition for $module");

    # If there are any library directories where we could read the module from
    # if it existed, produce a dependency record.
    if (grep { $_->[0] eq "vmod" } @search_files) {
        $self->depend ("vmod", $module);
    }

    return undef;

}

1;

# vim: sts=4 sw=4 et
