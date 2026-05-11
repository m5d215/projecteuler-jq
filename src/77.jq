def is_prime:
    . as $n
    | if $n < 2 then false
      elif $n < 4 then true
      elif $n % 2 == 0 then false
      else all(range(3; ($n | sqrt | floor) + 1; 2); $n % . != 0)
      end
;

200 as $N
| [range(2; $N + 1) | select(is_prime)] as $primes
| (
    ([range(0; $N + 1) | 0] | .[0] = 1)
    | reduce $primes[] as $p (.;
        reduce range($p; $N + 1) as $j (.;
            .[$j] += .[$j - $p]
        )
      )
  ) as $dp
| first(range(1; $N + 1) | select($dp[.] > 5000))
