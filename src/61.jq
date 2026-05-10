def first2: . / 100 | floor;
def last2: . % 100;
def in4: . >= 1000 and . <= 9999;

def perms:
    if length == 0 then []
    else
        . as $a
        | range(0; length) as $i
        | $a[$i] as $h
        | ($a[:$i] + $a[$i + 1:] | perms) as $t
        | [$h] + $t
    end
;

{
    "3": [range(45; 141) | . * (. + 1) / 2 | select(in4)],
    "4": [range(32; 100) | . * .],
    "5": [range(26; 82) | . * (3 * . - 1) / 2 | select(in4)],
    "6": [range(23; 71) | . * (2 * . - 1) | select(in4)],
    "7": [range(21; 64) | . * (5 * . - 3) / 2 | select(in4)],
    "8": [range(19; 59) | . * (3 * . - 2) | select(in4)]
} as $by

| first(
    (["4", "5", "6", "7", "8"] | perms) as $tail
    | (["3"] + $tail) as $perm
    | $by[$perm[0]][] as $n1
    | $by[$perm[1]][] as $n2 | select(($n1 | last2) == ($n2 | first2))
    | $by[$perm[2]][] as $n3 | select(($n2 | last2) == ($n3 | first2))
    | $by[$perm[3]][] as $n4 | select(($n3 | last2) == ($n4 | first2))
    | $by[$perm[4]][] as $n5 | select(($n4 | last2) == ($n5 | first2))
    | $by[$perm[5]][] as $n6 | select(($n5 | last2) == ($n6 | first2))
    | select(($n6 | last2) == ($n1 | first2))
    | $n1 + $n2 + $n3 + $n4 + $n5 + $n6
  )
