def A_n($n):
    {k: 1, r: 1}
    | until(.r == 0;
        {k: (.k + 1), r: ((.r * 10 + 1) % $n)}
      )
    | .k
;

def is_prime($n):
    if $n < 2 then false
    elif $n < 4 then true
    elif $n % 2 == 0 or $n % 3 == 0 then false
    else
        ($n | sqrt | floor) as $sq
        | all(range(5; $sq + 1; 6);
            $n % . != 0 and $n % (. + 2) != 0
          )
    end
;

reduce range(7; 100000) as $n ({count: 0, sum: 0};
    if .count >= 25 then .
    elif $n % 2 == 0 or $n % 5 == 0 then .
    elif is_prime($n) then .
    elif ($n - 1) % A_n($n) == 0 then {count: (.count + 1), sum: (.sum + $n)}
    else .
    end
  )
| .sum
