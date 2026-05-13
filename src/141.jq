# Progressive (q, d, r) with r < d < q and d^2 = q r parametrizes as
#   q = g u^2, d = g u v, r = g v^2 with u > v >= 1, gcd(u, v) = 1.
# Hence n = q d + r = g v (g u^3 + v). Enumerate (u, v, g) and collect n
# whose value is a perfect square below 10^12.

def gcd($x; $y):
    if $y == 0 then $x else gcd($y; $x % $y) end
;

def is_square($x):
    ($x | sqrt | floor) as $s
    | $s * $s == $x or ($s + 1) * ($s + 1) == $x
;

1000000000000 as $N
| [
    range(2; 10000) as $u
    | ($u * $u * $u) as $u3
    | range(1; $u) as $v
    | select(gcd($u; $v) == 1)
    | ((($N / ($u3 * $v)) | sqrt | floor) + 1) as $g_max
    | range(1; $g_max + 1) as $g
    | ($g * $v * ($g * $u3 + $v)) as $n
    | select($n < $N and is_square($n))
    | $n
  ]
| unique
| add
