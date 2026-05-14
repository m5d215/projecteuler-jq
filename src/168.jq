# Last 5 digits of sum over n in [10, 10^100) with n having the property
# that right-rotating its decimal digits yields a positive integer multiple
# of n.
#
# If n has k digits ending in l, rotating gives l*(10^(k-1)) + (n-l)/10.
# Setting this = m*n with integer m >= 1 yields n = l*(10^k - 1)/(10m - 1).
# For each (m, k), n is integer iff (10m - 1) divides l*(10^k - 1); since
# l <= 9, valid l are multiples of d = (10m-1)/gcd(10m-1, 10^k - 1) in
# [1, 9]. Additionally n must have exactly k digits, which forces l >= m.
# Compute n mod 10^5 directly: gcd(10m-1, 10^5) = 1 (10m-1 is coprime to
# 10), so use the Euler inverse for the division.

def pow_mod($a; $e; $m):
    if $m == 1 then 0
    else
        [1, ($a % $m), $e]
        | until(.[2] == 0;
            if .[2] % 2 == 1 then
                [(.[0] * .[1]) % $m, (.[1] * .[1]) % $m, (.[2] / 2 | floor)]
            else
                [.[0], (.[1] * .[1]) % $m, (.[2] / 2 | floor)]
            end
        )
        | .[0]
    end
;

def gcd_iter($a; $b):
    [$a, $b] | until(.[1] == 0; [.[1], (.[0] % .[1])]) | .[0]
;

reduce range(1; 10) as $m (0;
    (10 * $m - 1) as $tm
    | pow_mod($tm; 39999; 100000) as $inv_tm
    | . + (reduce range(2; 101) as $k (0;
        pow_mod(10; $k; $tm) as $tk_mod_tm
        | (($tk_mod_tm - 1 + $tm) % $tm) as $r
        | gcd_iter($tm; $r) as $g
        | ($tm / $g | floor) as $d
        | . + (reduce (range($d; 10; $d) | select(. >= $m)) as $l (0;
            pow_mod(10; $k; 100000) as $tk_mod_M
            | (($tk_mod_M - 1 + 100000) % 100000) as $tkm1
            | (($l * $tkm1 % 100000) * $inv_tm % 100000) as $n_mod
            | . + $n_mod
          ))
      ))
)
| . % 100000
