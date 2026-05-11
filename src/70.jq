def is_prime_table($max):
    reduce range(2; $max + 1) as $i ([range(0; $max + 1) | true];
        if .[$i] then
            reduce range($i * $i; $max + 1; $i) as $m (.; .[$m] = false)
        else . end
    )
    | .[0] = false | .[1] = false
;

def digits_sorted: tostring | explode | sort;

10000000 as $LIMIT
| 6500 as $PMAX
| is_prime_table($PMAX) as $sieve
| [range(2; $PMAX + 1) | select($sieve[.])] as $primes
| ($primes | length) as $NP
| [
    range(0; $NP) as $i
    | $primes[$i] as $p
    | range($i; $NP) as $j
    | $primes[$j] as $q
    | ($p * $q) as $n
    | select($n < $LIMIT)
    | (($p - 1) * ($q - 1)) as $phi
    | select(($n | digits_sorted) == ($phi | digits_sorted))
    | {n: $n, ratio: ($n / $phi)}
  ]
| min_by(.ratio) | .n
