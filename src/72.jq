def totient_table($max):
    [range(0; $max + 1)]
    | reduce range(2; $max + 1) as $i (.;
        if .[$i] == $i then
            reduce range($i; $max + 1; $i) as $m (.;
                .[$m] = .[$m] - .[$m] / $i
            )
        else . end
    )
;

1000000 as $LIMIT
| totient_table($LIMIT) as $phi
| reduce range(2; $LIMIT + 1) as $i (0; . + $phi[$i])
