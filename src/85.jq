def abs: if . < 0 then -. else . end;

2000000 as $TARGET
| [range(1; 100) as $m | range(1; 100) as $n
   | {area: ($m * $n),
      diff: (($m * ($m + 1) * $n * ($n + 1) / 4 - $TARGET) | abs)}]
| min_by(.diff) | .area
