([0] + [range(1; 21)] + [range(1; 21) | . * 2] + [range(1; 21) | . * 3] + [25, 50]) as $T
| ([range(1; 21) | . * 2] + [50]) as $D
| ($T | length) as $n
| [
    range(0; $n) as $i
    | range($i; $n) as $j
    | $D[] as $c
    | ($T[$i] + $T[$j] + $c) as $N
    | select($N < 100)
  ]
| length
