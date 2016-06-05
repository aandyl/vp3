package VP3::Expression;

#use Data::Dumper;

# class method
sub evaluate
{
    my ($scope, $expr) = @_;

    goto __PACKAGE__->can ("eval_" . $expr->type) ||
         sub { VP3::error ("Evaluation of an expression of type `" . $_[1]->type . "' is not supported"); undef };
}

sub eval_identifier
{
    my ($scope, $ident_obj) = @_;

    my $ident = $ident_obj->emit_self;

    my $sym = $scope->symtab->lookup ($ident);

    #print Dumper ({ ident => $ident, sym => $sym });

    if ($sym && $sym->type eq "parameter") {
        return evaluate ($scope, $sym->data);
    } else {
        VP3::warning ($ident_obj->location . ": unable to evaluate `$ident'");
        return undef;
    }

}

sub eval_unsigned_number
{
    my $value = $_[1]->emit_self;

    $value =~ tr/_//d;

    # Could check against /\d+/ at this point, but that's the definition of
    # an unsigned_number in the lexer, so hopefully not necessary

    $value;
}

sub eval_based_number
{
    my $bn = $_[1];

    my $base = $bn->base;
    my $value = $bn->value;
    $value =~ tr/_//d;

    if ($base eq 'd') {
        return $value;
    } elsif ($base eq 'o') {
        return oct ($value);
    } elsif ($base eq 'h') {
        return hex ($value);
    } elsif ($base eq 'b') {
        return unpack ("V", pack ("b32", scalar (reverse ($value))));
    } else {
        VP3::error ("illegal radix " . $base . " in based_number");
    }
}

sub eval_binary_operator_expression
{
    use integer;

    my ($scope, $binop) = @_;

    my $lval = evaluate ($scope, $binop->left);
    my $rval = evaluate ($scope, $binop->right);

    defined ($lval) && defined ($rval) or return undef;

    my $op = $binop->op;

    $op eq '+' && return $lval + $rval;
    $op eq '-' && return $lval - $rval;
    $op eq '*' && return $lval * $rval;
    $op eq '/' && return $lval / $rval;

    die "Binary op $op not supported for expression evaluation";
}

1;

# vim: sts=4 sw=4 et
