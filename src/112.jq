def is_bouncy($n):
    {q: ($n / 10 | floor), prev: ($n % 10), up: false, down: false}
    | until(.q == 0 or (.up and .down);
        (.q % 10) as $next
        | {q: (.q / 10 | floor),
           prev: $next,
           up: (.up or $next < .prev),
           down: (.down or $next > .prev)}
      )
    | .up and .down
;

{n: 99, bouncy: 0}
| until(.bouncy * 100 == 99 * .n;
    (.n + 1) as $nn
    | (if is_bouncy($nn) then .bouncy + 1 else .bouncy end) as $b
    | {n: $nn, bouncy: $b}
  )
| .n
