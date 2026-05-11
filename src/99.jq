[[inputs] | to_entries[]
 | .key as $i
 | (.value | split(",")) as $be
 | [$i + 1, (($be[0] | tonumber | log) * ($be[1] | tonumber))]
]
| max_by(.[1])
| .[0]
