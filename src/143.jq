# Torricelli/Fermat distances p, q, r satisfy p^2 + pq + q^2 = c^2 etc. Find all
# (p, q, r) with p + q + r <= 120000 such that each pair forms a 120-degree
# integer triangle, and sum distinct p + q + r.
#
# Primitive 120-degree pairs (a, b, c) parametrise as
#   a = m^2 - n^2, b = 2 m n + n^2, c = m^2 + m n + n^2
# with m > n >= 1, gcd(m, n) = 1, m !\equiv n (mod 3). Scale by k. For each p
# walk pairs of upper neighbours (q < r) and verify q^2 + qr + r^2 is square.

def gcd($x; $y):
    if $y == 0 then $x else gcd($y; $x % $y) end
;

def is_square($x):
    ($x | sqrt | floor) as $s
    | $s * $s == $x or ($s + 1) * ($s + 1) == $x
;

120000 as $MAX
| ([
    range(2; 400) as $m
    | range(1; $m) as $n
    | select(gcd($m; $n) == 1 and (($m - $n) % 3 != 0))
    | ($m * $m - $n * $n) as $u
    | (2 * $m * $n + $n * $n) as $v
    | (if $u < $v then [$u, $v] else [$v, $u] end) as $ps
    | range(1; ($MAX / $ps[1] | floor) + 1) as $k
    | [$k * $ps[0], $k * $ps[1]]
  ] | unique) as $edges
| ($edges | group_by(.[0])) as $grouped
| [
    $grouped[] as $grp
    | ($grp[0][0]) as $p
    | ([$grp[] | .[1]] | sort) as $qs
    | ($qs | length) as $L
    | range(0; $L) as $i
    | range($i + 1; $L) as $j
    | $qs[$i] as $q
    | $qs[$j] as $r
    | select($p + $q + $r <= $MAX)
    | select(is_square($q * $q + $q * $r + $r * $r))
    | $p + $q + $r
  ]
| unique
| add
