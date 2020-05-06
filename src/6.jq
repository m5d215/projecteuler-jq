[range(1; 101)]
| (map(. * .) | add) as $a
| pow(add; 2) as $b
| $b - $a
