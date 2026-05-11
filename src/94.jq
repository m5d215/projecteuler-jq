1000000000 as $LIMIT
| {X: 4, Y: 2, sum: 0, done: false}
| until(.done;
    .X as $X | .Y as $Y
    | ($X % 3) as $m
    | (if $m == 2 then $X + 2
       elif $m == 1 then $X - 2
       else 0 end) as $P
    | if $P > $LIMIT then .done = true
      else
        (if $P > 4 then .sum + $P else .sum end) as $newSum
        | (2 * $X + 3 * $Y) as $newX
        | ($X + 2 * $Y) as $newY
        | {X: $newX, Y: $newY, sum: $newSum, done: false}
      end
  )
| .sum
