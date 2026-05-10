def parse_card:
    {
        rank: (
            .[0:1] as $r
            | if $r == "T" then 10
              elif $r == "J" then 11
              elif $r == "Q" then 12
              elif $r == "K" then 13
              elif $r == "A" then 14
              else $r | tonumber end
        ),
        suit: .[1:2]
    }
;

def hand_score:
    map(parse_card) as $cards
    | ([$cards[].rank] | sort | reverse) as $sorted
    | ([$cards[].suit] | unique | length == 1) as $flush
    | ($sorted[0] - $sorted[4] == 4 and ($sorted | unique | length == 5)) as $straight
    | (
        $sorted | group_by(.)
        | map([length, .[0]])
        | sort_by(-.[0] * 100 - .[1])
      ) as $groups
    | ($groups | map(.[0])) as $counts
    | ($groups | map(.[1])) as $by_group
    | if $flush and $straight then [9, $sorted[0]]
      elif $counts == [4, 1] then [8] + $by_group
      elif $counts == [3, 2] then [7] + $by_group
      elif $flush then [6] + $sorted
      elif $straight then [5, $sorted[0]]
      elif $counts == [3, 1, 1] then [4] + $by_group
      elif $counts == [2, 2, 1] then [3] + $by_group
      elif $counts == [2, 1, 1, 1] then [2] + $by_group
      else [1] + $sorted
      end
;

[
    inputs
    | split(" ")
    | (.[0:5] | hand_score) as $p1
    | (.[5:10] | hand_score) as $p2
    | select($p1 > $p2)
] | length
