def mulmod($a; $b):
    ($a / 100000 | floor) as $ah
    | ($a % 100000) as $al
    | ($b / 100000 | floor) as $bh
    | ($b % 100000) as $bl
    | (($ah * $bl + $al * $bh) * 100000 + $al * $bl) % 10000000000
;

def powmod($base; $exp):
    {b: ($base % 10000000000), e: $exp, r: 1}
    | until(.e == 0;
        .b as $b | .e as $e | .r as $r
        | {
            b: mulmod($b; $b),
            e: ($e / 2 | floor),
            r: (if $e % 2 == 1 then mulmod($r; $b) else $r end)
          }
      )
    | .r
;

[range(1; 1001) | powmod(.; .)] | add | . % 10000000000
