{

    package VP3::Connectivity;

    use Carp;

    sub new
    {
        my ($class, $location, $type, $direction) = @_;

        $direction or confess ("Must specify connection direction");
        if ($direction eq "source") {
            $type or confess ("Must specify connection type for source connections");
        }

        my $self = {
            location    => $location,
            type        => $type,
            direction   => $direction,
        };
        return bless $self, $class;
    }

    # Not right for big-endian vectors !!!
    sub lsb
    {
        my ($self, $new_lsb) = @_;

        defined ($new_lsb) and $self->{lsb} = $new_lsb;

        $self->{lsb};
    }

    sub msb
    {
        my ($self, $new_msb) = @_;

        defined ($new_msb) and $self->{msb} = $new_msb;

        $self->{msb};
    }

} # package VP3::Connectivity

{

    package VP3::ConnectivityDB;

    #use VP3::Errors;
    #VP3::Errors->import;

    sub new
    {
        my ($class) = @_;
        my $self = {
            signals => { },
            waivers => { no_source => [ ], no_sink => [ ], },
        };
        bless $self, $class;
    }

    sub db_each
    {
        # Need to force list context
        (each %{$_[0]->{signals}});
    }

    sub signals
    {
        return keys %{$_[0]->{signals}};
    }

    sub signal
    {
        my ($self, $signal) = @_;
        return $self->{signals}{$signal} ||= VP3::Signal->new ($signal);
    }

    sub sourceless
    {
        grep { 0 == $_->sources } values %{$_[0]->{signals}};
    }

    sub sinkless
    {
        grep { 0 == $_->sinks } values %{$_[0]->{signals}};
    }

    # Check for unwaived sourceless and sinkless signals
    sub validate
    {
        my $self = shift;

        my @sourceless = $self->sourceless;
        my @sinkless = $self->sinkless;

        for my $sig (sort { $a->identifier cmp $b->identifier } @sourceless) {
            unless (grep { $_ eq $sig->identifier } @{$self->{waivers}{no_source}}) {
                VP3::warning ("Signal " . $sig->identifier . " has no source");
            }
        }

        for my $sig (sort { $a->identifier cmp $b->identifier } @sinkless) {
            unless (grep { $_ eq $sig->identifier } @{$self->{waivers}{no_sink}}) {
                VP3::warning ("Signal " . $sig->identifier . " has no sink");
            }
        }
    }

} # package VP3::ConnectivityDB

{

    package VP3::RTLTool::ConnectivityAnalyzer;
    use base 'VP3::ParseTreeVisitor';

    #use VP3::Errors;
    #VP3::Errors->import;

    use Carp;
    use Data::Dumper;

    # Main entry point.
    # static method
    sub analyze
    {
        my ($rt, $module) = @_;

        $module->typeis ("module_declaration")
            or confess "usage: VP3::RTLTool::ConnectivityAnalyzer->analyze (<module_declaration obj>)";

        my $obj = __PACKAGE__->new ($rt, $module);
        $obj->visit ($module);
        $obj->result;
    }

    sub new
    {
        my ($class, $rt, $module) = @_;
        my $self = $class->SUPER::new;
        $self->{rt}            = $rt;
        $self->{module}        = $module;
        $self->{direction}     = "sink";
        $self->{source_type}   = undef;
        $self->{inst_ports}    = undef;
        $self->{db}            = VP3::ConnectivityDB->new;
        bless $self, $class;
    }

    sub result { $_[0]->{db}; }

    # Utilities

    sub ignore { }

    # Element-specific visit methods

    {
        #no strict 'refs';
        no warnings qw(once);

        # Portions of the source that we can ignore entirely
        *visit_list_of_port_identifiers = \&ignore;
        *visit_list_of_variable_port_identifiers = \&ignore;
        *visit_inout_declaration    = \&ignore;
        *visit_reg_declaration      = \&ignore;
        *visit_integer_declaration  = \&ignore;
        *visit_real_declaration     = \&ignore;
        *visit_time_declaration     = \&ignore;
        *visit_realtime_declaration = \&ignore;
        *visit_event_declaration    = \&ignore;
        *visit_genvar_declaration   = \&ignore;

        *visit_parameter_override   = \&ignore;

        *visit_generated_instantiation = \&ignore;

        # !!! Probably these need to be considered in some form
        *visit_function_declaration = \&ignore;
        *visit_task_declaration     = \&ignore;
    }

    sub visit_module_declaration
    {
        my ($self, $target) = @_;
        my $conn;

        #print "Visiting module ", $target->module_identifier, "\n";

        $self->visit ($target->port_list);
        $self->visit ($target->module_items);
    }

    sub visit_assignment
    {
        my ($self, $target) = @_;

        if ($target->assignment_type eq "continuous") {
            $self->{source_type} = "net";
        } elsif ($target->assignment_type eq "blocking" ||
                 $target->assignment_type eq "nonblocking") {
            $self->{source_type} = "variable";
        } else {
            VP3::fatal ("Unknown assignment type $target->assignment_type");
        }

        $self->push_target ($target);

        $self->{direction} = "source";
        $self->visit ($target->lhs);

        $self->{direction} = "sink";
        $self->visit ($target->rhs);

        #$self->{direction} = undef;

        $self->{source_type} = undef;

        $self->pop_target;
    }

    sub visit_net_declaration
    {
        my ($self, $target) = @_;

        if ($target->list->typeis ("list_of_net_decl_assignments")) {
            $self->visit ($target->list);
        }
    }

    sub visit_input_declaration
    {
        my ($self, $target) = @_;

        for ($target->port_names) {
            my $conn = VP3::Connectivity->new ($target->line, "input", "source");
            $self->{db}->signal ($_)->add_connectivity ($conn);
        }
    }

    sub visit_output_declaration
    {
        my ($self, $target) = @_;

        for ($target->port_names) {
            my $conn = VP3::Connectivity->new ($target->line, "output", "sink");
            $self->{db}->signal ($_)->add_connectivity ($conn);
        }
    }

    sub visit_identifier
    {
        my ($self, $target) = @_;

        my $ident = $target->emit_self;
        # !!! shouldn't assume the module is the scope, need to push/pop scopes
        # as we go (assumed scope)
        my $sym   = $self->{module}->symtab->lookup ($ident);
        $sym && $sym->type eq "parameter" and return;

        # TODO be more careful and enable this error check

        # state [0]: sink type (net, variable; previously always, instance)
        # state [1]: direction (source, sink)
        #ref ($self->{state}) eq "ARRAY"
        #    or confess "Internal error. \$self->{state} = " . Dumper ($self->{state});

        #defined ($self->{state}[0]) && defined ($self->{state}[1])
        #    or die "Internal error\n" . $self->dump_targets;

        my $conn = VP3::Connectivity->new ($target->line, $self->{source_type}, $self->{direction});
        $self->{db}->signal ($ident)->add_connectivity ($conn);
    }

    sub visit_hierarchical_identifier
    {
        # Connectivity of hierarchical references not processed
        return;
    }

    sub visit_identifier_subscripts
    {
        my ($self, $target) = @_;

        #print $target->type, "\n";
        #print $target->emit, "\n";
        #print $target->identifier->type, "\n";

        if ($target->identifier->typeis ("hierarchical_identifier")) {
            # Connectivity of hierarchical references not processed
            return;
        }

        # parameters don't generate connectivity
        my $ident = $target->identifier->emit_self;
        # !!! assumed scope
        my $sym  = $self->{module}->symtab->lookup ($ident);
        $sym && $sym->type eq "parameter" and return;

        my $subscripts = $target->subscripts->children;

        # MDAs connectivity is not processed
        if (@$subscripts > 1) {
            return;
        }

        my $conn = VP3::Connectivity->new ($target->line, $self->{source_type}, $self->{direction});

        # We bailed if there are multiple subscripts, so this is the same as [0]
        my $range = $subscripts->[-1];

        #print STDERR "working on $ident: " . $range->emit_self . " (" . $range->type . ")\n";

        # duplicates visit_named_port_connection
        if ($range->typeis ("unsigned_number")) {
            my $bit = VP3::Expression::evaluate ($self->{module}, $range); # !!! assumed scope
            $bit =~ /^\d+$/ or die "Unsupported complex expression in range: $bit"; # !!!
            $conn->msb ($bit);
            $conn->lsb ($bit);
        } elsif ($range->typeis ("range_expression_colon")) {
            # MSB:LSB range specification

            my $msb = $range->evaluate_msb ($self->{module}); # !!! assumed scope
            my $lsb = $range->evaluate_lsb ($self->{module}); # !!! assumed scope

            $conn->msb ($msb);
            $conn->lsb ($lsb);
        } elsif ($range->typeis ("identifier") || $range->typeis ("identifier_subscripts")) {
            my $saved_source_type = $self->{source_type};
            my $saved_direction   = $self->{direction};

            $self->{source_type} = undef;
            $self->{direction}   = "sink";

            $self->visit ($range);

            $self->{source_type} = $saved_source_type;
            $self->{direction}   = $saved_direction;
        } else {
            #die "Unknown or unsupported range_expression type " . $range->type . "\n" . Dumper ($range);
            # !!!
        }

        $self->{db}->signal ($ident)->add_connectivity ($conn);
    }

    sub visit_conditional_statement
    {
        my ($self, $target) = @_;

        $self->push_target ($target);

        #$self->{direction} = "sink";
        $self->visit ($target->expr);
        #$self->{direction} = undef;

        $self->visit ($target->statement);
        $self->visit ($target->opt_else);

        $self->pop_target;
    }

    sub visit_case_statement
    {
        my ($self, $target) = @_;

        $self->push_target ($target);

        #$self->{direction} = "sink";
        $self->visit ($target->expr);
        #$self->{direction} = undef;

        $self->visit ($target->items);

        $self->pop_target;
    }

    sub visit_module_instantiation
    {
        my ($self, $target) = @_;

        my $inst_module = $target->module_identifier->emit_self;

        my $ports = $self->{rt}{vp3}->ports ($inst_module);

        # !!! should we fail if we don't get the ports?

        if ($ports) {
            $self->{source_type}  = "net";
            $self->{inst_ports}   = $ports;
            $self->{inst_module}  = $inst_module;

            $self->visit ($target->module_instances);

            $self->{source_type}  = undef;
            $self->{inst_ports}   = undef;
            $self->{inst_module}  = undef;
        }
    }

    sub visit_module_instance
    {
        my ($self, $target) = @_;
        $self->visit ($target->list_of_port_connections);
    }

    sub visit_named_port_connection
    {
        my ($self, $target) = @_;

        my $ident = $target->port_identifier->emit_self;

        if (!exists $self->{inst_ports}{$ident}) {
            VP3::error ($target->location . ": port `$ident' not found in module `$self->{inst_module}'",
                        "module `$self->{inst_module}' defined at " . $self->{inst_ports}->location);
            return;
        }

        # Check connection widths
        if ($target->expression->typeis ("identifier_subscripts")) {
            my $identifier_subscripts = $target->expression;
            #print STDERR "Checking expression widths for $ident\n";

            my $range = $identifier_subscripts->subscripts->children->[-1];
            my $loconn_msb = $self->{inst_ports}{$ident}{msb};
            my $loconn_lsb = $self->{inst_ports}{$ident}{lsb};

            if ($range->typeis ("unsigned_number")) {
                # Single bit range specification

                my $bit = VP3::Expression::evaluate ($self->{module}, $range); # !!! assumed scope
                $bit =~ /^\d+$/ or die "Unsupported complex expression in range: $bit"; # !!!
                if (!defined ($loconn_msb)) {
                    # single-bit vector connected to scalar, this is ok
                } elsif ($loconn_msb != $loconn_lsb) {
                    VP3::warning ($target->location . ": range mismatch in connection for port `$ident'",
                                  "range in $self->{inst_module} is [$loconn_msb:$loconn_lsb]",
                                  "connected to $identifier_subscripts->identifier with range [$bit]");
                }

            } elsif ($range->typeis ("range_expression_colon")) {
                # MSB:LSB range specification

                my $hiconn_msb = $range->evaluate_msb ($self->{module}); # !!! assumed scope
                my $hiconn_lsb = $range->evaluate_lsb ($self->{module}); # !!! assumed scope

                defined ($hiconn_msb) && defined ($loconn_msb) && defined ($hiconn_lsb) && defined ($loconn_lsb)
                    or do { no warnings 'uninitialized'; die "Undefined range value in connection of `$ident', hiconn $hiconn_msb:$hiconn_lsb, loconn $loconn_msb:$loconn_lsb"; }; # !!!

                my $hiconn_width = $hiconn_msb >= $hiconn_lsb ? $hiconn_msb - $hiconn_lsb + 1 : $hiconn_lsb - $hiconn_msb + 1;
                my $loconn_width = $loconn_msb >= $loconn_lsb ? $loconn_msb - $loconn_lsb + 1 : $loconn_lsb - $loconn_msb + 1;

                if ($hiconn_width != $loconn_width) {
                    VP3::warning ($target->location . ": range mismatch in connection for port `$ident'",
                                  "range in $self->{inst_module} is [$loconn_msb:$loconn_lsb]",
                                  "connected to " . $identifier_subscripts->identifier->emit_self . " with range [$hiconn_msb:$hiconn_lsb]");
                }

            } else {
                die "Unknown or unsupported range_expression type " . $range->type . "\n" . Dumper ($range);
            }

        }

        # source_type is set to net by visit_module_instantiation

        if ($self->{inst_ports}{$ident}{dir} == &VP3::Port::DIR_INPUT) {
            #$self->{direction} = "sink";
            $self->visit ($target->expression);
        } elsif ($self->{inst_ports}{$ident}{dir} == &VP3::Port::DIR_OUTPUT) {
            $self->{direction} = "source";
            $self->visit ($target->expression);
            $self->{direction} = "sink";
        } else {
            # Internal error
            VP3::fatal ("Unknown port direction `" . $self->{inst_ports}{$ident}{dir} . "'");
        }
    }

    sub visit_task_enable
    {
        my ($self, $target) = @_;

        if ($target->identifier->is_system_identifier) {
            return;
        } else {
            $self->visit ($target->opt_arguments);
        }
    }

    sub visit_function_call
    {
        my ($self, $target) = @_;

        if ($target->identifier->is_system_identifier) {
            return;
        } else {
            $self->visit ($target->arguments);
        }
    }

    sub visit_vp3_vector_directive
    {
        my ($self, $target) = @_;

        my $signal = $self->{db}->signal ($target->identifier->emit_self);

        if ($target->width->typeis ("range")) {
            my $msb = VP3::Expression::evaluate ($self->{module}, $target->width->msb);
            my $lsb = VP3::Expression::evaluate ($self->{module}, $target->width->lsb);
            $signal->update_msb ($msb);
            $signal->update_lsb ($lsb);
        } else {
            my $width = VP3::Expression::evaluate ($self->{module}, $target->width);
            $signal->set_width ($width);
        }
    }

    sub visit_vp3_force_directive
    {
        my ($self, $target) = @_;

        $self->{db}->signal ($target->identifier->emit_self)
            ->set_force_type ($target->force_type);
    }

    sub visit_vp3_waive_directive
    {
        my ($self, $target) = @_;

        my $waiver_type = $target->waiver_type;

        if (!exists ({
                        "no_source" => 1,
                        "no_sink"   => 1,
                     }->{$waiver_type})) {
            VP3::error ("Bad waiver type $waiver_type");
            return;
        }

        push @{$self->{db}{waivers}{$waiver_type}}, $target->identifier;
    }

} # package VP3::RTLTool::ConnectivityAnalyzer

1;

# vim: sts=4 sw=4 et
