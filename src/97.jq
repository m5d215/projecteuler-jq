def mulmod($a; $b; $m):
    ($a / 100000 | floor) as $ah
    | ($a % 100000) as $al
    | ($b / 100000 | floor) as $bh
    | ($b % 100000) as $bl
    | (($ah * $bl + $al * $bh) * 100000 + $al * $bl) % $m
;

def powmod($base; $n; $m):
    {b: $base, e: $n, r: 1}
    | until(.e == 0;
        (if .e % 2 == 1 then mulmod(.r; .b; $m) else .r end) as $newR
        | {b: mulmod(.b; .b; $m), e: (.e / 2 | floor), r: $newR}
      )
    | .r
;

10000000000 as $M
| powmod(2; 7830457; $M) as $pow
| (mulmod(28433; $pow; $M) + 1) % $M
