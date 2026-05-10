def factor_count_table($max):
    reduce range(2; $max + 1) as $p ([range(0; $max + 1) | 0];
        if .[$p] == 0 then
            reduce range($p; $max + 1; $p) as $m (.; .[$m] += 1)
        else . end
    )
;

200000 as $MAX
| factor_count_table($MAX) as $cnt
| first(
    range(2; $MAX - 3) as $n
    | select(
        $cnt[$n] == 4
        and $cnt[$n + 1] == 4
        and $cnt[$n + 2] == 4
        and $cnt[$n + 3] == 4
      )
    | $n
)
