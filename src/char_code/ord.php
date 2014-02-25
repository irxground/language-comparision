<?php
$word = 'hello';
foreach (str_split($word) as $c) {
  echo $c.'('.ord($c).")\n";
}
