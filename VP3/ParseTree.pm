use VP3::Expression;

{

    package VP3::ParseTree;

    use Scalar::Util qw(blessed);
    use Data::Dumper;
    use File::Spec;
    use Carp;

    use constant {
        VISIBLE_ONLY => 1,
    };

    # Usage 1: x->new (node type, [ child nodes ])
    # Usage 2: x->new (node type, "node contents")
    sub new
    {
        my ($class, $type) = (shift, shift);
        my $text_self = "";

        if ($#_ == 0 && !ref ($_[0])) {
            # Node with text contents
            croak "Missing node contents" unless defined $_[0];
            $text_self = $_[0];
            @_ = ();
        } elsif (@_ == grep { blessed ($_) && $_->isa ("VP3::ParseTree") } @_) {
            # Node with children, or empty
        } else {
            croak "Invalid arguments to " . __PACKAGE__ . "::new:\n" . Dumper (@_);
        }

        my $self = {
            front       => [ ],
            text_self   => $text_self,
            back        => [ ],
            children    => [ @_ ],
            visible     => 1,
        };

        return bless $self, $class;

    }

    sub factory
    {
        shift if $_[0] eq "VP3::ParseTree";
        my $type = shift;

        !ref ($type) && $type
            or croak "Must pass node type as first argument to VP3::ParseTree::factory\n";

        if ("VP3::ParseTree::$type"->can ("new")) {
            return "VP3::ParseTree::$type"->new ($type, @_);
        } else {
            return VP3::ParseTree::generic->new ($type, @_);
        }
    }

    sub type
    {
        my $txt = ref ($_[0]);
        $txt =~ s/^VP3::ParseTree:://;
        $txt;
    }

    sub typeis
    {
        return $_[0]->isa ("VP3::ParseTree::$_[1]");
    }

    sub line
    {
        defined ($_[1]) and $_[0]->{source_line} = $_[1];
        $_[0]->{source_line};
    }

    {
        no warnings 'once';
        *source_line = \&line;
    }

    sub source_file
    {
        defined ($_[1]) and $_[0]->{source_file} = $_[1];
        $_[0]->{source_file};
    }

    sub location
    {
        if (@{$_[0]->{children}}) {
            $_[0]->{children}->[0]->location;
        } else {
            my ($file, $line);

            $file = $_[0]->{source_file};
            $line = $_[0]->{source_line};

            if (defined $file) {
                $file = File::Spec->canonpath ($file);
            } else {
                $file = "<unknown file>";
            }

            $line = "<unknown line>" unless defined $line;

            return "$file:$line";
        }
    }

    # Set the location of this node and all children. Applied to
    # internally-generated verilog parsed out of strings.
    sub location_set_recursive
    {
        if (@{$_[0]->{children}}) {
            $_->location_set_recursive ($_[1], $_[2]) for @{$_[0]->{children}};
        } else {
            $_[0]->source_file ($_[1]);
            $_[0]->source_line ($_[2]);
        }
    }

    sub visible
    {
        defined ($_[1]) and $_[0]->{visible} = $_[1];
        $_[0]->{visible};
    }

    sub text_self { $_[0]->{text_self} = $_[1]; }

    sub prepend_text
    {
        if (ref $_[1]) {
            #carp ("prepend_text called with ref argument");
            $_[0]->prepend ($_[1]);
        } else {
            my $txt = $_[1];

            if (@{$_[0]->{children}}) {
                $_[0]->{children}->[0]->prepend_text ($txt);
            } else {
                croak "Missing node contents" unless defined $txt;
                unshift @{$_[0]->{front}}, VP3::ParseTree->factory ("whitespace", $txt);
            }
        }

        $_[0];
    }

    sub prepend
    {
        return $_[0] if $_[1]->type eq "null";

        if (@{$_[0]->{children}}) {
            $_[0]->{children}->[0]->prepend ($_[1]);
        } else {
            my $front = $_[1]->{front};
            my $back  = $_[1]->{back};
            $_[1]->{front} = [ ];
            $_[1]->{back}  = [ ];

            $_[0]->prepend ($_) for @{$back};
            unshift @{$_[0]->{front}}, $_[1];
            $_[0]->prepend ($_) for @{$front};
        }

        $_[0];
    }

    sub append_text
    {
        if (ref $_[1]) {
            #carp ("append_text called with ref argument");
            $_[0]->append ($_[1]);
        } else {
            my $txt = $_[1];

            if (@{$_[0]->{children}}) {
                $_[0]->{children}->[-1]->append_text ($txt);
            } else {
                croak "Missing node contents" unless defined $txt;
                push @{$_[0]->{back}}, VP3::ParseTree->factory ("whitespace", $txt);
            }
        }

        $_[0];
    }

    sub append
    {
        return $_[0] if $_[1]->type eq "null";

        if (@{$_[0]->{children}}) {
            $_[0]->{children}->[-1]->append ($_[1]);
        } else {
            my $front = $_[1]->{front};
            my $back  = $_[1]->{back};
            $_[1]->{front} = [ ];
            $_[1]->{back}  = [ ];

            $_[0]->append ($_) for @{$front};
            push @{$_[0]->{back}}, $_[1];
            $_[0]->append ($_) for @{$back};
        }

        $_[0];
    }

    sub prepend_children
    {
        unshift @{$_[0]->{children}}, @_[1..$#_];
        $_[0];
    }

    sub append_children
    {
        push @{$_[0]->{children}}, @_[1..$#_];
        $_[0];
    }

    sub front    { @{$_[0]->{children}} ? $_[0]->children->[0]->front : $_[0]->{front} }
    sub children { $_[0]->{children} }
    sub back     { @{$_[0]->{children}} ? $_[0]->children->[-1]->back : $_[0]->{back}  }

    sub emit_front
    {
        my ($self, $vis_only) = @_;

        confess "Bad node" if @{$self->{front}} && @{$self->{children}};

        if (@{$self->{children}}) {
            $self->{children}->[0]->emit_front ($vis_only);
        } else {
            my $txt = "";
            for (@{$self->{front}}) {
                $txt .= $_->emit ($vis_only);
            }
            $txt;
        }
    }

    sub emit_self
    {
        my ($self, $vis_only) = @_;

        confess "Illegal emit_self call" if defined ($vis_only);

        confess "Bad node" if (@{$self->{front}} || $self->{text_self} || @{$self->{back}}) && @{$self->{children}};

        my $txt = "";

        my $children = scalar (@{$self->{children}});

        if ($children == 0) {
            $txt .= $self->{text_self};
        } elsif ($children == 1) {
            $txt .= $self->{children}->[0]->emit_self;
        } else {
            $txt .= $self->{children}->[0]->emit_self;
            $txt .= $self->{children}->[0]->emit_back;
            for (@{$self->{children}}[1..$children-2]) {
                $txt .= $_->emit;
            }
            $txt .= $self->{children}->[-1]->emit_front;
            $txt .= $self->{children}->[-1]->emit_self;
        }

        $txt;
    }

    sub emit_back
    {
        my ($self, $vis_only) = @_;

        confess "Bad node" if @{$self->{back}} && @{$self->{children}};

        if (@{$self->{children}}) {
            $self->{children}->[-1]->emit_back ($vis_only);
        } else {
            my $txt = "";
            for (@{$self->{back}}) {
                $txt .= $_->emit ($vis_only);
            }
            $txt;
        }
    }

    sub emit
    {
        my ($self, $vis_only) = @_;

        # !!! Find a better way than inspecting text_self to test for node with
        # content?
        confess "Bad node" if $self->{text_self} && @{$self->{children}};

        my $txt = "";

        #$txt .= $self->emit_front ($vis_only);
        #$txt .= $self->emit_self ($vis_only);
        #$txt .= $self->emit_back ($vis_only);

        my $children = scalar (@{$self->{children}});

        # There is a redundant check of ($children == 0) in emit_front/back.
        # This could be resolved by creating separate VP3::ParseTree::Node and
        # VP3::ParseTree::Leaf classes.
        if ($children == 0) {
            $txt .= $self->emit_front ($vis_only);
            if (!$vis_only || $self->visible) {
                $txt .= $self->emit_self;
            }
            $txt .= $self->emit_back ($vis_only);
        } else {
            for (@{$self->{children}}) {
                $txt .= $_->emit ($vis_only);
            }
        }

        $txt;
    }

} # package VP3::ParseTree

{
    package VP3::ParseTree::identifier;
    use base 'VP3::ParseTree';

    sub is_system_identifier
    {
        substr ($_[0]->{text_self}, 0, 1) eq '$' ? 1 : 0;
    }
}

{
    package VP3::ParseTree::string;
    use base 'VP3::ParseTree';

    sub emit_self
    {
        q(") . $_[0]->SUPER::emit_self . q(");
    }

}

{
    package VP3::ParseTree::based_number;
    use base 'VP3::ParseTree';

    use Carp;

    sub new
    {
        my ($class, $type, $signed, $base, $ws, $value) = @_;

        my $self = $class->SUPER::new ($type);
        $self->{width}  = undef;
        $self->{signed} = $signed || "";
        $self->{base}   = $base   || "";
        $self->{ws}     = $ws     || "";

        length ($value) or croak (__PACKAGE__ . "::new requires non-null value");

        $self->{value}  = $value;

        $self;
    }

    sub width
    {
        if ($_[1]) {
            $_[0]->{width} = $_[1];
        }

        $_[0]->{width};
    }

    sub base
    {
        if ($_[1]) {
            $_[0]->{base} = $_[1];
        }

        $_[0]->{base};
    }

    sub value
    {
        if ($_[1]) {
            $_[0]->{value} = $_[1];
        }

        $_[0]->{value};
    }

    sub emit_self
    {
        my $self = $_[0];
        "'" . $self->{signed} . $self->{base} . $self->{ws} . $self->{value};
    }

}

{

    package VP3::ParseTree::generic;
    use base 'VP3::ParseTree';

    sub new
    {
        my ($class, $type) = (shift, shift);

        my $self = $class->SUPER::new ($type, @_);
        $self->{type} = $type;
        $self;
    }

    sub type
    {
        $_[0]->{type};
    }

    sub isa
    {
        my ($self, $class) = @_;

        if ($class =~ /^VP3::ParseTree::(.*)$/ && $1 eq $self->{type}) {
            return 1;
        } else {
            return $self->SUPER::isa ($class);
        }
    }

} # package VP3::ParseTree::generic

{
    package VP3::ParseTree::source_text;
    use base 'VP3::ParseTree';

    sub modules
    {
        grep { $_->typeis ("module_declaration") } @{$_[0]->children};
    }

    sub module { ${$_[0]->module_ref (@_[1..$#_]) || \undef} }

    sub module_ref
    {
        my ($self, $which) = @_;

        my @modules = grep { $$_->typeis ("module_declaration") && $$_->module_identifier eq $which } map { \$_ } @{$self->children};

        if (@modules > 1) {
            return undef;
        } else {
            return $modules[0];
        }
    }

} # package VP3::ParseTree::source_text

{
    package VP3::ParseTree::module_declaration;
    use base 'VP3::ParseTree';

    use Data::Dumper;
    use Scalar::Util qw(blessed);
    use Carp;

    use constant {
        MODULE_KEYWORD      => 0,
        MODULE_IDENTIFIER   => 1,
        PARAMETER_PORT_LIST => 2,
        PORT_LIST           => 3,
        MODULE_ITEMS        => 4,
    };

    sub new
    {
        my $class = shift;
        my $self = $class->SUPER::new (@_);
        $self->{symtab} = VP3::Symtab->new;
        $self;
    }

    sub symtab { $_[0]->{symtab} }

    sub module_identifier
    {
        $_[0]->children->[MODULE_IDENTIFIER]->emit_self;
    }

    sub module_items
    {
        $_[0]->children->[MODULE_ITEMS];
    }

    sub port_list { $_[0]->children->[PORT_LIST] }

    # Returns the ports of this module, as a VP3::Ports object
    sub ports
    {
        my $self = shift;

        # h = Header, b = Body
        #my (%hports, %bports);
        my $bports = VP3::Ports->new;

        $bports->location ($self->location);

        my $module_items = $self->children->[MODULE_ITEMS]->children;

        if ($self->children->[PORT_LIST]->typeis ("list_of_port_identifiers")) {
            # Old-style module declaration.

            # !!! find a way to enable this?
            ## Check for consistency between module header port list and port
            ## declarations in body. Can only check this after @Ports is
            ## expanded.

            #for (@{$self->children->[PORT_LIST]->children}) {
            #    $hports{$_->emit_self}++;
            #}

            for (grep { $_->typeis ("input_declaration") ||
                        $_->typeis ("output_declaration") } @$module_items) {
                #for (grep { $_->typeis ("input_declaration") } @$module_items) {
                if ($_->typeis ("input_declaration")) {
                    my ($msb, $lsb) = (undef, undef);
                    if ($_->input_type->opt_range->typeis ("range")) {
                        $msb = VP3::Expression::evaluate ($self, $_->input_type->opt_range->msb);
                        $lsb = VP3::Expression::evaluate ($self, $_->input_type->opt_range->lsb);
                        defined $msb && defined $lsb
                            or return undef;
                    }
                    for ($_->port_names) {
                        #$bports{$_} = { name => $_, dir => "input", msb => $msb, lsb => $lsb };
                        $bports->add (VP3::Port->new (name => $_, dir => &VP3::Port::DIR_INPUT, msb => $msb, lsb => $lsb));
                    }
                }

                #for (grep { $_->typeis ("output_declaration") } @$module_items) {
                if ($_->typeis ("output_declaration")) {
                    my ($msb, $lsb) = (undef, undef);
                    if ($_->output_type->opt_range->typeis ("range")) {
                        $msb = VP3::Expression::evaluate ($self, $_->output_type->opt_range->msb);
                        $lsb = VP3::Expression::evaluate ($self, $_->output_type->opt_range->lsb);
                        defined $msb && defined $lsb
                            or return undef;
                    }
                    for ($_->port_names) {
                        #$bports{$_} = { name => $_, dir => "output", msb => $msb, lsb => $lsb };
                        $bports->add (VP3::Port->new (name => $_, dir => &VP3::Port::DIR_OUTPUT, msb => $msb, lsb => $lsb));
                    }
                }

            }

            # TODO inouts

            # !!! find a way to enable this? (if so, add back "use 5.010")
            #unless (%hports ~~ %bports) {
            #    # !!! need a much better error message
            #    print Dumper {hports => \%hports, bports => \%bports};
            #    die "Header and body ports defined in " . $self->module_identifier . " don't match\n";
            #}

        } else {
            # New-style module declarations. Ports defined in module header.

            for (grep { $_->typeis ("input_declaration") ||
                        $_->typeis ("output_declaration") } @{$self->children->[PORT_LIST]->children}) {
                #for (grep { $_->typeis ("input_declaration") } @{$self->children->[PORT_LIST]->children}) {
                if ($_->typeis ("input_declaration")) {
                    my ($msb, $lsb) = (undef, undef);
                    if ($_->input_type->opt_range->typeis ("range")) {
                        $msb = VP3::Expression::evaluate ($self, $_->input_type->opt_range->msb);
                        $lsb = VP3::Expression::evaluate ($self, $_->input_type->opt_range->lsb);
                        defined $msb && defined $lsb
                            or return undef;
                    }
                    for ($_->port_names) {
                        $bports->add (VP3::Port->new (name => $_, dir => &VP3::Port::DIR_INPUT, msb => $msb, lsb => $lsb));
                    }
                }

                #for (grep { $_->typeis ("output_declaration") } @{$self->children->[PORT_LIST]->children}) {
                if ($_->typeis ("output_declaration")) {
                    my ($msb, $lsb) = (undef, undef);
                    if ($_->output_type->opt_range->typeis ("range")) {
                        $msb = VP3::Expression::evaluate ($self, $_->output_type->opt_range->msb);
                        $lsb = VP3::Expression::evaluate ($self, $_->output_type->opt_range->lsb);
                        defined $msb && defined $lsb
                            or return undef;
                    }
                    for ($_->port_names) {
                        $bports->add (VP3::Port->new (name => $_, dir => &VP3::Port::DIR_OUTPUT, msb => $msb, lsb => $lsb));
                    }
                }

                # TODO inouts
            }

        }

        return $bports;
    }

} # package VP3::ParseTree::module_declaration

{
    package VP3::ParseTree::vp3_module_declaration;
    use base 'VP3::ParseTree::module_declaration';

    use Carp;

    use constant {
        VP3_MODULE_DIRECTIVE => 0,
        MODULE_ITEMS         => 1,
        ENDMODULE_KEYWORD    => 2,
    };

    sub vp3_module_directive { $_[0]->children->[VP3_MODULE_DIRECTIVE] }

    sub module_identifier
    {
        $_[0]->children->[VP3_MODULE_DIRECTIVE]->module_identifier;
    }

    sub module_items
    {
        $_[0]->children->[MODULE_ITEMS];
    }

    sub endmodule_keyword { $_[0]->children->[ENDMODULE_KEYWORD] }

    sub ports
    {
        VP3::fatal ("can't determine ports of a vp3_module_declaration");
    }

} # package VP3::ParseTree::vp3_module_declaration

{

    package VP3::ParseTree::assignment;
    use base 'VP3::ParseTree';

    use Carp;

    use constant {
        LHS   => 0,
        DELAY => 1,
        RHS   => 2,
    };

    sub new
    {
        my ($class) = shift;
        my ($type) = splice (@_, 1, 1);
        my $self = $class->SUPER::new (@_);
        $type eq "continuous" || $type eq "blocking" || $type eq "nonblocking"
            or croak "Invalid assignment type `$type'";
        $self->{assignment_type} = $type;
        $self;
    }

    sub assignment_type { $_[0]->{assignment_type} }

    sub lhs { $_[0]->children->[LHS] }
    sub rhs { $_[0]->children->[RHS] }

} # package VP3::ParseTree::assignment

{
    package VP3::ParseTree::binary_operator_expression;
    use base 'VP3::ParseTree';

    use constant {
        LEFT    => 0,
        OP      => 1,
        RIGHT   => 2,
    };

    sub new
    {
        my ($class) = shift;
        my $self = $class->SUPER::new (@_);
        $self->{op} = $self->children->[OP]->emit_self;
        $self;
    }

    sub op { $_[0]->{op} }

    sub left  { $_[0]->children->[LEFT]  }
    sub right { $_[0]->children->[RIGHT] }

} # package VP3::ParseTree::binary_operator_expression

{

    package VP3::ParseTree::parameter_declaration;
    use base 'VP3::ParseTree';

    use Carp;

    use constant {
        LIST_OF_PARAM_ASSIGNMENTS => 2,
    };

    sub new
    {
        my ($class) = shift;
        my ($type) = splice (@_, 1, 1);
        my $self = $class->SUPER::new (@_);
        $type eq "localparam" || $type eq "parameter"
            or croak "Invalid parameter type `$type'";
        $self->{parameter_type} = $type;
        $self;
    }

    sub parameter_type { $_[0]->{parameter_type} }

    sub decls
    {
        my $self = shift;
        my %decls;

        for (@{$self->children->[LIST_OF_PARAM_ASSIGNMENTS]->children}) {
            my $ident = $_->lhs->emit_self;
            $decls{$ident} = VP3::Symbol->new ("parameter", $_->rhs);
        }

        %decls;
    }

} # package VP3::ParseTree::parameter_declaration

{
    package VP3::ParseTree::param_assignment;
    use base 'VP3::ParseTree';

    use constant {
        LHS => 0,
        RHS => 1,
    };

    sub lhs { $_[0]->children->[LHS] }
    sub rhs { $_[0]->children->[RHS] }

} # package VP3::ParseTree::param_assignment

{

    package VP3::ParseTree::input_declaration;
    use base 'VP3::ParseTree';

    use constant {
        INPUT_KEYWORD               => 0,
        INPUT_TYPE                  => 1,
        LIST_OF_PORT_IDENTIFIERS    => 2,
    };

    sub port_names {
        my $self = shift;
        my @rtn;

        for (@{$self->children->[LIST_OF_PORT_IDENTIFIERS]->children}) {
            push @rtn, $_->emit_self;
        }

        @rtn;
    }

    sub input_type { $_[0]->children->[INPUT_TYPE] }

    sub decls
    {
        my $self = shift;
        my %decls;

        my $keyword = $self->children->[INPUT_KEYWORD]->emit_self;

        for (@{$self->children->[LIST_OF_PORT_IDENTIFIERS]->children}) {
            my $ident = $_->emit_self;
            $decls{$ident} = $keyword;
        }

        %decls;
    }

} # package VP3::ParseTree::input_declaration

{
    package VP3::ParseTree::inout_declaration;
    use base 'VP3::ParseTree::input_declaration';
}

{
    package VP3::ParseTree::input_type;
    use base 'VP3::ParseTree';

    use constant {
        TYPE        => 0,
        OPT_SIGNED  => 1,
        OPT_RANGE   => 2,
    };

    sub type        { $_[0]->children->[TYPE] }
    sub opt_signed  { $_[0]->children->[OPT_SIGNED] }
    sub opt_range   { $_[0]->children->[OPT_RANGE] }
}

{

    package VP3::ParseTree::output_declaration;
    use base 'VP3::ParseTree';

    use constant {
        OUTPUT_KEYWORD  => 0,
        OUTPUT_TYPE     => 1,
        LIST            => 2,
    };

    sub port_names {
        my $self = shift;
        my @rtn;

        my $list = $self->children->[LIST];

        if ($list->typeis ("list_of_port_identifiers")) {
            for (@{$list->children}) {
                push @rtn, $_->emit_self;
            }
        } elsif ($list->typeis ("list_of_variable_port_identifiers")) {
            for (@{$list->children}) {
                # variable_port_identifier is an identifier and an optional
                # (constant) assignment. !!! fix hardcoded [0]
                push @rtn, $_->children->[0]->emit_self;
            }
        }

        @rtn;
    }

    sub output_type { $_[0]->children->[OUTPUT_TYPE] }

    sub decls
    {
        my $self = shift;
        my %decls;

        my $list = $self->children->[LIST];

        if ($list->typeis ("list_of_port_identifiers")) {
            for (@{$list->children}) {
                my $ident = $_->emit_self;
                $decls{$ident} = "output";
            }
        } elsif ($list->typeis ("list_of_variable_port_identifiers")) {
            for (@{$list->children}) {
                # variable_port_identifier is an identifier and an optional
                # (constant) assignment. !!! fix hardcoded [0]
                my $ident = $_->children->[0]->emit_self;
                $decls{$ident} = "output";
            }
        }

        %decls;
    }

} # package VP3::ParseTree::output_declaration

{
    package VP3::ParseTree::output_type;
    use base 'VP3::ParseTree';

    use constant {
        TYPE        => 0,
        OPT_SIGNED  => 1,
        OPT_RANGE   => 2,
    };

    sub type        { $_[0]->children->[TYPE] }
    sub opt_signed  { $_[0]->children->[OPT_SIGNED] }
    sub opt_range   { $_[0]->children->[OPT_RANGE] }
}

{
    package VP3::ParseTree::reg_declaration;
    use base 'VP3::ParseTree';

    use constant {
        OPT_SIGNED                   => 0,
        OPT_RANGE                    => 1,
        LIST_OF_VARIABLE_IDENTIFIERS => 2,
    };

    sub decls
    {
        my $self = shift;
        my %decls;

        for (@{$self->children->[LIST_OF_VARIABLE_IDENTIFIERS]->children}) {
            # !!! should be a method for this
            my $ident = $_->children->[0]->emit_self;
            $decls{$ident} = "reg";
        }

        %decls;
    }

} # package VP3::ParseTree::reg_declaration

{
    package VP3::ParseTree::integer_declaration;
    use base 'VP3::ParseTree';

    use constant {
        LIST_OF_VARIABLE_IDENTIFIERS => 0,
    };

    sub decls
    {
        my $self = shift;
        my %decls;

        for (@{$self->children->[LIST_OF_VARIABLE_IDENTIFIERS]->children}) {
            # !!! should be a method for this
            my $ident = $_->children->[0]->emit_self;
            $decls{$ident} = "integer";
        }

        %decls;
    }

} # package VP3::ParseTree::integer_declaration

{
    package VP3::ParseTree::genvar_declaration;
    use base 'VP3::ParseTree';

    use constant {
        LIST_OF_GENVAR_IDENTIFIERS => 0,
    };

    sub decls
    {
        my $self = shift;
        my %decls;

        for (@{$self->children->[LIST_OF_GENVAR_IDENTIFIERS]->children}) {
            # !!! should be a method for this
            my $ident = $_->emit_self;
            $decls{$ident} = "genvar";
        }

        %decls;
    }

} # package VP3::ParseTree::genvar_declaration

{
    package VP3::ParseTree::net_declaration;
    use base 'VP3::ParseTree';

    use constant {
        NET_TYPE                    => 0,
        OPT_DRIVE_STRENGTH          => 1,
        OPT_VECTORED_OR_SCALARED    => 2,
        OPT_SIGNED                  => 3,
        OPT_RANGE                   => 4,
        OPT_DELAY3                  => 5,
        LIST                        => 6,
    };

    sub list { $_[0]->children->[LIST] }

    sub new
    {
        my $class = shift;
        my $self = $class->SUPER::new (@_);

        if ($self->children->[OPT_DRIVE_STRENGTH]->type ne "null" &&
            $self->children->[LIST]->type ne "list_of_net_decl_assignments") {
            # !!! Sanity check this error case on other tools
            die "Drive strength illegal in net declaration without assignments";
        }

        $self;
    }

    sub decls
    {
        my $self = shift;
        my %decls;

        if ($self->children->[LIST]->type eq "list_of_net_decl_assignments") {
            for (@{$self->children->[LIST]->children}) {
                # !!! should be a method for this
                my $ident = $_->children->[0]->emit_self;
                $decls{$ident} = "net";
            }
        } elsif ($self->children->[LIST]->type eq "list_of_net_identifiers") {
            for (@{$self->children->[LIST]->children}) {
                # !!! should be a method for this
                my $ident = $_->children->[0]->emit_self;
                $decls{$ident} = "net";
            }
        } else {
            VP3::fatal ("Illegal declaration list type in net_declaration")
        }

        %decls;
    }

} # package VP3::ParseTree::net_declaration

{
    package VP3::ParseTree::trireg_declaration;
    use base 'VP3::ParseTree';

    use constant {
        OPT_DRIVE_STRENGTH          => 0,
        OPT_CHARGE_STRENGTH         => 1,
        OPT_VECTORED_OR_SCALARED    => 2,
        OPT_SIGNED                  => 3,
        OPT_RANGE                   => 4,
        OPT_DELAY3                  => 5,
        LIST                        => 6,
    };

    sub new
    {
        my $class = shift;
        my $self = $class->SUPER::new (@_);

        if ($self->children->[OPT_DRIVE_STRENGTH]->type ne "null" &&
            $self->children->[LIST]->type ne "list_of_net_decl_assignments") {
            # !!! Sanity check this error case on other tools
            VP3::error ("Drive strength illegal in trireg declaration without assignments");
        }

        if ($self->children->[OPT_CHARGE_STRENGTH]->type ne "null" &&
            $self->children->[LIST]->type ne "list_of_net_identifiers") {
            VP3::error ("Charge strength illegal in trireg declaration with assignments");
        }

        $self;
    }

    sub decls
    {
        my $self = shift;
        my %decls;

        if ($self->children->[LIST]->type eq "list_of_net_decl_assignments") {
            for (@{$self->children->[LIST]->children}) {
                # !!! should be a method for this
                my $ident = $_->children->[0]->emit_self;
                $decls{$ident} = "trireg";
            }
        } elsif ($self->children->[LIST]->type eq "list_of_net_identifiers") {
            for (@{$self->children->[LIST]->children}) {
                # !!! should be a method for this
                my $ident = $_->children->[0]->emit_self;
                $decls{$ident} = "trireg";
            }
        } else {
            VP3::fatal ("Illegal declaration list type in trireg_declaration");
        }

        %decls;
    }

}

{
    package VP3::ParseTree::range;
    use base 'VP3::ParseTree';

    use constant {
        MSB => 0,
        LSB => 1,
    };

    sub msb { $_[0]->children->[MSB] }
    sub lsb { $_[0]->children->[LSB] }
}

{
    package VP3::ParseTree::range_expression_colon;
    use base 'VP3::ParseTree';

    use constant {
        LHS   => 0,
        COLON => 1,
        RHS   => 2,
    };

    sub new
    {
        my $class = shift;
        my $self = $class->SUPER::new (@_);
    }

    sub evaluate_msb
    {
        my ($self, $scope) = @_;

        my $colon = $self->children->[COLON]->emit_self;

        if ($colon eq ":") {
            return VP3::Expression::evaluate ($scope, $self->children->[LHS]);
        } elsif ($colon eq "+:") {
            # is this right for big-endian?
            my $lhs = VP3::Expression::evaluate ($scope, $self->children->[LHS]);
            my $rhs = VP3::Expression::evaluate ($scope, $self->children->[RHS]);
            return (defined ($lhs) && defined ($rhs)) ? $lhs + $rhs - 1 : undef;
        } elsif ($colon eq "-:") {
            # ditto the big-endian question
            return VP3::Expression::evaluate ($scope, $self->children->[LHS]);
        } else {
            # the parser shouldn't have produced anything else
            VP3::fatal ("Illegal colon token `" . $colon . "' in range_expression_colon");
        }
    }

    sub evaluate_lsb
    {
        my ($self, $scope) = @_;

        my $colon = $self->children->[COLON]->emit_self;

        if ($colon eq ":") {
            return VP3::Expression::evaluate ($scope, $self->children->[RHS]);
        } elsif ($colon eq "+:") {
            # is this right for big-endian?
            return VP3::Expression::evaluate ($scope, $self->children->[LHS]);
        } elsif ($colon eq "-:") {
            # ditto the big-endian question
            my $lhs = VP3::Expression::evaluate ($scope, $self->children->[LHS]);
            my $rhs = VP3::Expression::evaluate ($scope, $self->children->[RHS]);
            return (defined ($lhs) && defined ($rhs)) ? $lhs - $rhs + 1 : undef;
        } else {
            # the parser shouldn't have produced anything else
            VP3::fatal ("Illegal colon token `" . $colon . "' in range_expression_colon");
        }
    }

}

{
    package VP3::ParseTree::conditional_statement;
    use base 'VP3::ParseTree';

    use constant {
        EXPR        => 0,
        STATEMENT   => 1,
        OPT_ELSE    => 2,
    };

    sub expr        { $_[0]->children->[EXPR] }
    sub statement   { $_[0]->children->[STATEMENT] }
    sub opt_else    { $_[0]->children->[OPT_ELSE] }
}

{
    package VP3::ParseTree::case_statement;
    use base 'VP3::ParseTree';

    use constant {
        EXPR    => 0,
        ITEMS   => 1,
    };

    sub expr { $_[0]->children->[EXPR] }
    sub items { $_[0]->children->[ITEMS] }
}

{
    package VP3::ParseTree::procedural_timing_control_statement;
    use base 'VP3::ParseTree';

    use constant {
        DELAY_OR_EVENT_CONTROL  => 0,
        STATEMENT_OR_NULL       => 1,
    };

    sub delay_or_event_control  { $_[0]->children->[DELAY_OR_EVENT_CONTROL] }
    sub statement_or_null       { $_[0]->children->[STATEMENT_OR_NULL] }
}

{
    package VP3::ParseTree::module_instantiation;
    use base 'VP3::ParseTree';

    use constant {
        MODULE_IDENTIFIER           => 0,
        PARAMETER_VALUE_ASSIGNMENT  => 1,
        MODULE_INSTANCES            => 2,
    };

    sub module_identifier { $_[0]->children->[MODULE_IDENTIFIER] }
    sub module_instances  { $_[0]->children->[MODULE_INSTANCES] }

} # package VP3::ParseTree::module_instantiation

{
    package VP3::ParseTree::module_instance;
    use base 'VP3::ParseTree';

    use constant {
        NAME_OF_INSTANCE            => 0,
        LIST_OF_PORT_CONNECTIONS    => 1,
    };

    sub name_of_instance { $_[0]->children->[NAME_OF_INSTANCE] }
    sub list_of_port_connections { $_[0]->children->[LIST_OF_PORT_CONNECTIONS] }

} # package VP3::ParseTree::module_instance

{
    package VP3::ParseTree::named_port_connection;
    use base 'VP3::ParseTree';

    use constant {
        PORT_IDENTIFIER => 0,
        EXPRESSION      => 1,
    };

    sub port_identifier { $_[0]->children->[PORT_IDENTIFIER] }
    sub expression      { $_[0]->children->[EXPRESSION] }

} # package VP3::ParseTree::named_port_connection

{

    # Used for both task_enable and system_task_enable

    package VP3::ParseTree::task_enable;
    use base 'VP3::ParseTree';

    use constant {
        IDENTIFIER      => 0,
        OPT_ARGUMENTS   => 1,
    };

    sub identifier { $_[0]->children->[IDENTIFIER] }
    sub opt_arguments { $_[0]->children->[OPT_ARGUMENTS] }
}

{

    # Used for both function_call and system_function_call
    #
    # Arguments are required for user functions, but optional for system functions

    package VP3::ParseTree::function_call;
    use base 'VP3::ParseTree';

    use constant {
        IDENTIFIER  => 0,
        ARGUMENTS   => 1,
    };

    sub identifier { $_[0]->children->[IDENTIFIER] }
    sub arguments { $_[0]->children->[ARGUMENTS] }
}

{
    package VP3::ParseTree::vp3_directive;
    use base 'VP3::ParseTree';

    use constant {
        DIRECTIVE_KEYWORD => 0,
        TEXT_ITEMS => 1,
    };

    sub directive_keyword { $_[0]->children->[DIRECTIVE_KEYWORD] }

    sub directive_text
    {
        join (" ", map { $_->emit_self } @{$_[0]->children->[TEXT_ITEMS]->children});
    }
}

{
    package VP3::ParseTree::vp3_instance_directive;
    use base 'VP3::ParseTree::vp3_directive';

    use Getopt::Long;

    sub new
    {
        my $class = shift;

        my $self = $class->SUPER::new (@_);

        $self->{renames} = [ ];

        my $text = $self->directive_text;
        local (@ARGV) = VP3::Utils::directive_words ($text);

        my $odd;
        my $rv = GetOptions ("connect=s{2}" => sub {
                                                     ($odd ^= 1) ? push @{$self->{renames}}, [ $_[1] ]
                                                                 : push @{$self->{renames}->[-1]}, $_[1];
                                                   },
                             "file=s" => \$self->{file});
        $rv or do {
            VP3::error ("Couldn't parse \@Instance directive: $text");
            return VP3::ParseTree->factory (whitespace => $self->emit_self);
        };

        unless (@ARGV == 2) {
            VP3::error ("Invalid arguments to \@Instance directive: $text");
            return VP3::ParseTree->factory (whitespace => $self->emit_self);
        };

        $self->{module} = $ARGV[0];
        $self->{instance_name} = $ARGV[1];

        $self;
    }

    sub module { $_[0]->{module} }
    sub instance_name { $_[0]->{instance_name} }
    sub renames { $_[0]->{renames} }
    sub file { $_[0]->{file} }

}

{
    package VP3::ParseTree::vp3_module_directive;
    use base 'VP3::ParseTree::vp3_directive';

    use Getopt::Long;

    sub new
    {
        my $class = shift;
        my ($default_module_identifier) = splice (@_, 1, 1);

        my $self = $class->SUPER::new (@_);

        # Parse the directive using Getopt

        my $text = $self->directive_text;

        local (@ARGV) = VP3::Utils::directive_words ($text);

        my $rv = GetOptions (
            v2k => \$self->{v2k},
            "attr=s" => \$self->{attr},
            none => \$self->{opt_none},
        );
        $rv or do {
            VP3::error ("Couldn't parse \@Module directive: $text");
            return VP3::ParseTree->factory (whitespace => $self->emit_self);
        };

        unless (@ARGV <= 1) {
            VP3::error ("Invalid arguments to \@Module directive: $text");
            return VP3::ParseTree->factory (whitespace => $self->emit_self);
        }

        my ($module_identifier) = @ARGV;

        #

        $self->{module_identifier} = $module_identifier || $default_module_identifier;

        $self;
    }

    sub module_identifier { $_[0]->{module_identifier} }
    sub v2k { $_[0]->{v2k} }
    sub attr { $_[0]->{attr} }
    sub opt_none { $_[0]->{opt_none} }

} # package VP3::ParseTree::vp3_module_directive

# FIXME: inheriting from vp3_directive because it's easy. but `directive_text'
# method won't work right for these
{
    package VP3::ParseTree::vp3_ports_directive;
    use base 'VP3::ParseTree::vp3_directive';
}

{
    package VP3::ParseTree::vp3_regs_directive;
    use base 'VP3::ParseTree::vp3_directive';
}

{
    package VP3::ParseTree::vp3_wires_directive;
    use base 'VP3::ParseTree::vp3_directive';
}

{
    package VP3::ParseTree::vp3_vector_directive;
    use base 'VP3::ParseTree';

    use constant {
        WIDTH       => 0,
        IDENTIFIER  => 1,
    };

    sub width { $_[0]->children->[WIDTH] }
    sub identifier { $_[0]->children->[IDENTIFIER] }
}

{
    package VP3::ParseTree::vp3_force_directive;
    use base 'VP3::ParseTree';

    use constant {
        IDENTIFIER  => 0,
    };

    sub force_type { $_[0]->{force_type} }
    sub identifier { $_[0]->children->[IDENTIFIER] }

    sub new {
        my $class = shift;
        my $type = splice (@_, 1, 1);
        my $self = $class->SUPER::new (@_);
        $self->{force_type} = $type;
        $self;
    }
}

{
    package VP3::ParseTree::vp3_waive_directive;
    use base 'VP3::ParseTree';

    use constant {
        WAIVER_TYPE => 0,
        IDENTIFIER  => 1,
    };

    sub waiver_type { $_[0]->children->[WAIVER_TYPE]->emit_self }
    sub identifier { $_[0]->children->[IDENTIFIER]->emit_self }

}

{
    package VP3::ParseTree::identifier_subscripts;
    use base 'VP3::ParseTree';

    use constant {
        IDENTIFIER  => 0,
        SUBSCRIPTS  => 1,
    };

    # hierarchical_identifier
    sub identifier { $_[0]->children->[IDENTIFIER] }
    sub subscripts { $_[0]->children->[SUBSCRIPTS] }
}

1;

# vim: sts=4 sw=4 et
