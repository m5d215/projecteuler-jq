50 as $N
| reduce range(1; $N + 1) as $i ([1];
    . as $f
    | (reduce range(1; 5) as $j (0;
        if $i - $j < 0 then . else . + $f[$i - $j] end
      )) as $fi
    | $f + [$fi]
  )
| .[$N]
