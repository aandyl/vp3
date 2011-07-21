@perl_begin
sub mux {
    my $input = $_[0];
    my @args = split (/\s+/, $input);
    vprint "assign $args[3] = $args[2] ? $args[1] : $args[0];\n";
}
@perl_end
