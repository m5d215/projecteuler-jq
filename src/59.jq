def xor_byte($a; $b):
    reduce range(0; 8) as $_ ({a: $a, b: $b, r: 0, bit: 1};
        ((.a % 2) != (.b % 2)) as $diff
        | {
            a: (.a / 2 | floor),
            b: (.b / 2 | floor),
            r: (.r + (if $diff then .bit else 0 end)),
            bit: (.bit * 2)
          }
    )
    | .r
;

split(",") | map(tonumber) as $cipher
| ($cipher | length) as $N
| first(
    range(97; 123) as $k1
    | range(97; 123) as $k2
    | range(97; 123) as $k3
    | [$k1, $k2, $k3] as $key
    | [range(0; $N) | xor_byte($cipher[.]; $key[. % 3])] as $plain
    | ($plain | implode) as $text
    | select($text | contains(" the "))
    | $plain | add
  )
