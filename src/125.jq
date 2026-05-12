def is_palindrome($n):
    ($n | tostring) as $s
    | $s == ($s | explode | reverse | implode)
;

100000000 as $LIMIT
| 7100 as $MAX
| [
    range(1; $MAX) as $i
    | foreach range($i + 1; $MAX) as $j ($i * $i; . + $j * $j;
        if . >= $LIMIT then empty
        elif is_palindrome(.) then . else empty
        end
      )
  ]
| unique
| add
