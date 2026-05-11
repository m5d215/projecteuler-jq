[inputs | split(",") | map(tonumber)] as $m
| ($m | length) as $N
| reduce range(0; $N) as $i ($m;
    reduce range(0; $N) as $j (.;
        if $i == 0 and $j == 0 then .
        elif $i == 0 then .[0][$j] = .[0][$j] + .[0][$j-1]
        elif $j == 0 then .[$i][0] = .[$i][0] + .[$i-1][0]
        else .[$i][$j] = .[$i][$j] + ([.[$i-1][$j], .[$i][$j-1]] | min)
        end
    )
  )
| .[$N-1][$N-1]
