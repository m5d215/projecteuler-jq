100000 as $N
| [range(0; $N + 1) | 1]
| reduce range(2; $N + 1) as $p (.;
    if .[$p] == 1 then
        reduce range($p; $N + 1; $p) as $m (.; .[$m] = .[$m] * $p)
    else . end
  )
| . as $rad
| [range(1; $N + 1) | {n: ., r: $rad[.]}]
| sort_by([.r, .n])
| .[9999].n
