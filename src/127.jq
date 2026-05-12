def gcd($a; $b):
    if $b == 0 then $a else gcd($b; $a % $b) end
;

120000 as $N
| ([range(0; $N + 1) | 1]
   | reduce range(2; $N + 1) as $p (.;
       if .[$p] == 1 then
           reduce range($p; $N + 1; $p) as $m (.; .[$m] = .[$m] * $p)
       else . end
     )) as $rad
| reduce range(3; $N) as $c (0;
    $rad[$c] as $rc
    | ($c / $rc) as $thresh
    | if $thresh <= 1 then .
      else
          . + (reduce range(1; ($c / 2 | floor) + 1) as $a (0;
              . as $s
              | $rad[$a] as $ra
              | if $ra >= $thresh then $s
                else
                    ($c - $a) as $b
                    | $rad[$b] as $rb
                    | if $ra * $rb * $rc < $c and gcd($a; $b) == 1
                      then $s + $c else $s end
                end
          ))
      end
  )
