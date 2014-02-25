use feature say;

$word = 'hello';
say $_.'('.ord($_).')' for (split //, $word);
