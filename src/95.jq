1000000 as $N

# Sieve of proper-divisor sums: dsum[m] = sum of d where d < m and d | m.
| (reduce range(1; ($N / 2 | floor) + 1) as $d ([range(0; $N + 1) | 0];
     reduce range(2 * $d; $N + 1; $d) as $m (.; .[$m] += $d)
   )) as $dsum

| def walk_chain($n):
    {n: $n, step: 0, result: null}
    | until(.result != null or .step > 100;
        if .step > 0 and .n == $n then .result = .step
        elif .n > $N or .n <= 1 then .result = 0
        else {n: $dsum[.n], step: (.step + 1), result: null}
        end
      )
    | .result // 0
;

  reduce range(2; $N + 1) as $n ({max_len: 0, min_member: 0};
    walk_chain($n) as $len
    | if $len > .max_len then {max_len: $len, min_member: $n}
      elif $len == .max_len and $n < .min_member then .min_member = $n
      else . end
  )
| .min_member
