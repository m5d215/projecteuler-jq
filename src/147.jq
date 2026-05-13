# For an m x n cross-hatched grid, axis-aligned rectangles count is
#   m n (m+1) (n+1) / 4 (choose two of each axis's grid lines).
# Diagonal rectangles map to axis-aligned rectangles in the rotated coordinates
# u = x + y, v = x - y, where the (/) and (\) lines have integer u, v. The four
# vertices must satisfy 0 <= x <= m and 0 <= y <= n; with side lengths alpha, beta
# in the (u, v) plane this gives
#   r = u1 + v1 in [0, 2m - alpha - beta]
#   s = u1 - v1 in [beta, 2n - alpha]
# with r, s same parity (so the corner is an integer (u1, v1)). The same-parity
# pair count is (N_t * N_s + (-1)^alpha * (N_t mod 2)(N_s mod 2)) / 2 where
# N_t = 2m - alpha - beta + 1, N_s = 2n - alpha - beta + 1.

def axis($m; $n):
    $m * $n * ($m + 1) * ($n + 1) / 4
;

def diag($m; $n):
    (if $m < $n then $m else $n end) as $mn
    | reduce range(1; 2 * $mn) as $alpha (0;
        . as $acc
        | reduce range(1; 2 * $mn - $alpha + 1) as $beta ($acc;
            (2 * $m - $alpha - $beta + 1) as $Nt
            | (2 * $n - $alpha - $beta + 1) as $Ns
            | (($Nt % 2) * ($Ns % 2)) as $par
            | (if $alpha % 2 == 1 then -$par else $par end) as $sign
            | . + ($Nt * $Ns + $sign) / 2))
;

[range(1; 48) as $m
 | range(1; 44) as $n
 | axis($m; $n) + diag($m; $n)]
| add
