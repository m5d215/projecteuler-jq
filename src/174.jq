# Count of areas N <= 10^6 with exactly t in [1, 10] distinct lamina shapes,
# summed across t. Areas are always multiples of 4 (area = 4k(m-k)), so write
# N = 4n, n in [1, 250000]. # of lamina shapes for area 4n = number of factor
# pairs (k, d) with k*d = n and k < d (the "k = d" case forces m = 2k which
# would zero the inner). So count = floor(tau(n)/2) when n is not a perfect
# square, else (tau(n) - 1)/2.

def isqrt:
    . as $n
    | ($n | sqrt | floor) as $s
    | if ($s + 1) * ($s + 1) <= $n then $s + 1
      elif $s * $s > $n then $s - 1
      else $s
      end
;

250000 as $M
| [range(0; $M + 1) | 0] as $tau_init
| (reduce range(1; $M + 1) as $d ($tau_init;
    reduce range($d; $M + 1; $d) as $n (.;
        .[$n] += 1
    )
  )) as $tau

| (reduce range(1; $M + 1) as $n ([range(0; 11) | 0];
    ($n | isqrt) as $s
    | ($s * $s == $n) as $is_sq
    | $tau[$n] as $t
    | (if $is_sq then ($t - 1) / 2 | floor else $t / 2 | floor end) as $lam
    | if $lam >= 1 and $lam <= 10 then .[$lam] += 1 else . end
  )) as $counts
| $counts[1:11] | add
