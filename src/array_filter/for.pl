require 'utils/util.pm';

@nums = (1, 2, 3, 4, 5);
foreach $n (@nums) {
  push @odds, $n if $n % 2 != 0;
}
print_array(@odds);
