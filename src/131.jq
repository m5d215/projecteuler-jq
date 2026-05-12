def is_prime($n):
    if $n < 2 then false
    elif $n < 4 then true
    elif $n % 2 == 0 or $n % 3 == 0 then false
    else
        ($n | sqrt | floor) as $sq
        | all(range(5; $sq + 1; 6);
            $n % . != 0 and $n % (. + 2) != 0
          )
    end
;

[range(1; 578) | (3 * . * . + 3 * . + 1) | select(is_prime(.))]
| length
