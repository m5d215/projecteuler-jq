def is_pentagonal:
    . as $x
    | (1 + (1 + 24 * $x | sqrt)) / 6
    | . == floor and . > 0
;

first(
    range(144; 100000) as $n
    | ($n * (2 * $n - 1)) as $h
    | select($h | is_pentagonal)
    | $h
)
