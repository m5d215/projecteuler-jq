20000 as $MAX
| [
    range(1; 100) as $a
    | range($a; 200) as $b
    | (($MAX / 2 - $a * $b) / ($a + $b) | floor) as $c_max
    | range($b; $c_max + 1) as $c
    | (2 * ($a * $b + $b * $c + $c * $a)) as $base
    | select($base < $MAX)
    | ($a + $b + $c) as $s
    | range(1; 100) as $n
    | ($base + 4 * $s * ($n - 1) + 4 * ($n - 1) * ($n - 2)) as $layer
    | select($layer < $MAX)
    | $layer
  ]
| sort
| . + [-1]
| reduce .[] as $L ({prev: null, count: 0, result: null};
    if .result != null then .
    elif .prev == null then {prev: $L, count: 1, result: null}
    elif $L == .prev then {prev: .prev, count: (.count + 1), result: null}
    else
        (if .count == 1000 then .prev else null end) as $r
        | {prev: $L, count: 1, result: $r}
    end
  )
| .result
