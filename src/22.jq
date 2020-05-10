def names:
    split(",") | map(.[1:-1]) | sort
;

def score(name):
    ("A" | explode)[0] as $base
    | (name | explode | map(. - $base + 1) | add) as $worth
    | . * $worth
;

[foreach names[] as $name (0; . + 1; score($name))] | add
