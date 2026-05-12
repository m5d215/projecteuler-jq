def bit($n; $i): ($n / pow(2; $i) | floor) % 2 == 1;

def subset_sums_unique($s):
    [range(1; 128) | . as $m
     | reduce range(0; 7) as $i ({sz: 0, sm: 0};
         if bit($m; $i) then {sz: (.sz + 1), sm: (.sm + $s[$i])} else . end)]
    | group_by(.sz)
    | all(.[]; . as $g | ([$g[].sm] | unique | length) == ($g | length))
;

280 as $S_MAX
| [
    range(15; 26) as $a1
    | range($a1 + 1; 35) as $a2
    | ($a1 + $a2) as $cap
    | range($a2 + 1; $cap) as $a3
    | range($a3 + 1; $cap) as $a4
    | ($a1 + $a2 + $a3 + $a4) as $S4
    | select($S4 < $S_MAX - 30)
    | range($a4 + 1; (($S4 - 3) / 3 | floor) + 1) as $a5
    | range($a5 + 1; (($S4 - $a5 - 1) / 2 | floor) + 1) as $a6
    | range($a6 + 1; [$cap, $S4 - $a5 - $a6] | min) as $a7
    | ($S4 + $a5 + $a6 + $a7) as $sum
    | select($sum < $S_MAX)
    | [$a1, $a2, $a3, $a4, $a5, $a6, $a7] as $s
    | select(subset_sums_unique($s))
    | {sum: $sum, set: $s}
]
| min_by(.sum)
| .set | map(tostring) | add
