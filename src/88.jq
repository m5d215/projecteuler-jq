def fact_gen($N; $start; $prod; $sum; $count):
    range($start; ($N / $prod | floor) + 1) as $f
    | ($prod * $f) as $p
    | ($sum + $f) as $s
    | ($count + 1) as $c
    | (if $c >= 2 then [$p, $s, $c] else empty end),
      fact_gen($N; $f; $p; $s; $c)
;

12000 as $K
| ($K * 2) as $LIMIT
| reduce fact_gen($LIMIT; 2; 1; 0; 0) as [$p, $s, $c] (
    [range(0; $K + 1) | null];
    ($p - $s + $c) as $k
    | if $k >= 2 and $k <= $K and (.[$k] == null or $p < .[$k])
      then .[$k] = $p else . end
  )
| .[2:] | unique | add
