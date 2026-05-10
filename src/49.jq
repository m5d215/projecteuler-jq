def is_prime_table($max):
    reduce range(2; $max + 1) as $i ([range(0; $max + 1) | true];
        if .[$i] then
            reduce range($i * $i; $max + 1; $i) as $m (.; .[$m] = false)
        else . end
    )
    | .[0] = false | .[1] = false
;

10000 as $MAX
| is_prime_table($MAX) as $is_p
| [range(1000; 10000) | select($is_p[.])] as $primes
| ($primes | group_by(tostring | explode | sort))
| map(select(length >= 3))
| [
    .[] as $g
    | ($g | length) as $L
    | range(0; $L) as $i
    | range($i + 1; $L) as $j
    | range($j + 1; $L) as $k
    | $g[$i] as $a | $g[$j] as $b | $g[$k] as $c
    | select($b - $a == $c - $b)
    | select($a != 1487)
    | "\($a)\($b)\($c)" | tonumber
  ] | .[0]
