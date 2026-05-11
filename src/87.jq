50000000 as $N
| ($N | sqrt | floor) as $LP
| (
    [range(0; $LP + 1) | true]
    | .[0] = false | .[1] = false
    | reduce range(2; ($LP | sqrt | floor) + 1) as $p (.;
        if .[$p] then
            reduce range($p * $p; $LP + 1; $p) as $m (.; .[$m] = false)
        else . end
      )
    | . as $sv
    | [range(2; $LP + 1) | select($sv[.])]
  ) as $primes
| [$primes[] | select(. * . * . <= $N)] as $qP
| [$primes[] | select(. * . * . * . <= $N)] as $rP
| [$primes[] as $p
   | $qP[] as $q
   | $rP[] as $r
   | ($p * $p + $q * $q * $q + $r * $r * $r * $r)
   | select(. < $N)
  ]
| unique | length
