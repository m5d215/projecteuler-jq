2000000 as $LIMIT

| [range(0; $LIMIT) | true]
| .[0] = false | .[1] = false
| reduce range(2; ($LIMIT | sqrt | floor) + 1) as $p (.;
    if .[$p] then
        reduce range($p * $p; $LIMIT; $p) as $m (.; .[$m] = false)
    else . end
  )
| . as $sv
| [range(2; $LIMIT) | select($sv[.])]
| add
