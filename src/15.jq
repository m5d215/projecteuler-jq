def state:
    . as $N
    | [range(0; $N + 1)] | map([range(0; $N + 1) | 1])
;

def indexes:
    . as $N
    | range(1; $N + 1) as $rows
    | range(1; $N + 1) as $columns
    | [$rows, $columns]
;

20 as $N
| reduce ($N | indexes) as [$rows, $columns] ($N | state;
    .[$rows][$columns] = .[$rows - 1][$columns] + .[$rows][$columns - 1]
  )
| .[$N][$N]
