1000000 as $N
| [
    range(1; 1733) as $u
    | ($u % 4) as $r
    | (if $r == 0 then 4
       elif $r == 1 then 3
       elif $r == 2 then 2
       else 1
       end) as $v_first_mod
    | (($u + 6) / 3 | floor) as $v_min_constr
    | (($N - 1) / $u | floor) as $v_max
    | range($v_first_mod; $v_max + 1; 4) as $v
    | select($v >= $v_min_constr)
    | $u * $v
  ]
| sort
| . + [-1]
| reduce .[] as $n ({prev: -1, count: 0, total: 0};
    if $n == .prev then .count += 1
    else
        (if .count == 10 then .total + 1 else .total end) as $new_total
        | {prev: $n, count: 1, total: $new_total}
    end
  )
| .total
