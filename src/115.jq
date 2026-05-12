50 as $M
| 1000000 as $T
| {f: [1], n: 0}
| until(.f[.n] > $T;
    (.n + 1) as $nn
    | .f as $arr
    | (reduce range($M; $nn) as $k (0; . + $arr[$nn - $k - 1])) as $sum
    | (if $nn < $M then 1 else $arr[$nn - 1] + 1 + $sum end) as $fn
    | {f: ($arr + [$fn]), n: $nn}
  )
| .n
