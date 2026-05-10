def digits_sorted: tostring | explode | sort;

first(
    range(1; 1000000) as $x
    | ($x | digits_sorted) as $base
    | select(
        ($x * 2 | digits_sorted) == $base
        and ($x * 3 | digits_sorted) == $base
        and ($x * 4 | digits_sorted) == $base
        and ($x * 5 | digits_sorted) == $base
        and ($x * 6 | digits_sorted) == $base
      )
    | $x
)
