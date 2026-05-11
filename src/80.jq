def mp_normalize:
    if length > 1 and .[length - 1] == 0 then .[:-1] | mp_normalize else . end
;

def mp_mul_small($k):
    reduce .[] as $d ([[], 0];
        . as [$digits, $carry]
        | ($carry + $d * $k) as $x
        | [$digits + [$x % 10], ($x / 10 | floor)]
    )
    | until(.[1] == 0;
        . as [$digits, $carry]
        | [$digits + [$carry % 10], ($carry / 10 | floor)]
    )
    | .[0]
    | mp_normalize
;

def mp_add_small($k):
    reduce .[] as $d ([[], $k];
        . as [$digits, $carry]
        | ($carry + $d) as $x
        | [$digits + [$x % 10], ($x / 10 | floor)]
    )
    | until(.[1] == 0;
        . as [$digits, $carry]
        | [$digits + [$carry % 10], ($carry / 10 | floor)]
    )
    | .[0]
;

def mp_sub($b):
    . as $a
    | reduce range(0; $a | length) as $i ([[], 0];
        . as [$digits, $borrow]
        | ($a[$i] - ($b[$i] // 0) - $borrow) as $x
        | if $x < 0 then
            [$digits + [$x + 10], 1]
          else
            [$digits + [$x], 0]
          end
    )
    | .[0]
    | mp_normalize
;

def mp_compare($b):
    . as $a
    | ($a | length) as $LA
    | ($b | length) as $LB
    | if $LA > $LB then 1
      elif $LA < $LB then -1
      else
        first(
            range(0; $LA) as $i
            | ($LA - 1 - $i) as $j
            | if $a[$j] > $b[$j] then 1
              elif $a[$j] < $b[$j] then -1
              else empty end
        ) // 0
      end
;

def digit_sum_sqrt:
    . as $n
    | ([range(0; 11) | select(. * . <= $n)] | last) as $i0
    | if $i0 * $i0 == $n then null
      else
        {R: [$i0], r: [$n - $i0 * $i0]}
        | reduce range(0; 99) as $_ (.;
            (.r | mp_mul_small(100)) as $rp
            | (.R | mp_mul_small(20)) as $R20
            | ([range(0; 10) as $d
                | select($R20 | mp_add_small($d) | mp_mul_small($d) | mp_compare($rp) <= 0)
                | $d
               ] | last) as $d
            | {R: (.R | mp_mul_small(10) | mp_add_small($d)),
               r: ($rp | mp_sub($R20 | mp_add_small($d) | mp_mul_small($d)))}
          )
        | .R | add
      end
;

[range(1; 101) | digit_sum_sqrt | select(. != null)] | add
