def partitions($n; $max_part):
    ([range(0; $n + 1) | 0] | .[0] = 1)
    | reduce range(1; $max_part + 1) as $k (.;
        reduce range($k; $n + 1) as $j (.;
            .[$j] += .[$j - $k]
        )
      )
    | .[$n]
;

partitions(100; 99)
