def binom($n; $k):
    if $k < 0 or $k > $n then 0
    else
        (reduce range(0; $k) as $i (1; . * ($n - $i))) as $num
        | (reduce range(1; $k + 1) as $i (1; . * $i)) as $den
        | $num / $den
    end
;

12 as $N
| reduce range(2; ($N / 2 | floor) + 1) as $k (0;
    . + binom($N; 2 * $k) * binom(2 * $k; $k) * ($k - 1) / (2 * ($k + 1))
  )
