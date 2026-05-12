def binom($n; $k):
    if $k > $n or $k < 0 then 0
    else
        reduce range(0; $k) as $j (1; . * ($n - $k + 1 + $j) / ($j + 1))
    end
;

100 as $N
| reduce range(1; $N + 1) as $k (0;
    . + binom($k + 8; $k) + binom($k + 9; $k) - 10
  )
