use feature say;

%values = (foo => 1, bar => 2, baz => 3);
while (my ($k, $v) = each(%values)) {
  say "$k: $v";
}
say '----';
say "$_: $values{$_}" for keys(%values);
