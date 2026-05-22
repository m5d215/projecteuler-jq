1000000 as $N
| [range(0; $N) | 0]
| reduce range(1; 1733) as $u (.;
    ($u % 4) as $r
    | (if $r == 0 then 4
       elif $r == 1 then 3
       elif $r == 2 then 2
       else 1
       end) as $v_first_mod
    | (($u + 6) / 3 | floor) as $v_min_constr
    | (($N - 1) / $u | floor) as $v_max
    | reduce range($v_first_mod; $v_max + 1; 4) as $v (.;
        if $v >= $v_min_constr then .[$u * $v] += 1 else . end
      )
  )
| [.[] | select(. == 10)] | length
