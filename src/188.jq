# Compute 1777 ^^ 1855 mod 10^8 (tetration / power tower).
# Recursion via Euler: pow(n, e, m) where e is large can be reduced to
# pow(n, e mod phi(m) + phi(m), m). The phi-chain from m = 10^8 lands on 1
# in O(log m) steps; once m == 1 the value is 0, so the 1855-level tower
# terminates after a few dozen recursive calls.
#
# m stays 2,5-smooth throughout, so phi(m) has a closed form depending only
# on whether m is divisible by 2 and/or 5.

def phi($m):
    if $m == 1 then 1
    elif $m % 2 == 0 and $m % 5 == 0 then $m * 2 / 5 | floor
    elif $m % 2 == 0 then $m / 2 | floor
    elif $m % 5 == 0 then $m * 4 / 5 | floor
    else 1
    end
;

def mulmod($a; $b; $m):
    if $m <= 1 then 0
    else
        ($a % $m) as $a2 | ($b % $m) as $b2
        | ($a2 / 16384 | floor) as $ah
        | ($a2 % 16384) as $al
        | ((($ah * $b2) % $m) * 16384 % $m + ($al * $b2) % $m) % $m
    end
;

def pow_mod($a; $e; $m):
    if $m <= 1 then 0
    else
        [1, ($a % $m), $e]
        | until(.[2] == 0;
            (if .[2] % 2 == 1 then mulmod(.[0]; .[1]; $m) else .[0] end) as $r
            | mulmod(.[1]; .[1]; $m) as $sq
            | (.[2] / 2 | floor) as $ne
            | [$r, $sq, $ne]
        )
        | .[0]
    end
;

def tet($n; $k; $m):
    if $m == 1 then 0
    elif $k == 0 then 1
    else
        phi($m) as $pm
        | tet($n; $k - 1; $pm) as $inner
        | pow_mod($n; $inner + $pm; $m)
    end
;

tet(1777; 1855; 100000000)
