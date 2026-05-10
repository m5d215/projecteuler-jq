def is_prime_table($max):
    reduce range(2; $max + 1) as $i ([range(0; $max + 1) | true];
        if .[$i] then
            reduce range($i * $i; $max + 1; $i) as $m (.; .[$m] = false)
        else . end
    )
    | .[0] = false | .[1] = false
;

def consec($is_p; $a; $b; $max):
    {n: 0}
    | until(
        (.n * .n + $a * .n + $b) as $v
        | $v < 0 or $v > $max or ($is_p[$v] | not);
        .n += 1
      )
    | .n
;

90000 as $MAX
| is_prime_table($MAX) as $is_p
| [range(2; 1001) | select($is_p[.])] as $bs
| [
    range(-999; 1000) as $a
    | $bs[] as $b
    | [$a, $b, consec($is_p; $a; $b; $MAX)]
  ]
| max_by(.[2])
| .[0] * .[1]
