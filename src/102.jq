def contains_origin($a; $b; $c):
    ($a[0] * $b[1] - $a[1] * $b[0]) as $d1
    | ($b[0] * $c[1] - $b[1] * $c[0]) as $d2
    | ($c[0] * $a[1] - $c[1] * $a[0]) as $d3
    | ($d1 > 0 and $d2 > 0 and $d3 > 0)
      or ($d1 < 0 and $d2 < 0 and $d3 < 0)
;

[inputs
 | split(",") | map(tonumber) as $v
 | select(contains_origin([$v[0], $v[1]]; [$v[2], $v[3]]; [$v[4], $v[5]]))
]
| length
