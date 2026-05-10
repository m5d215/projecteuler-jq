def comb($n; $r):
    ([$r, $n - $r] | min) as $k
    | reduce range(0; $k) as $i (1; . * ($n - $i) / ($i + 1))
;

[range(1; 101) as $n
 | range(0; $n + 1) as $r
 | select(comb($n; $r) > 1000000)
] | length
