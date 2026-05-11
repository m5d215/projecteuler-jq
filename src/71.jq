[range(2; 1000001) as $d
 | ((3 * $d - 1) / 7 | floor) as $n
 | {n: $n, r: ($n / $d)}
]
| max_by(.r)
| .n
