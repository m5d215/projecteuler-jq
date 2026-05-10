def all_pandigital:
    (explode | sort) == [49, 50, 51, 52, 53, 54, 55, 56, 57]
;

[
    range(1; 10000) as $n
    | foreach range(1; 10) as $k (
        "";
        . + ($n * $k | tostring);
        select(length == 9 and all_pandigital) | tonumber
      )
] | max
