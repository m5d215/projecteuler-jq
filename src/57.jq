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
                  {c: (.c / 10 | floor), ds: (.ds + [.c % 10])}
                )
              | .ds
          )
      end
;

def mp_add($b):
    reduce ([., $b] | transpose)[] as [$ai, $bi] ([[], 0];
        . as [$digits, $carry]
        | ($carry + ($ai // 0) + ($bi // 0)) as $x
        | [$digits + [$x % 10], ($x / 10 | floor)]
    )
    | . as [$digits, $carry]
    | if $carry == 0 then $digits else $digits + [$carry] end
;

[
    foreach range(0; 1000) as $_ ({a: [1], b: [1]};
        .a as $a | .b as $b
        | ($b | mp_mul_small(2)) as $b2
        | {
            a: ($a | mp_add($b2)),
            b: ($a | mp_add($b))
          };
        select((.a | length) > (.b | length))
      )
] | length
