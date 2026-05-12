200 as $N
| 11 as $BOUND

| def dfs($chain; $depth):
    $chain[-1] as $cur
    | if $depth > .[$cur] then .
      else
          (if $depth < .[$cur] then .[$cur] = $depth else . end)
          | if $depth >= $BOUND then .
            else
                reduce range(($chain | length) - 1; -1; -1) as $i (.;
                    ($cur + $chain[$i]) as $new
                    | if $new > $N or $new <= $cur then .
                      else dfs($chain + [$new]; $depth + 1)
                      end
                )
            end
      end
;

[range(0; $N + 1) | if . == 1 then 0 else $BOUND + 1 end]
| dfs([1]; 0)
| .[1:]
| add
