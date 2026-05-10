def is_prime:
    . as $n
    | if $n < 2 then false
      elif $n < 4 then true
      elif $n % 2 == 0 then false
      else all(range(3; ($n | sqrt | floor) + 1; 2); $n % . != 0)
      end
;

{ring: 0, total: 1, primes: 0}
| until(.ring > 0 and .primes * 10 < .total;
    (.ring + 1) as $k
    | (2 * $k - 1) as $base
    | ($base * $base) as $sq
    | ([$sq + 2 * $k, $sq + 4 * $k, $sq + 6 * $k]
        | map(select(is_prime)) | length) as $newp
    | {
        ring: $k,
        total: (.total + 4),
        primes: (.primes + $newp)
      }
  )
| 2 * .ring + 1
