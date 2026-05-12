def coeffs:
    reduce range(1; 16) as $k ([1, 0, 0, 0, 0, 0, 0, 0];
        . as $p
        | [range(0; 8)
           | if . == 0 then $p[0]
             else $p[.] + $k * $p[. - 1]
             end]
    )
;

coeffs as $c
| ($c | add) as $N
| (reduce range(2; 17) as $i (1; . * $i)) as $D
| ($D / $N | floor)
