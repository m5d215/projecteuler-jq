[1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880] as $F

| def dss_fact:
    {n: ., sum: 0}
    | until(.n == 0; {n: (.n / 10 | floor), sum: (.sum + $F[.n % 10])})
    | .sum
;

# Fixed points and members of the only non-trivial cycles of dss_fact:
# 169 -> 363601 -> 1454 -> 169, 871 <-> 45361, 872 <-> 45362.
  def cycle_len:
    if . == 1 or . == 2 or . == 145 or . == 40585 then 1
    elif . == 871 or . == 45361 or . == 872 or . == 45362 then 2
    elif . == 169 or . == 363601 or . == 1454 then 3
    else null
    end
;

  def chain_len:
    memoize(
        cycle_len as $c
        | if $c != null then $c
          else (dss_fact | chain_len) + 1
          end
    )
;

  reduce range(1; 1000000) as $n (0;
    if ($n | chain_len) == 60 then . + 1 else . end
  )
