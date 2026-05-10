def is_prime_table($max):
    reduce range(2; $max + 1) as $i ([range(0; $max + 1) | true];
        if .[$i] then
            reduce range($i * $i; $max + 1; $i) as $m (.; .[$m] = false)
        else . end
    )
    | .[0] = false | .[1] = false
;

1000000 as $MAX
| is_prime_table($MAX) as $is_p
| first(
    range(100000; $MAX) | select($is_p[.])
    | tostring as $s
    | range(1; 64) as $mask
    | (
        [range(0; 6) | . as $pos
         | select(($mask / pow(2; $pos) | floor) % 2 == 1)
         | $s[$pos:$pos + 1]]
        | unique
      ) as $marked
    | select($marked | length == 1)
    | (
        [range(0; 10) as $d
         | (reduce range(0; 6) as $pos ($s;
             if ($mask / pow(2; $pos) | floor) % 2 == 1
             then .[:$pos] + ($d | tostring) + .[$pos + 1:]
             else . end
           )) as $new
         | select($new | startswith("0") | not)
         | $new | tonumber
         | select($is_p[.])]
      ) as $family
    | select($family | length == 8)
    | $family | min
  )
