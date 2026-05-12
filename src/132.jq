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

def powmod($base; $e; $n):
    if $n <= 1 then 0
    else
        {b: ($base % $n), e: $e, r: 1}
        | until(.e == 0;
            (if .e % 2 == 1 then (.r * .b) % $n else .r end) as $nr
            | {b: ((.b * .b) % $n), e: (.e / 2 | floor), r: $nr}
          )
        | .r
    end
;

200000 as $LIMIT
| 1000000000 as $K
| (primes_up_to($LIMIT)) as $primes
| [
    $primes[]
    | select(. > 5)
    | select(powmod(10; $K; .) == 1)
  ]
| .[:40]
| add
