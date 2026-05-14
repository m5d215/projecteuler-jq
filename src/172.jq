# Number of 18-digit numbers (no leading zero) where no digit appears more
# than three times. EGF for one digit is G(x) = 1 + x + x^2/2 + x^3/6.
# Scaled: G_s(x) = 6G(x) = 6 + 6x + 3x^2 + x^3.
# H(x) = G(x) without the x^3 term (used for "first digit fixed"). H_s = 6+6x+3x^2.
#
# Counting:
#   total = 17! * (18 * [x^18] G^10 - [x^17] H * G^9)
#         = 17! * (18 * [x^18] G_s^10 - [x^17] H_s * G_s^9) / 6^10.
# (using 17! coming from removing leading zero, see derivation.)
#
# Result fits in ~2.3e17 > 2^53 so the final A_red * B_red multiplication
# uses a [hi, lo] limb-base-10^9 pair.

def poly_mul($p; $q):
    ($p | length) as $lp
    | ($q | length) as $lq
    | [ range(0; $lp + $lq - 1) as $i
        | reduce range(0; $lp) as $a (0;
            ($i - $a) as $b
            | if $b >= 0 and $b < $lq then . + $p[$a] * $q[$b] else . end
          )
      ]
;

def gcd_iter($a; $b):
    [$a, $b] | until(.[1] == 0; [.[1], (.[0] % .[1])]) | .[0]
;

# Compute G_s^10 and G_s^9 by repeated multiplication.
[6, 6, 3, 1] as $Gs
| [6, 6, 3] as $Hs
| (reduce range(0; 10) as $_ ([1]; poly_mul(.; $Gs))) as $G10
| (reduce range(0; 9) as $_ ([1]; poly_mul(.; $Gs))) as $G9
| poly_mul($Hs; $G9) as $HG9

| $G10[18] as $g10_18
| $HG9[17] as $hg9_17
| (18 * $g10_18 - $hg9_17) as $A   # integer
| 60466176 as $C   # 6^10
| 355687428096000 as $B   # 17!

| gcd_iter($A; $C) as $g
| ($A / $g | floor) as $Ar
| ($C / $g | floor) as $Cr
| ($B / $Cr | floor) as $Br

# Final result = $Ar * $Br. Up to ~2.3e17, may overflow double, so use limb-pair.
| ($Br / 1000000000 | floor) as $Bh
| ($Br % 1000000000) as $Bl
| ($Bl * $Ar) as $pLo
| ($Bh * $Ar) as $pHi
| ($pLo % 1000000000) as $lo
| ($pHi + ($pLo / 1000000000 | floor)) as $hi
| ($hi | tostring) + (("000000000" + ($lo | tostring))[-9:])
