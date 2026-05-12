def primes_sieve($N):
    [range(0; $N + 1) | true]
    | .[0] = false | .[1] = false
    | reduce range(2; ($N | sqrt | floor) + 1) as $p (.;
        if .[$p] then
            reduce range($p * $p; $N + 1; $p) as $m (.; .[$m] = false)
        else . end
      )
;

1500000 as $LIMIT
| primes_sieve($LIMIT) as $is_prime
| [1, 2,
   (range(2; 200000) as $k
   | (
       (if $is_prime[6 * $k - 1] and $is_prime[6 * $k + 1] and $is_prime[12 * $k + 5]
        then 3 * $k * $k - 3 * $k + 2 else empty end),
       (if $is_prime[6 * $k - 1] and $is_prime[6 * $k + 5] and $is_prime[12 * $k - 7]
        then 3 * $k * $k + 3 * $k + 1 else empty end)
     ))
  ]
| .[1999]
