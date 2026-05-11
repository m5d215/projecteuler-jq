[inputs | split(",") | map(tonumber)] as $m
| ($m | length) as $N
| [range(0; $N) | $m[.][0]] as $dp0
| reduce range(1; $N) as $j ($dp0;
    . as $dp
    | [range(0; $N) | $dp[.] + $m[.][$j]]
    | reduce range(1; $N) as $i (.;
        .[$i] = ([.[$i], .[$i - 1] + $m[$i][$j]] | min)
      )
    | reduce range($N - 2; -1; -1) as $i (.;
        .[$i] = ([.[$i], .[$i + 1] + $m[$i][$j]] | min)
      )
  )
| min
