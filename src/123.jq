def primes_up_to($N):
    [range(0; $N + 1) | true]
    | .[0] = false | .[1] = false
    | reduce range(2; ($N | sqrt | floor) + 1) as $p (.;
        if .[$p] then
            reduce range($p * $p; $N + 1; $p) as $m (.; .[$m] = false)
        else . end
      )
    | . as $sv
    | [range(2; $N + 1) | select($sv[.])]
;

350000 as $LIMIT
| 10000000000 as $T
| primes_up_to($LIMIT) as $primes
| first(
    range(0; $primes | length) as $i
    | ($i + 1) as $n
    | $primes[$i] as $p
    | (if $n % 2 == 0 then 2 else (2 * $n * $p) % ($p * $p) end) as $r
    | select($r > $T)
    | $n
)
