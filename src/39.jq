[
    range(3; 1001) as $p
    | {
        p: $p,
        count: ([
            range(1; $p / 3 + 1 | floor) as $a
            | range($a; ($p - $a) / 2 + 1 | floor) as $b
            | ($p - $a - $b) as $c
            | select($a * $a + $b * $b == $c * $c)
        ] | length)
      }
] | max_by(.count) | .p
