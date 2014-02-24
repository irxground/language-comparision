<?php
require('utils/util.php');

$nums = array(1, 2, 3, 4, 5);
$odds = array_filter($nums, function($x) { return $x % 2 != 0; });
print_array($odds);
