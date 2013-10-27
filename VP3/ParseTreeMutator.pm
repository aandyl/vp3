package VP3::ParseTreeMutator;
use base 'VP3::ParseTreeVisitor';

no warnings 'recursion';

sub visit
{
    $_[0]->{debug} && print STDERR "visit ", $_[1]->type, "\n";

    goto $_[0]->can ("visit_" . $_[1]->type) ||
         $_[0]->{default};
}

sub visit_children
{
    my @result;

    for (@{$_[1]->children}) {
        push @result, $_[0]->visit ($_);
    }

    @{$_[1]->children} = @result;

    $_[1];
}

sub parse
{
    my ($self, $mode, $text, $error_ref) = @_;

    my $p = VP3::Parser->new;
    $p->scope (VP3::ParseTree->factory ("module_declaration"));
    $p->YYData->{lexer} = VP3::Lexer->new ($mode);

    open (my $fh, "<", \$text)
        or VP3::fatal ("unable to open string as a filehandle: $!");
    $p->YYData->{lexer}->input ($fh, undef);

    $p->YYParse (
                 yylex   => sub { $_[0]->YYData->{lexer}->lex (@_[1..$#_]) },
                 yyerror => \&VP3::Parser::default_yyerror,
                )
        or ($$error_ref = $p->YYData->{error}, undef);
}

1;

# vim: sts=4 sw=4 et
