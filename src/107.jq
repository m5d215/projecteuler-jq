def find($p; $x):
    if $p[$x] == $x then $x else find($p; $p[$x]) end
;

[inputs | split(",")] as $rows
| ($rows | length) as $N
| [range(0; $N) as $i
   | range($i + 1; $N) as $j
   | $rows[$i][$j] as $w
   | select($w != "-")
   | {i: $i, j: $j, w: ($w | tonumber)}
  ] as $all_edges
| ($all_edges | map(.w) | add) as $total_orig
| ($all_edges | sort_by(.w)) as $edges
| {parent: [range(0; $N)], total_mst: 0, taken: 0}
| reduce $edges[] as $e (.;
    if .taken == $N - 1 then .
    else
        find(.parent; $e.i) as $ri
        | find(.parent; $e.j) as $rj
        | if $ri == $rj then .
          else
              .parent[$ri] = $rj
              | .total_mst += $e.w
              | .taken += 1
          end
    end
  )
| $total_orig - .total_mst
