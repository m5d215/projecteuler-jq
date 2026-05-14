# Sum of mdrs(n) over n in [2, 10^6) where mdrs(n) = max over factorizations
# of n into >=1 factor of sum of digital roots. Equivalently
#   mdrs(n) = max(dr(n), max_{a*b=n, 2<=a<=sqrt(n)} mdrs(a) + mdrs(b)).
# Memoize so each mdrs(n) is computed once; each takes O(sqrt(n)) divisor
# checks, total O(N^{3/2}) which is borderline but manageable with jq-jit.

def dr:
    if . == 0 then 0 else 1 + (. - 1) % 9 end
;

def mdrs:
    memoize(
        . as $n
        | if $n < 2 then 0
          else
            ($n | dr) as $base
            | reduce range(2; ($n | sqrt | floor) + 1) as $a ($base;
                if $n % $a == 0 then
                    ($n / $a | floor) as $b
                    | (($a | mdrs) + ($b | mdrs)) as $val
                    | if $val > . then $val else . end
                else .
                end
              )
          end
    )
;

reduce range(2; 1000000) as $n (0; . + ($n | mdrs))
