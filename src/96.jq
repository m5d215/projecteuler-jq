def first_empty:
    . as $board
    | reduce range(0; 81) as $i (null;
        if . != null then . elif $board[$i] == 0 then $i else . end
      )
;

def valid_at($i; $v):
    . as $board
    | ($i / 9 | floor) as $r
    | ($i % 9) as $c
    | (($r / 3 | floor) * 3) as $br
    | (($c / 3 | floor) * 3) as $bc
    | reduce range(0; 9) as $k (true;
        . and $board[$r * 9 + $k] != $v
        and $board[$k * 9 + $c] != $v
        and $board[($br + ($k / 3 | floor)) * 9 + $bc + ($k % 3)] != $v
      )
;

def solve:
    . as $board
    | if all($board[]; . != 0) then $board
      else
        first_empty as $idx
        | range(1; 10) as $v
        | select(valid_at($idx; $v))
        | ($board | .[$idx] = $v)
        | solve
      end
;

[inputs] as $lines
| [range(0; 50) as $p
   | [range(1; 10) as $r
      | ($lines[$p * 10 + $r] | explode | map(. - 48))
     ] | add
  ]
| [.[] | first(solve) | (.[0] * 100 + .[1] * 10 + .[2])]
| add
