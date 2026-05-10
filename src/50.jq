def is_prime_table($max):
    reduce range(2; $max + 1) as $i ([range(0; $max + 1) | true];
        if .[$i] then
            reduce range($i * $i; $max + 1; $i) as $m (.; .[$m] = false)
        else . end
    )
    | .[0] = false | .[1] = false
;

1000000 as $MAX
| is_prime_table($MAX) as $is_p
| [range(2; $MAX) | select($is_p[.])] as $primes
| ($primes | length) as $P
| ([0] + [foreach $primes[] as $x (0; . + $x; .)]) as $prefix
| (last(range(1; $P + 1) | select($prefix[.] < $MAX))) as $Lmax
| first(
    range($Lmax; 1; -1) as $L
    | range(0; $P - $L + 1) as $i
    | ($prefix[$i + $L] - $prefix[$i]) as $s
    | select($s < $MAX and $is_p[$s])
    | $s
  )
