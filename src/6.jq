[range(1; 101)] as $range
| ($range | map(. * .) | add) as $a
| pow($range | add; 2) as $b
| $b - $a
