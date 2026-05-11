def reach($vals):
    if ($vals | length) == 1 then $vals[0]
    else
        ($vals | length) as $L
        | range(0; $L) as $i
        | range($i + 1; $L) as $j
        | $vals[$i] as $a
        | $vals[$j] as $b
        | ($vals | del(.[$j]) | del(.[$i])) as $rest
        | (
            $a + $b,
            $a - $b,
            $b - $a,
            $a * $b,
            (if $b != 0 then $a / $b else empty end),
            (if $a != 0 then $b / $a else empty end)
          ) as $c
        | reach($rest + [$c])
    end
;

def is_pos_int:
    . > 0.5
    and ((. - round) | (if . < 0 then -. else . end) < 1e-9)
;

def max_run:
    reduce .[] as $x (0; if $x == . + 1 then . + 1 else . end)
;

[range(1; 7) as $a | range($a + 1; 8) as $b
 | range($b + 1; 9) as $c | range($c + 1; 10) as $d
 | [$a, $b, $c, $d]
] as $sets

| reduce $sets[] as $set ({run: 0, digits: ""};
    ([reach($set) | select(is_pos_int) | round] | unique | max_run) as $r
    | if $r > .run then {run: $r, digits: ($set | map(tostring) | join(""))}
      else . end
  )
| .digits
