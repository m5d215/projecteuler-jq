def pent($n): $n * (3 * $n - 1) / 2;

3000 as $LIMIT
| [range(1; $LIMIT + 1) | pent(.)] as $pents
| (reduce $pents[] as $p ({}; .[$p | tostring] = true)) as $set
| [
    range(1; $LIMIT) as $ki | $pents[$ki] as $pk
    | range(0; $ki) as $ji | $pents[$ji] as $pj
    | ($pk - $pj) as $diff
    | select($set[$diff | tostring])
    | select($set[($pk + $pj) | tostring])
    | $diff
  ] | min
