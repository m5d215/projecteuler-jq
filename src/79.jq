[inputs] as $lines
| ([$lines[] as $l
    | range(0; 3) as $i
    | range($i + 1; 3) as $j
    | [$l[$i:$i + 1], $l[$j:$j + 1]]
   ] | unique) as $edges
| ([$edges[] | .[0], .[1]] | unique) as $nodes
| reduce range(0; $nodes | length) as $_ (
    {nodes: $nodes, edges: $edges, result: ""};
    .nodes as $ns | .edges as $es
    | first($ns[] | . as $n | select(all($es[]; .[1] != $n))) as $picked
    | {
        nodes: ($ns - [$picked]),
        edges: [$es[] | select(.[0] != $picked)],
        result: (.result + $picked)
      }
  )
| .result
