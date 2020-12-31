def factors:
    def elements:
        . as $n
        | range(2; $n / 2 | floor + 1)
        | select($n % . == 0)
    ;

    [1, (. | elements), .]
;

# triangle numbers
first(
    1 | while(true; . + 1) | . * (. + 1) / 2 | select(factors | length >= 500)
)
