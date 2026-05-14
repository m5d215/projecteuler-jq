# Number of ways to write 10^25 as a sum of powers of 2, each used at most
# twice. Recursion (Stern's sequence): f(0)=1, f(odd n)=f((n-1)/2),
# f(even n)=f(n/2)+f(n/2 - 1).
#
# n = 10^25 > 2^53, so represent n as a 3-limb [a, b, c] base-10^9 array.
# All operations needed are: zero check, parity (c % 2), shift-right by 1
# (long division by 2), and subtract 1 (with borrow).

def n_zero($n): $n[0] == 0 and $n[1] == 0 and $n[2] == 0;
def n_odd($n): $n[2] % 2 == 1;

def n_shr($n):
    $n[0] as $a | $n[1] as $b | $n[2] as $c
    | ($a / 2 | floor) as $na
    | ($a % 2) as $ra
    | (($ra * 1000000000 + $b)) as $bv
    | ($bv / 2 | floor) as $nb
    | ($bv % 2) as $rb
    | (($rb * 1000000000 + $c)) as $cv
    | ($cv / 2 | floor) as $nc
    | [$na, $nb, $nc]
;

def n_dec($n):
    if $n[2] > 0 then [$n[0], $n[1], $n[2] - 1]
    elif $n[1] > 0 then [$n[0], $n[1] - 1, 999999999]
    else [$n[0] - 1, 999999999, 999999999]
    end
;

def f:
    memoize(
        . as $n
        | if n_zero($n) then 1
          elif n_odd($n) then (n_shr($n) | f)
          else
            n_shr($n) as $h
            | n_dec($h) as $h2
            | ($h | f) + ($h2 | f)
          end
    )
;

[10000000, 0, 0] | f
