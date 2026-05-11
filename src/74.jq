[1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880] as $F

| def dss_fact:
    {n: ., sum: 0}
    | until(.n == 0; {n: (.n / 10 | floor), sum: (.sum + $F[.n % 10])})
    | .sum
;

  def chain_len($start):
    {visited: [$start], cur: ($start | dss_fact)}
    | until(.cur as $c | (.visited | index($c)) != null;
        .cur as $c
        | .visited as $vs
        | {visited: ($vs + [$c]), cur: ($c | dss_fact)}
      )
    | .visited | length
;

  reduce range(1; 1000000) as $n (0;
    if chain_len($n) == 60 then . + 1 else . end
  )
