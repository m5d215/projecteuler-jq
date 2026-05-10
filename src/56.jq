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

[
    range(1; 100) as $a
    | foreach range(1; 100) as $_ ([1]; mp_mul_small($a); add)
] | max
