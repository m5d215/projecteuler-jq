def to_bin:
    if . == 0 then "0"
    else
        [recurse(if . > 0 then . / 2 | floor else empty end)
         | select(. > 0) | . % 2]
        | reverse | map(tostring) | join("")
    end
;

def is_palindrome:
    . == (explode | reverse | implode)
;

[
    range(1; 1000000; 2)
    | select((tostring | is_palindrome) and (to_bin | is_palindrome))
] | add
