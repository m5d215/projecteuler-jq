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

def inv($x; $p):
    powmod($x; $p - 2; $p)
;

def num_digits($n):
    if $n < 10 then 1
    elif $n < 100 then 2
    elif $n < 1000 then 3
    elif $n < 10000 then 4
    elif $n < 100000 then 5
    elif $n < 1000000 then 6
    else 7
    end
;

1000020 as $LIMIT
| (primes_up_to($LIMIT)) as $primes
| ($primes | length) as $N
| reduce range(0; $N - 1) as $i ({lo: 0, hi: 0};
    $primes[$i] as $p1
    | $primes[$i + 1] as $p2
    | if $p1 < 5 or $p1 > 1000000 then .
      else
          num_digits($p1) as $L
          | (reduce range(0; $L) as $_ (1; . * 10)) as $tenL
          | (inv($tenL; $p2)) as $iv
          | ((($p2 - $p1) * $iv) % $p2) as $k
          | ($p1 + $k * $tenL) as $s
          | (.lo + $s) as $newlo
          | if $newlo >= 1000000000
            then {lo: ($newlo % 1000000000), hi: (.hi + ($newlo / 1000000000 | floor))}
            else {lo: $newlo, hi: .hi}
            end
      end
  )
| (.hi | tostring) + ((.lo + 1000000000) | tostring | .[1:])

