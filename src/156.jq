# Sum over d=1..9 of all n with f(n, d) = n, where f counts occurrences
# of digit d across the decimal representations of 1, 2, ..., n.
#
# f(n, d) is computed in O(log n) via the standard position-by-position
# formula. To find roots of g(n) = f(n,d) - n, we scan adaptively: g
# changes by (#d's in next n) - 1 each step, so when |g| is large we
# can safely jump by a fraction of |g| without skipping the next zero
# (only a small "drift band" near zero needs single-step scanning).

def f_count($n; $d):
    [1, 0]
    | until(.[0] > $n;
        .[0] as $p | .[1] as $total
        | ($n / ($p * 10) | floor) as $higher
        | (($n / $p | floor) % 10) as $cur
        | ($n % $p) as $lower
        | ($higher * $p) as $base
        | (if $cur > $d then $p
           elif $cur == $d then $lower + 1
           else 0
           end) as $extra
        | [$p * 10, $total + $base + $extra]
    )
    | .[1]
;

def find_for_d($d; $upper):
    [1, 0]
    | until(.[0] > $upper;
        .[0] as $n
        | (f_count($n; $d) - $n) as $g
        | if $g == 0 then [$n + 1, .[1] + $n]
          elif $g < 0 then
            ((-$g / 10 | floor) as $j
             | [$n + (if $j < 1 then 1 else $j end), .[1]])
          else
            (($g / 4 | floor) as $j
             | [$n + (if $j < 1 then 1 else $j end), .[1]])
          end
    )
    | .[1]
;

reduce range(1; 10) as $d (0; . + find_for_d($d; 1000000000000))
