def dss:
    tostring | explode | map(. - 48) | map(. * .) | add
;

def fact:
    if . == 0 then 1 else . * ((. - 1) | fact) end
;

def comp(remaining; digit):
    if digit == 9 then [remaining]
    else
        range(0; remaining + 1) as $c
        | [$c] + comp(remaining - $c; digit + 1)
    end
;

[range(0; 568)
 | if . == 0 then false
   else until(. == 1 or . == 89; dss) | . == 89
   end
] as $table

| reduce comp(7; 0) as $c (0;
    ([range(0; 10) | $c[.] * . * .] | add) as $S
    | if $S != 0 and $table[$S] then
        ($c | map(fact) | reduce .[] as $x (1; . * $x)) as $denom
        | . + (5040 / $denom)
      else . end
  )
