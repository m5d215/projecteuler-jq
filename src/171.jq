# Last 9 digits of sum over n in [1, 10^20) with F(n) = sum of digit squares
# being a perfect square.
#
# Treat n as a 20-digit string with leading zeros allowed (n=0 contributes 0
# to the sum, so including it is harmless). By position-wise linearity
#   S = sum_n n = ((10^20 - 1)/9) * sum_p (avg digit at p) * (# valid)
#   = ((10^20 - 1)/9) * T  where T = sum_d d * R(d)
# and R(d) = # of 20-digit strings with d at any fixed position p and F square.
# R(d) = sum_{square S >= d^2} Q(S - d^2) with Q(F) = # of 19-digit strings
# with digit-square sum F. Compute Q via 19-step digit DP mod 10^9.

def mulmod($a; $b; $m):
    ($a % $m) as $a2
    | ($b % $m) as $b2
    | ($a2 / 65536 | floor) as $ah
    | ($a2 % 65536) as $al
    | ((($ah * $b2) % $m) * 65536 % $m + $al * $b2 % $m) % $m
;

1539 as $maxF
| 1000000000 as $MOD

# dp[F] = Q over k digits (start k = 1 after 0 iters; we'll iterate 19 total
# starting from dp[F] = 1 if F == 0 (k=0)).
| [ range(0; $maxF + 1) | (if . == 0 then 1 else 0 end) ] as $dp0

| (reduce range(0; 19) as $_ ($dp0;
    . as $prev
    | [ range(0; $maxF + 1) as $F
        | reduce range(0; 10) as $d (0;
            ($F - $d * $d) as $pF
            | if $pF < 0 then .
              else (. + $prev[$pF]) % $MOD
              end
          )
      ]
  )) as $Q

# T mod 10^9 = sum_{rt=0..40} sum_{d=0..9, d^2 <= rt^2} d * Q[rt^2 - d^2]
| (reduce range(0; 41) as $rt (0;
    ($rt * $rt) as $S
    | . + (reduce range(0; 10) as $d (0;
        ($S - $d * $d) as $rest
        | if ($d * $d > $S) or ($rest > $maxF) then .
          else (. + $d * $Q[$rest]) % $MOD
          end
      ))
  )) as $T

| mulmod($T; 111111111; $MOD)
