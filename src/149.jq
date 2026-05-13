# Generate a 2000x2000 grid via a lagged Fibonacci PRNG (s_k = (s_{k-24} +
# s_{k-55}) mod 1000000 - 500000) and find the maximum contiguous subsequence
# sum along any horizontal row, vertical column, or 45-degree diagonal. Apply
# Kadane's algorithm to each line.

def kadane:
    reduce .[] as $x ({cur: 0, max: -1000000000};
        (if .cur > 0 then .cur + $x else $x end) as $new_cur
        | {cur: $new_cur,
           max: (if $new_cur > .max then $new_cur else .max end)})
    | .max
;

2000 as $N
| ($N * $N) as $total
| ([range(0; $total) | 0]
   | reduce range(0; $total) as $k (.;
       ($k + 1) as $i
       | (if $i <= 55
          then (((100003 - 200003 * $i + 300007 * $i * $i * $i) % 1000000) + 1000000) % 1000000 - 500000
          else (.[$k - 24] + .[$k - 55] + 1000000) % 1000000 - 500000
          end) as $v
       | .[$k] = $v)) as $flat
| [range(0; $N) | $flat[. * $N : (. + 1) * $N]] as $grid
| [
    ($grid[] | kadane),
    (range(0; $N) as $j | [$grid[] | .[$j]] | kadane),
    (range(-($N - 1); $N) as $c
     | [range(0; $N) as $i
        | ($i - $c) as $j
        | select($j >= 0 and $j < $N)
        | $grid[$i][$j]]
     | kadane),
    (range(0; 2 * $N - 1) as $c
     | [range(0; $N) as $i
        | ($c - $i) as $j
        | select($j >= 0 and $j < $N)
        | $grid[$i][$j]]
     | kadane)
  ]
| max
