def digit_at($i):
    {pos: $i, d: 1, base: 1, count: 9}
    | until(.pos <= .d * .count;
        {
            pos: (.pos - .d * .count),
            d: (.d + 1),
            base: (.base * 10),
            count: (.count * 10)
        }
      )
    | .d as $d
    | .base as $base
    | (.pos - 1) as $p
    | (($p / $d | floor) + $base) as $num
    | ($p % $d) as $offset
    | $num | tostring | .[$offset:$offset+1] | tonumber
;

[1, 10, 100, 1000, 10000, 100000, 1000000]
| map(digit_at(.))
| reduce .[] as $x (1; . * $x)
