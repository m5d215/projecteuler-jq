import "./lib" as L;

def mp_mul_small($k):
    reduce .[] as $d ([[], 0];
        . as [$digits, $carry]
        | ($d * $k + $carry) as $x
        | [$digits + [$x % 10], ($x / 10 | floor)]
    )
    | . as [$digits, $carry]
    | if $carry == 0 then $digits
      else
          $digits + (
              {c: $carry, ds: []}
              | until(.c == 0;
                  {c: (.c / 10 | floor), ds: (.ds + [.c % 10])})
              | .ds
          )
      end
;

def cf_seq($N):
    ($N | sqrt | floor) as $a0
    | if $a0 * $a0 == $N then null
      else
        {m: 0, d: 1, a: $a0, seq: [$a0]}
        | until((.seq | length) > 1 and .a == 2 * $a0;
            (.d * .a - .m) as $m1
            | (($N - $m1 * $m1) / .d) as $d1
            | (($a0 + $m1) / $d1 | floor) as $a1
            | {m: $m1, d: $d1, a: $a1, seq: (.seq + [$a1])}
          )
        | .seq
      end
;

def pell_x($D):
    cf_seq($D) as $seq
    | if $seq == null then null
      else
        (($seq | length) - 1) as $p
        | (if $p % 2 == 0
           then $seq[:$p]
           else $seq + $seq[1:$p]
           end) as $coeffs
        | reduce $coeffs[] as $a ({p: [1], q: [0], pp: [0], qq: [1]};
            .p as $cp | .q as $cq | .pp as $cpp | .qq as $cqq
            | {
                p: ($cp | mp_mul_small($a) | L::mp_add($cpp)),
                q: ($cq | mp_mul_small($a) | L::mp_add($cqq)),
                pp: $cp,
                qq: $cq
              }
          )
        | .p
      end
;

def mp_to_str: reverse | map(tostring) | join("");

[
    range(2; 1001) as $D
    | pell_x($D) as $x
    | select($x != null)
    | {D: $D, x_str: ($x | mp_to_str)}
]
| max_by([(.x_str | length), .x_str])
| .D
