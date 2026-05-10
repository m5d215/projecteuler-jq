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

def a_n($n):
    if $n == 0 then 2
    elif ($n + 1) % 3 == 0 then 2 * (($n + 1) / 3)
    else 1
    end
;

reduce range(0; 100) as $n ({prev: [0], cur: [1]};
    .prev as $prev
    | .cur as $cur
    | a_n($n) as $a
    | {prev: $cur, cur: ($cur | mp_mul_small($a) | L::mp_add($prev))}
)
| .cur | add
