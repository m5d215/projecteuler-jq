def u($n):
    reduce range(0; 11) as $i ({p: 1, s: 0};
        .p as $p
        | {p: ($p * $n),
           s: (if $i % 2 == 0 then .s + $p else .s - $p end)}
    )
    | .s
;

def binom($n; $k):
    (reduce range(0; $k) as $i (1; . * ($n - $i))) as $num
    | (reduce range(1; $k + 1) as $i (1; . * $i)) as $den
    | $num / $den
;

def fit($k; $u):
    reduce range(0; $k) as $j (0;
        . + (if ($k - 1 - $j) % 2 == 0 then 1 else -1 end)
            * binom($k; $j) * $u[$j]
    )
;

[range(1; 11) | u(.)] as $u
| reduce range(1; 11) as $k (0; . + fit($k; $u))
