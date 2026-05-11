def gcd($a; $b):
    if $b == 0 then $a else gcd($b; $a % $b) end
;

1500000 as $LIMIT
| ($LIMIT | sqrt | floor) as $MMAX
| reduce (
    range(2; $MMAX + 1) as $m
    | range(1; $m) as $n
    | select(($m - $n) % 2 == 1 and gcd($m; $n) == 1)
    | (2 * $m * ($m + $n)) as $Lp
    | select($Lp <= $LIMIT)
    | range($Lp; $LIMIT + 1; $Lp)
  ) as $L (
    [range(0; $LIMIT + 1) | 0];
    .[$L] += 1
  )
| [.[] | select(. == 1)] | length
