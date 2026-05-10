def is_prime_table($max):
    reduce range(2; $max + 1) as $i ([range(0; $max + 1) | true];
        if .[$i] then
            reduce range($i * $i; $max + 1; $i) as $m (.; .[$m] = false)
        else . end
    )
    | .[0] = false | .[1] = false
;

def rotations:
    tostring as $s
    | ($s | length) as $n
    | [range(0; $n) | ($s[.:] + $s[:.] | tonumber)]
;

1000000 as $MAX
| is_prime_table($MAX) as $is_p
| [
    range(2; $MAX) | select($is_p[.])
    | select(all(rotations[]; $is_p[.]))
  ] | length
