# For a d-digit n, each digit pair (position i, position d-1-i) shares the
# same partial sum s_i; the middle position (d odd) contributes 2 d_mid. Walk
# positions 0..d-1 propagating the carry. All output digits (and the overflow
# digit, if any) must be odd. For each consistent (s_0, ..., s_{half}) tuple,
# multiply the digit-pair multiplicities.

def count_pair_outer($s):
    if $s < 2 or $s > 18 then 0
    elif $s <= 10 then $s - 1
    else 19 - $s end
;

def count_pair_inner($s):
    if $s < 0 or $s > 18 then 0
    elif $s <= 9 then $s + 1
    else 19 - $s end
;

def simulate($s_arr; $d):
    reduce range(0; $d) as $p ({c: 0, ok: true};
        if .ok then
            (if $p < $d - $p - 1 then $p else $d - 1 - $p end) as $idx
            | $s_arr[$idx] as $s
            | ($s + .c) as $sum
            | if ($sum % 2) == 1 then {c: ($sum / 10 | floor), ok: true}
              else {c: 0, ok: false}
              end
        else . end)
    | .ok
;

([range(0; 19) as $s0
  | select(simulate([$s0]; 2))
  | count_pair_outer($s0)] | add // 0)
+
([range(0; 19) as $s0
  | range(0; 19; 2) as $s1
  | select(simulate([$s0, $s1]; 3))
  | count_pair_outer($s0)] | add // 0)
+
([range(0; 19) as $s0
  | range(0; 19) as $s1
  | select(simulate([$s0, $s1]; 4))
  | count_pair_outer($s0) * count_pair_inner($s1)] | add // 0)
+
([range(0; 19) as $s0
  | range(0; 19) as $s1
  | range(0; 19; 2) as $s2
  | select(simulate([$s0, $s1, $s2]; 5))
  | count_pair_outer($s0) * count_pair_inner($s1)] | add // 0)
+
([range(0; 19) as $s0
  | range(0; 19) as $s1
  | range(0; 19) as $s2
  | select(simulate([$s0, $s1, $s2]; 6))
  | count_pair_outer($s0) * count_pair_inner($s1) * count_pair_inner($s2)] | add // 0)
+
([range(0; 19) as $s0
  | range(0; 19) as $s1
  | range(0; 19) as $s2
  | range(0; 19; 2) as $s3
  | select(simulate([$s0, $s1, $s2, $s3]; 7))
  | count_pair_outer($s0) * count_pair_inner($s1) * count_pair_inner($s2)] | add // 0)
+
([range(0; 19) as $s0
  | range(0; 19) as $s1
  | range(0; 19) as $s2
  | range(0; 19) as $s3
  | select(simulate([$s0, $s1, $s2, $s3]; 8))
  | count_pair_outer($s0) * count_pair_inner($s1) * count_pair_inner($s2) * count_pair_inner($s3)] | add // 0)
+
([range(0; 19) as $s0
  | range(0; 19) as $s1
  | range(0; 19) as $s2
  | range(0; 19) as $s3
  | range(0; 19; 2) as $s4
  | select(simulate([$s0, $s1, $s2, $s3, $s4]; 9))
  | count_pair_outer($s0) * count_pair_inner($s1) * count_pair_inner($s2) * count_pair_inner($s3)] | add // 0)
