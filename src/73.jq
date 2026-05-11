def gcd($a; $b):
    if $b == 0 then $a else gcd($b; $a % $b) end
;

reduce range(5; 12001) as $d (0;
    . + (
        [range(($d / 3 | floor) + 1; ($d - 1) / 2 | floor + 1)
         | select(. * 3 > $d and . * 2 < $d and gcd(.; $d) == 1)
        ] | length
    )
)
