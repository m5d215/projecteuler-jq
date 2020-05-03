def fibs(condition):
    [1, 2] | while(.[0] | condition; . as [$a, $b] | [$b, $a + $b]) | .[0]
;

[fibs(. < 4000000) | select(. % 2 == 0)] | add
