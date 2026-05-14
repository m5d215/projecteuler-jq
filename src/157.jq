# Sum over n=1..9 of # of (a, b, p) with 0 < a <= b and 1/a + 1/b = p/10^n.
#
# Substitute a = d*x, b = d*y with gcd(x, y) = 1. Then (x+y)/(d*x*y) = p/10^n.
# Coprimality forces gcd(xy, x+y) = 1, hence x*y | 10^n: x and y are coprime
# 10-smooth divisors of 10^n. So (x, y) is either {1, 2^a * 5^b} or
# {2^a, 5^b} with a, b >= 1.
#
# For each ordered (x, y) with x <= y satisfying these, q = 10^n*(x+y)/(x*y)
# is an integer, and (d, p) ranges over pairs with d*p = q, contributing tau(q)
# solutions.

def tau($n):
    reduce range(1; ($n | sqrt | floor) + 1) as $i (0;
        if $n % $i == 0 then
            (if $i * $i == $n then . + 1 else . + 2 end)
        else .
        end
    )
;

def pow_int($b; $e):
    reduce range(0; $e) as $_ (1; . * $b)
;

def count_per_n($n):
    pow_int(10; $n) as $pn
    | [ range(0; $n + 1) as $ax | range(0; $n + 1) as $bx
        | (pow_int(2; $ax) * pow_int(5; $bx)) as $x
        | range(0; $n + 1) as $ay | range(0; $n + 1) as $by
        | (pow_int(2; $ay) * pow_int(5; $by)) as $y
        | select($y >= $x)
        | select((($ax > 0 and $ay > 0) or ($bx > 0 and $by > 0)) | not)
        | ($x * $y) as $xy
        | select($xy <= $pn and $pn % $xy == 0)
        | ($pn * ($x + $y) / $xy | floor) as $q
        | tau($q)
      ] | add // 0
;

reduce range(1; 10) as $n (0; . + count_per_n($n))
