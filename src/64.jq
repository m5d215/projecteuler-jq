def period($N):
    ($N | sqrt | floor) as $a0
    | if $a0 * $a0 == $N then 0
      else
        {m: 0, d: 1, a: $a0, count: 0}
        | until(.count > 0 and .a == 2 * $a0;
            (.d * .a - .m) as $m1
            | (($N - $m1 * $m1) / .d) as $d1
            | (($a0 + $m1) / $d1 | floor) as $a1
            | {m: $m1, d: $d1, a: $a1, count: (.count + 1)}
          )
        | .count
      end
;

[range(2; 10001) | period(.) | select(. % 2 == 1)] | length
