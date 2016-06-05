package VP3::ParseTreeVisitor;

# Abstract base class for parse tree visitors

no warnings 'recursion';

sub new
{
    my ($class, $default) = @_;

    my $self = {
        target_stack => [],
    };

    bless $self, $class;

    $default ||= $self->can ("visit_children");
    $self->{default} = $default;

    $self;
}

sub debug
{
    $_[0]->{debug} = $_[1];
}

sub visit
{
    my ($self, $target) = @_;

    print STDERR "visit ", $target->type, "\n" if $self->{debug};

    goto $self->can ("visit_" . $target->type) ||
         $self->{default};
}

sub visit_children
{
    my ($self, $target) = @_;

    $self->push_target ($target);

    for (@{$target->children}) {
        $self->visit ($_);
    }

    $self->pop_target;
}

# target_stack only used for debugging?
sub push_target
{
    push @{$_[0]->{target_stack}}, $_[1];
}

sub pop_target
{
    pop @{$_[0]->{target_stack}};
}

sub dump_targets
{
    print scalar @{$_[0]->{target_stack}};
    join "", map { $_->type . " `" . substr ($_->emit_self, 0, 60) . "'\n" } @{$_[0]->{target_stack}};
}

1;

# vim: sts=4 sw=4 et
