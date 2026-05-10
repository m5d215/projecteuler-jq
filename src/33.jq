def gcd($a; $b):
    if $b == 0 then $a else gcd($b; $a % $b) end
;

[
    range(10; 100) as $n
    | range(10; 100) as $d
    | select($n < $d)
    | ($n / 10 | floor) as $a | ($n % 10) as $b
    | ($d / 10 | floor) as $c | ($d % 10) as $e
    | select(($b != 0) or ($e != 0))
    | select(
        ($a == $c and $e != 0 and $n * $e == $d * $b) or
        ($a == $e and $c != 0 and $n * $c == $d * $b) or
        ($b == $c and $e != 0 and $n * $e == $d * $a) or
        ($b == $e and $c != 0 and $n * $c == $d * $a)
      )
    | [$n, $d]
]
| reduce .[] as $f ([1, 1];
    [.[0] * $f[0], .[1] * $f[1]]
  )
| . as [$n, $d]
| $d / gcd($n; $d)
