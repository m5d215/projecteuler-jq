# Count subsets of {1/k^2 : k in [2,80]} summing to 1/2.
#
# v_p analysis: for p >= 17, partial sums over multiples of p have
# v_p = -2 in reduced form, uncancellable, so those k are excluded.
# Among 11-multiples only the empty subset is v_11-admissible.
# Among 13-multiples only the empty subset and {13,39,52} (sum 1/144)
# are v_13-admissible. So the problem reduces to counting subsets of
# the 39 7-smooth k's summing to 1/2 or 71/144.
#
# Integer scale: D7 = lcm(k^2 : k in smooth_7) = 2^12*3^6*5^4*7^4.
# Targets T1 = D7/2, T2 = D7/2 - D7/144.
#
# Meet-in-the-middle: build sorted arrays of all 2^20 / 2^19 subset
# sums, then 2-pointer to count pairs summing to each target. The
# subset-sum arrays are constructed via doubling (cheap concat + map)
# and then sorted with jq's built-in sort.

def is_excluded:
    . as $k
    | reduce (11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79) as $p (false;
        . or ($k % $p == 0)
    )
;

def all_sums($items):
    reduce $items[] as $n ([0]; . + map(. + $n))
;

def count_pair($L; $R; $T):
    ($L | length) as $nL | ($R | length) as $nR
    | {i: 0, j: ($nR - 1), acc: 0}
    | until(.i >= $nL or .j < 0;
        ($L[.i] + $R[.j]) as $s
        | if $s < $T then .i += 1
          elif $s > $T then .j -= 1
          else
            .i as $i0 | .j as $j0
            | $L[$i0] as $lv | $R[$j0] as $rv
            | ({k: $i0} | until(.k >= $nL or $L[.k] != $lv; .k += 1) | .k) as $iE
            | ({k: $j0} | until(.k < 0 or $R[.k] != $rv; .k -= 1) | .k) as $jE
            | .acc += ($iE - $i0) * ($j0 - $jE)
            | .i = $iE | .j = $jE
          end
    )
    | .acc
;

[range(2; 81) | select(is_excluded | not)] as $smooth7
| 4480842240000 as $D7
| ($smooth7 | map($D7 / (. * .))) as $ns
| (all_sums($ns[:20]) | sort) as $L
| (all_sums($ns[20:]) | sort) as $R
| ($D7 / 2) as $T1
| ($T1 - $D7 / 144) as $T2
| count_pair($L; $R; $T1) + count_pair($L; $R; $T2)
