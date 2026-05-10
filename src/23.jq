def proper_divisor_sum:
    . as $n
    | if $n <= 1 then 0
      else
        reduce range(2; ($n | sqrt | floor) + 1) as $d (1;
            if $n % $d == 0 then
                ($n / $d) as $q
                | if $d == $q then . + $d else . + $d + $q end
            else . end
        )
      end
;

28123 as $LIMIT
| [range(0; $LIMIT + 1) | proper_divisor_sum > .] as $is_ab
| reduce range(1; $LIMIT + 1) as $n (0;
    if any(range(12; ($n / 2 | floor) + 1); $is_ab[.] and $is_ab[$n - .]) then .
    else . + $n end
  )
