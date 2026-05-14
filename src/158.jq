# Max over n=2..26 of (# of n-letter strings on 26 distinct letters with
# exactly one ascent). The count factorizes as C(26, n) * A(n, 1) where
# A(n, 1) = 2^n - n - 1 is the Eulerian number for 1-ascent permutations.
# Iterate n, maintaining C(26, n) and 2^n incrementally; pick the max.

reduce range(2; 27) as $n (
    {c: 26, pow2: 2, best: 0};
    .c as $old_c | .pow2 as $old_pow2
    | ($old_c * (26 - $n + 1) / $n | floor) as $new_c
    | ($old_pow2 * 2) as $new_pow2
    | ($new_c * ($new_pow2 - $n - 1)) as $p
    | {c: $new_c, pow2: $new_pow2,
       best: (if $p > .best then $p else .best end)}
)
| .best
