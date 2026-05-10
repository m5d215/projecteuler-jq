def all_pandigital($a; $b):
    ("\($a)\($b)\($a * $b)" | explode | sort)
        == [49, 50, 51, 52, 53, 54, 55, 56, 57]
;

[
    (range(1; 10) as $a | range(1234; 9877) as $b
     | select(all_pandigital($a; $b)) | $a * $b),
    (range(12; 99) as $a | range(123; 988) as $b
     | select(all_pandigital($a; $b)) | $a * $b)
] | unique | add
