def next_r($sq):
    if $sq < 5 then 5
    elif $sq < 15 then 15
    elif $sq < 25 then 25
    elif $sq < 35 then 35
    else 5 end
;

def next_u($sq):
    if $sq < 12 then 12
    elif $sq < 28 then 28
    else 12 end
;

# Returns [[dest_sq, force_jail, weight], ...] where weights sum to 1.
# force_jail = true means the doubles counter resets to 0.
def apply_special($sq):
    if $sq == 30 then
        [[10, true, 1]]
    elif $sq == 2 or $sq == 17 or $sq == 33 then
        [[0,   false, 1/16],
         [10,  true,  1/16],
         [$sq, false, 14/16]]
    elif $sq == 7 or $sq == 22 or $sq == 36 then
        ($sq - 3) as $back3
        | next_r($sq) as $nR
        | next_u($sq) as $nU
        | (if $back3 == 33 then
              [[0, false, 1/256], [10, true, 1/256], [33, false, 14/256]]
           else
              [[$back3, false, 1/16]]
           end) as $back_dist
        | [[0,    false, 1/16],
           [10,   true,  1/16],
           [11,   false, 1/16],
           [24,   false, 1/16],
           [39,   false, 1/16],
           [5,    false, 1/16],
           [$nR,  false, 2/16],
           [$nU,  false, 1/16],
           $back_dist[],
           [$sq,  false, 6/16]]
    else
        [[$sq, false, 1]]
    end
;

def idx($sq; $d): $sq * 3 + $d;

  # 4D4 outcomes: array of {sum, dub, p=count/16}
  [range(1; 5) as $a | range(1; 5) as $b
   | {sum: ($a + $b), dub: ($a == $b)}]
| group_by([.sum, .dub])
| map({sum: .[0].sum, dub: .[0].dub, p: (length / 16)})
| . as $rolls

# Build $T[i] = edges from state i, where i = idx(sq; d)
| [range(0; 40) as $sq | range(0; 3) as $d
   | [
       $rolls[] as $r
       | (if $r.dub and $d == 2 then
              [{dest: idx(10; 0), p: $r.p}]
          else
              (($sq + $r.sum) % 40) as $new_sq
              | (if $r.dub then $d + 1 else 0 end) as $new_d
              | apply_special($new_sq)
              | map({dest: idx(.[0]; (if .[1] then 0 else $new_d end)),
                     p: ($r.p * .[2])})
          end)[]
     ]
  ]
| . as $T

| ([range(0; 120) | 0] | .[idx(0; 0)] = 1)
| reduce range(0; 500) as $_ (.;
    . as $cur
    | reduce range(0; 120) as $s ([range(0; 120) | 0];
        if $cur[$s] > 0 then
            $cur[$s] as $p
            | reduce $T[$s][] as $e (.;
                .[$e.dest] += $p * $e.p
              )
        else . end
      )
  )
| . as $final
| [range(0; 40) as $sq
   | {sq: $sq, p: ($final[$sq*3] + $final[$sq*3 + 1] + $final[$sq*3 + 2])}]
| sort_by(-.p) | .[:3]
| map(.sq | if . < 10 then "0\(.)" else "\(.)" end)
| join("")
