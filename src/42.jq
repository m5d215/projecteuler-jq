def words:
    split(",") | map(.[1:-1])
;

def score:
    ("A" | explode)[0] as $base
    | explode | map(. - $base + 1) | add
;

def is_triangle:
    . as $t
    | (((1 + 8 * $t) | sqrt) - 1) / 2
    | . == floor
;

[words[] | score | select(is_triangle)] | length
