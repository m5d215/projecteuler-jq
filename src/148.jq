# By Lucas's theorem, C(n, k) is not divisible by 7 iff k's base-7 digits are
# all <= the corresponding digit of n. So the count of non-divisible entries
# in row n is product over digits (d_i + 1). We sum this product for
# n = 0..N-1 with N = 10^9 via a digit DP from the most significant digit:
# for each position j with N's digit D_j, choosing a smaller digit d at j and
# anything below gives contribution
#   prefix(j) * (d * (d+1) / 2 summed) * 28^j
# where 28 = sum_{d=0..6} (d+1).

def base7_digits($n):
    if $n == 0 then []
    else [$n % 7] + base7_digits($n / 7 | floor)
    end
;

1000000000 as $N
| base7_digits($N) as $D
| ($D | length) as $m
| (reduce range(0; $m - 1) as $_ (1; . * 28)) as $start_p28
| reduce range($m - 1; -1; -1) as $j ({prefix: 1, sum: 0, p28: $start_p28};
    $D[$j] as $d
    | ($d * ($d + 1) / 2) as $tri
    | {prefix: (.prefix * ($d + 1)),
       sum: (.sum + .prefix * $tri * .p28),
       p28: (.p28 / 28)})
| .sum
