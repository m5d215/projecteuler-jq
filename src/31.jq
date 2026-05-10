[1, 2, 5, 10, 20, 50, 100, 200] as $coins
| 200 as $target
| reduce $coins[] as $c (
    [1] + [range(0; $target) | 0];
    reduce range($c; $target + 1) as $i (.;
        .[$i] += .[$i - $c]
    )
  )
| .[$target]
