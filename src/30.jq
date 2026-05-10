def digit_fifth_sum:
    [tostring | explode[] - 48 | . * . * . * . * .] | add
;

[range(2; 354295) | select(. == digit_fifth_sum)] | add
