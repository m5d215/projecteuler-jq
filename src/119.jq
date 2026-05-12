def digit_sum($n):
    {q: $n, s: 0}
    | until(.q == 0;
        {q: (.q / 10 | floor), s: (.s + (.q % 10))}
      )
    | .s
;

[
    range(2; 200) as $s
    | foreach range(2; 60) as $k ($s; . * $s;
        if . > 9007199254740992 then empty
        elif . >= 10 and digit_sum(.) == $s then . else empty
        end
      )
]
| sort
| unique
| .[29]
