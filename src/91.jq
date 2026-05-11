50 as $N
| [range(0; $N + 1) as $x | range(0; $N + 1) as $y | [$x, $y]] as $points
| ($points | length) as $K
| reduce range(0; $K) as $i (0;
    $points[$i] as $P
    | if $P == [0, 0] then . else
        reduce range(0; $K) as $j (.;
            $points[$j] as $Q
            | if $Q == [0, 0] or $i == $j then . else
                ($P[0] * $Q[0] + $P[1] * $Q[1]) as $PQ
                | ($P[0] * $P[0] + $P[1] * $P[1]) as $PP
                | ($Q[0] * $Q[0] + $Q[1] * $Q[1]) as $QQ
                | if $PQ == 0 or $PP == $PQ or $QQ == $PQ then . + 1 else . end
              end
        )
      end
  )
| . / 2
