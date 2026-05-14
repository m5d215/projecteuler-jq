# Sum over n=1..N of s(n) where s(n) = sum of Re(d) for Gaussian divisors
# d = a+bi of n with a > 0.
#
# d = a+bi (a > 0) divides n iff m(d) = (a^2+b^2)/gcd(a,b) divides n. So
#   S(N) = T(N) + 2 * sum_{primitive (A,B), A,B>=1, c=A^2+B^2 <= N}
#            A * T(floor(N/c))
# where T(M) = sum_{k<=M} sigma_1(k) = sum_{k=1..M} k * floor(M/k), and the
# inner sum on g collapses via floor(N/(g*c)) = floor(floor(N/c)/g).
#
# S(10^8) ~ 1.8e16 > 2^53, so all accumulators are kept as [hi, lo] pairs
# with lo in [0, 10^9). T returns a pair; A * T uses limb-wise mul-with-carry.

def add_p($p; $q):
    ($p[1] + $q[1]) as $s
    | [$p[0] + $q[0] + ($s / 1000000000 | floor), $s % 1000000000]
;

def mul_p($p; $k):
    ($p[1] * $k) as $lk
    | [$p[0] * $k + ($lk / 1000000000 | floor), $lk % 1000000000]
;

def int_to_p($n):
    [$n / 1000000000 | floor, $n % 1000000000]
;

def p_to_s:
    if .[0] == 0 then (.[1] | tostring)
    else (.[0] | tostring) + (("000000000" + (.[1] | tostring))[-9:])
    end
;

def gcd_iter($a; $b):
    [$a, $b]
    | until(.[1] == 0; [.[1], (.[0] % .[1])])
    | .[0]
;

def T:
    memoize(
        . as $M
        | if $M <= 0 then [0, 0]
          else
              ($M | sqrt | floor) as $K
              | (reduce range(1; $K + 1) as $i ([0, 0];
                    add_p(.; int_to_p($i * ($M / $i | floor)))
                )) as $part1
              | reduce range(1; $K + 1) as $q ($part1;
                  (($M / ($q + 1)) | floor) as $loBase
                  | (($M / $q) | floor) as $hi
                  | (if ($loBase + 1) > $K then $loBase + 1 else $K + 1 end) as $L
                  | if $L > $hi then .
                    else
                        ($L + $hi) as $a
                        | ($hi - $L + 1) as $b
                        | (if $a % 2 == 0 then ($a / 2 * $b) else ($a * ($b / 2)) end) as $sum_int
                        | add_p(.; mul_p(int_to_p($sum_int); $q))
                    end
                )
          end
    )
;

100000000 as $N
| ($N | sqrt | floor) as $sqrtN
| ($N | T) as $real_part
| (reduce range(1; $sqrtN + 1) as $A ([0, 0];
    . as $acc
    | (($N - $A * $A) | sqrt | floor) as $Bmax
    | reduce range(1; $Bmax + 1) as $B ($acc;
        if gcd_iter($A; $B) == 1 then
            ($A * $A + $B * $B) as $c
            | ($N / $c | floor) as $Mc
            | add_p(.; mul_p($Mc | T; $A))
        else .
        end
    )
)) as $nonreal_part
| add_p($real_part; mul_p($nonreal_part; 2))
| p_to_s
