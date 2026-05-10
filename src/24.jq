def factorial:
    if . <= 1 then 1 else . * ((. - 1) | factorial) end
;

[range(0; 10)] as $digits
| (1000000 - 1) as $k
| reduce range(9; -1; -1) as $i ({k: $k, rem: $digits, out: []};
    ($i | factorial) as $f
    | (.k / $f | floor) as $idx
    | {
        k: (.k - $idx * $f),
        rem: (.rem[:$idx] + .rem[$idx+1:]),
        out: (.out + [.rem[$idx]])
      }
  )
| .out | map(tostring) | join("") | tonumber
