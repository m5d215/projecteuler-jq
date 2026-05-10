def is_prime:
    . as $n
    | if $n < 2 then false
      elif $n < 4 then true
      elif $n % 2 == 0 then false
      else all(range(3; ($n | sqrt | floor) + 1; 2); $n % . != 0)
      end
;

first(
    range(9; 100000; 2)
    | select(is_prime | not)
    | . as $n
    | ($n / 2 | sqrt | floor) as $kmax
    | select(
        all(range(1; $kmax + 1);
            . as $k
            | ($n - 2 * $k * $k)
            | . <= 1 or (is_prime | not)
        )
      )
)
