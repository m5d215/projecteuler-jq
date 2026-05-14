# Number of 20-digit numbers (no leading zero) where no three consecutive
# digits sum > 9. Digit DP over positions with state = (digit_{i-1}, digit_i).

def step($dp):
    [ range(0; 10) as $b
      | [ range(0; 10) as $c
          | (10 - $b - $c) as $amax
          | reduce range(0; $amax) as $a (0; . + $dp[$a][$b])
        ]
    ]
;

# Initial dp after position 1: dp[a][b] = 1 if a in 1..9 else 0.
[ range(0; 10) as $a | [ range(0; 10) | (if $a >= 1 then 1 else 0 end) ] ]
| reduce range(2; 20) as $_ (.; step(.))
| map(add) | add
