def base_exp:
    . as $a
    | first(
        range(2; ($a | sqrt | floor) + 1) as $c
        | range(2; 7) as $k
        | select(pow($c; $k) == $a)
        | [$c, $k]
      ) // [$a, 1]
;

[
    range(2; 101) as $a
    | range(2; 101) as $b
    | $a | base_exp as [$c, $k] | [$c, $k * $b]
] | unique | length
