sub print_array {
  print "[".join(', ', @_)."]\n"
}

@array = (1, 2, 3, 4, 5);
print_array @array[2..3];
print_array @array[1, 3, 4];
print_array @array;
