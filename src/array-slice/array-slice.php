<?php
function print_array($arg) {
  print "[".implode(', ', $arg)."]\n";
}

$array = array(1, 2, 3, 4, 5);
print_array(array_slice($array, 2, 2));
print_array($array);
