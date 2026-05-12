def sum_proper_div($n):
    if $n <= 1 then 0
    else
        ($n | sqrt | floor) as $r
        | reduce range(2; $r + 1) as $i (1;
            if $n % $i == 0 then
                ($n / $i) as $q
                | if $q == $i then . + $i else . + $i + $q end
            else .
            end
          )
    end
;

10000 as $LIMIT
| ([range(0; $LIMIT) | 0]
   | reduce range(2; $LIMIT) as $n (.; .[$n] = sum_proper_div($n))
  ) as $d
| reduce range(2; $LIMIT) as $n (0;
    $d[$n] as $b
    | if $b > $n and $b < $LIMIT and $d[$b] == $n
      then . + $n + $b
      else .
      end
  )
