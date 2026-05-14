# For N in [5, 10000], let M(N) = max over integer k of (N/k)^k. The k that
# achieves the max is round(N / e). Whether M(N) has a terminating decimal
# rep depends only on the reduced denominator (k/gcd(N, k))^k -- terminating
# iff k/gcd(N, k) is only made of factors 2 and 5. Sum +N when not
# terminating and -N when terminating.

def gcd_iter($a; $b):
    [$a, $b] | until(.[1] == 0; [.[1], (.[0] % .[1])]) | .[0]
;

def strip25:
    until(. % 2 != 0; . / 2 | floor)
    | until(. % 5 != 0; . / 5 | floor)
;

2.718281828459045 as $e
| reduce range(5; 10001) as $N (0;
    ($N / $e + 0.5 | floor) as $k
    | gcd_iter($N; $k) as $g
    | ($k / $g | floor) as $kp
    | ($kp | strip25) as $s
    | if $s == 1 then . - $N else . + $N end
)
