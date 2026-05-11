def is_perfect_square($n):
    ($n | sqrt | round) as $r
    | $r * $r == $n
;

def count_pairs($s; $c):
    if $s > 2 * $c then 0
    elif $s <= $c + 1 then ($s / 2 | floor)
    else $c - (($s + 1) / 2 | floor) + 1
    end
;

{M: 0, count: 0}
| until(.count > 1000000;
    .M += 1
    | .M as $c
    | .count += (
        [range(2; 2 * $c + 1) as $s
         | select(is_perfect_square($s * $s + $c * $c))
         | count_pairs($s; $c)]
        | add // 0
      )
  )
| .M
