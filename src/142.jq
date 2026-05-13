# x+y = a^2, x-y = b^2 -> 2x = a^2 + b^2, 2y = a^2 - b^2.
# Likewise 2x = c^2 + d^2 = a^2 + b^2 for some second representation, giving
# 2z = c^2 - d^2. Then check y+z and y-z are squares. Same parity of a,b (and
# c,d) is required for x,y,z to be integers.

def is_square($x):
    if $x <= 0 then false
    else ($x | sqrt | floor) as $s
      | $s * $s == $x or ($s + 1) * ($s + 1) == $x
    end
;

1500 as $A
| [range(2; $A + 1) as $a
   | (if $a % 2 == 0 then 2 else 1 end) as $bs
   | range($bs; $a; 2) as $b
   | {s: ($a * $a + $b * $b), ymm: ($a * $a - $b * $b)}]
| group_by(.s)
| map(select(length >= 2))
| [
    .[] as $g
    | range(0; $g | length) as $i
    | range($i + 1; $g | length) as $j
    | $g[$i].ymm as $u
    | $g[$j].ymm as $v
    | (if $u > $v then $u else $v end) as $hi
    | (if $u > $v then $v else $u end) as $lo
    | ($hi - $lo) as $diff
    | select($diff > 0)
    | (($hi + $lo) / 2) as $yz_sum
    | ($diff / 2) as $yz_diff
    | select(is_square($yz_sum) and is_square($yz_diff))
    | ($g[$i].s / 2) + $yz_sum
  ]
| min
