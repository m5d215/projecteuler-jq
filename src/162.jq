# Count hex numbers (<= 16 hex digits, no leading zero) containing at least
# one each of '0', '1', 'A'. Inclusion-exclusion on missing-digit sets:
#   N(n) = 15*16^(n-1) - (15^n + 2*14*15^(n-1))
#        + (2*14^n + 13*14^(n-1)) - 13^n.
# Sum N(n) for n=3..16 and output in hex.
#
# Intermediate values reach ~10^19 > 2^53, so use 3-limb base-10^9 ints
# [a, b, c] = a*10^18 + b*10^9 + c. Each limb < 10^9, fits in a double.

def big_add($x; $y):
    ($x[2] + $y[2]) as $s0 | ($s0 / 1000000000 | floor) as $c0 | ($s0 % 1000000000) as $l0
    | ($x[1] + $y[1] + $c0) as $s1 | ($s1 / 1000000000 | floor) as $c1 | ($s1 % 1000000000) as $l1
    | [$x[0] + $y[0] + $c1, $l1, $l0]
;

def big_sub($x; $y):
    ($x[2] - $y[2]) as $d0
    | (if $d0 < 0 then [$d0 + 1000000000, 1] else [$d0, 0] end) as $r0
    | ($x[1] - $y[1] - $r0[1]) as $d1
    | (if $d1 < 0 then [$d1 + 1000000000, 1] else [$d1, 0] end) as $r1
    | [$x[0] - $y[0] - $r1[1], $r1[0], $r0[0]]
;

def big_mul_int($x; $k):
    ($x[2] * $k) as $p0
    | ($p0 / 1000000000 | floor) as $c0 | ($p0 % 1000000000) as $l0
    | ($x[1] * $k + $c0) as $p1
    | ($p1 / 1000000000 | floor) as $c1 | ($p1 % 1000000000) as $l1
    | [$x[0] * $k + $c1, $l1, $l0]
;

def big_pow($base; $exp):
    reduce range(0; $exp) as $_ ([0, 0, 1]; big_mul_int(.; $base))
;

def hex_char($d):
    if $d < 10 then ($d | tostring)
    else ([55 + $d] | implode) end
;

def big_to_hex:
    if . == [0, 0, 0] then "0"
    else
        { n: ., s: "" }
        | until(.n == [0, 0, 0];
            .n as $n_outer
            | (reduce range(0; 3) as $i ({rem: 0, res: [0, 0, 0]};
                (.rem * 1000000000 + $n_outer[$i]) as $val
                | .rem = ($val % 16)
                | .res[$i] = ($val / 16 | floor)
              )) as $div
            | { n: $div.res, s: (hex_char($div.rem) + .s) }
          )
        | .s
    end
;

# N(n) using IE.
# Note: jq-jit miscompiles nested big_add calls — keep intermediates in vars
# (m5d215/jq-jit pending issue) so each big_add(...) is a leaf call.
def N_of($n):
    big_pow(16; $n - 1) as $p16
    | big_mul_int($p16; 15) as $T
    | big_pow(15; $n) as $A0
    | big_pow(15; $n - 1) as $p15
    | big_mul_int($p15; 28) as $A1_plus_AA
    | big_pow(14; $n) as $X
    | big_mul_int($X; 2) as $X2
    | big_pow(14; $n - 1) as $p14
    | big_mul_int($p14; 13) as $Y
    | big_pow(13; $n) as $Z
    | big_add($X2; $Y) as $XY
    | big_add($T; $XY) as $pos
    | big_sub($pos; $A0) as $s1
    | big_sub($s1; $A1_plus_AA) as $s2
    | big_sub($s2; $Z)
;

reduce range(3; 17) as $n ([0, 0, 0]; N_of($n) as $v | big_add(.; $v)) | big_to_hex
