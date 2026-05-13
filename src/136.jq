def primes_up_to($N):
    [range(0; $N + 1) | true]
    | .[0] = false | .[1] = false
    | reduce range(2; ($N | sqrt | floor) + 1) as $p (.;
        if .[$p] then
            reduce range($p * $p; $N + 1; $p) as $m (.; .[$m] = false)
        else . end)
    | . as $sv
    | [range(2; $N + 1) | select($sv[.])]
;

50000000 as $N
| ($N / 4 | floor) as $N4
| ($N / 16 | floor) as $N16
| ($N | sqrt | floor) as $S
| primes_up_to($S) as $bp
| 1000000 as $SEG
| reduce range(0; $N; $SEG) as $L (
    {pe1: 0, pe2: 0, pe3: 0};
    . as $acc
    | (if $L + $SEG > $N then $N else $L + $SEG end) as $R
    | ($R - $L) as $len
    | ([range(0; $len) | true]
       | if $L == 0 then .[0] = false | .[1] = false else . end
       | reduce $bp[] as $p (.;
           ($p * $p) as $psq
           | ((($L + $p - 1) / $p | floor) * $p) as $ceil
           | (if $psq > $ceil then $psq else $ceil end) as $start
           | reduce range($start; $R; $p) as $m (.; .[$m - $L] = false))
      ) as $seg
    | reduce range(0; $len) as $i ($acc;
        if $seg[$i] then
            ($L + $i) as $p
            | (if $p % 4 == 3 then .pe1 += 1 else . end)
            | (if $p >= 3 and $p < $N4 then .pe2 += 1 else . end)
            | (if $p >= 3 and $p < $N16 then .pe3 += 1 else . end)
        else . end)
  )
| .pe1 + .pe2 + .pe3 + 2
