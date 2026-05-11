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

[
    [2, 3, 4, 5] | perms as $rest
    | ([1] + $rest) as $inner
    | [range(0; 5) | (14 - $inner[.] - $inner[(. + 1) % 5])] as $outer
    | select(($outer | sort) == [6, 7, 8, 9, 10])
    | [range(0; 5) | {o: $outer[.], a: $inner[.], b: $inner[(. + 1) % 5]}] as $lines
    | (first(range(0; 5) | select($outer[.] == ($outer | min)))) as $start_idx
    | ($lines[$start_idx:] + $lines[:$start_idx]) as $rotated
    | ($rotated | map("\(.o)\(.a)\(.b)") | join("") | tonumber)
] | max
