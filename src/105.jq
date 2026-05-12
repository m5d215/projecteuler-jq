def bit($n; $i): ($n / pow(2; $i) | floor) % 2 == 1;

def is_special($s):
    ($s | sort) as $a
    | ($a | length) as $n
    | (all(range(2; (($n + 1) / 2 | floor) + 1);
        . as $k
        | (reduce range(0; $k) as $i (0; . + $a[$i]))
          > (reduce range(0; $k - 1) as $i (0; . + $a[$n - 1 - $i]))
      ))
    and (
        [range(1; pow(2; $n)) | . as $m
         | reduce range(0; $n) as $i ({sz: 0, sm: 0};
             if bit($m; $i) then {sz: (.sz + 1), sm: (.sm + $a[$i])} else . end)]
        | group_by(.sz)
        | all(.[]; . as $g | ([$g[].sm] | unique | length) == ($g | length))
    )
;

[inputs
 | split(",") | map(tonumber) as $s
 | select(is_special($s))
 | $s | add
]
| add
