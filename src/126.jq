20000 as $MAX
| [range(0; $MAX) | 0]
| reduce range(1; 100) as $a (.;
    reduce range($a; 200) as $b (.;
        (($MAX / 2 - $a * $b) / ($a + $b) | floor) as $c_max
        | reduce range($b; $c_max + 1) as $c (.;
            (2 * ($a * $b + $b * $c + $c * $a)) as $base
            | ($a + $b + $c) as $s
            | reduce range(1; 100) as $n (.;
                ($base + 4 * $s * ($n - 1) + 4 * ($n - 1) * ($n - 2)) as $layer
                | if $layer < $MAX then .[$layer] += 1 else . end
              )
          )
      )
  )
| . as $count
| first(range(1; $MAX) | select($count[.] == 1000))
