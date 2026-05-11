1000000000000 as $LIMIT
| {x: 2, y: 1, b: 1, n: 1}
| until(.n > $LIMIT;
    .x as $x | .y as $y
    | (3 * $x + 4 * $y) as $nx
    | (2 * $x + 3 * $y) as $ny
    | {x: $nx, y: $ny,
       b: (($nx + 2) / 4 | floor),
       n: (($ny + 1) / 2 | floor)}
  )
| .b
