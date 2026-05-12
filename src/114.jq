50 as $N
| reduce range(1; $N + 1) as $n ([1];
    . as $f
    | (if $n < 3 then 1
       else $f[$n - 1] + 1
            + (reduce range(3; $n) as $k (0; . + $f[$n - $k - 1]))
       end) as $fn
    | $f + [$fn]
  )
| .[$N]
