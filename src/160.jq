# Last 5 non-zero digits of N! where N = 10^12.
#
# Strip trailing zeros: result = N! / 10^{v_5(N!)} mod 10^5. Use CRT on
# mod 5^5 = 3125 and mod 2^5 = 32. Since v_2(N!) - v_5(N!) >> 5 for our N,
# result ≡ 0 mod 32.
#
# Mod 5^5: write g(N) = N!/5^{v_5(N!)} mod 5^5, then
# result mod 3125 = g(N) * inv(2^{v_5(N!)}, 3125) mod 3125.
#
# g satisfies g(n) = g(floor(n/5)) * h(n) mod 3125 where
# h(n) = prod_{i<=n, 5 nmid i} i mod 3125. By the Wilson analogue for
# p^k (p odd), h_full = h(5^5) ≡ -1 mod 5^5, so h(n) = (-1)^{n/5^5} * h(n mod 5^5).

def pow_mod($a; $e; $m):
    [1, ($a % $m), $e]
    | until(.[2] == 0;
        if .[2] % 2 == 1 then
            [(.[0] * .[1]) % $m, (.[1] * .[1]) % $m, (.[2] / 2 | floor)]
        else
            [.[0], (.[1] * .[1]) % $m, (.[2] / 2 | floor)]
        end
    )
    | .[0]
;

def h_partial($r):
    reduce range(1; $r + 1) as $i (1;
        if $i % 5 == 0 then . else (. * $i) % 3125 end
    )
;

def h_full($n):
    ($n / 3125 | floor) as $q
    | ($n % 3125) as $r
    | h_partial($r) as $hr
    | if $q % 2 == 1 then (3125 - $hr) % 3125 else $hr end
;

1000000000000 as $N
| (reduce range(0; 60) as $_ ({cur: $N, v: 0};
    if .cur == 0 then .
    else
        (.cur / 5 | floor) as $next
        | {cur: $next, v: (.v + $next)}
    end
  )) | .v as $v5

| (reduce range(0; 60) as $_ ({cur: $N, g: 1};
    if .cur == 0 then .
    else
        ((.g * h_full(.cur)) % 3125) as $ng
        | (.cur / 5 | floor) as $next
        | {cur: $next, g: $ng}
    end
  )) | .g as $g

| ($v5 % 2500) as $v5m
| pow_mod(2; ((2500 - $v5m) % 2500); 3125) as $inv_two_v5
| (($g * $inv_two_v5) % 3125) as $R
| ((((0 - $R * 29) % 32) + 32) % 32) as $t
| ($R + 3125 * $t)
