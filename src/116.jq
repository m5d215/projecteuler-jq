def tilings($n; $m):
    reduce range(1; $n + 1) as $i ([1];
        . as $g
        | (if $i < $m then 1 else $g[$i - 1] + $g[$i - $m] end) as $gi
        | $g + [$gi]
    )
    | .[$n] - 1
;

50 as $N
| tilings($N; 2) + tilings($N; 3) + tilings($N; 4)
