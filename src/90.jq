def cube_gen($start; $remaining; $current):
    if $remaining == 0 then $current
    else
        range($start; 10 - $remaining + 1) as $d
        | cube_gen($d + 1; $remaining - 1; $current + [$d])
    end
;

def eff:
    . as $c
    | $c
      + (if ($c | index(6)) != null then [9] else [] end)
      + (if ($c | index(9)) != null then [6] else [] end)
    | unique
;

def pair_ok($e1; $e2; $a; $b):
    (($e1 | index($a)) != null and ($e2 | index($b)) != null)
    or (($e1 | index($b)) != null and ($e2 | index($a)) != null)
;

[[0,1], [0,4], [0,9], [1,6], [2,5], [3,6], [4,9], [6,4], [8,1]] as $sq

| [cube_gen(0; 6; [])] as $cubes
| ($cubes | length) as $K
| [range(0; $K) as $i | range($i; $K) as $j
   | ($cubes[$i] | eff) as $e1
   | ($cubes[$j] | eff) as $e2
   | select(all($sq[]; pair_ok($e1; $e2; .[0]; .[1])))
  ]
| length
