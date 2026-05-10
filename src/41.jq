def factorial:
    if . <= 1 then 1 else . * ((. - 1) | factorial) end
;

def nth_perm($n; $items):
    ($items | length) as $L
    | reduce range($L - 1; -1; -1) as $i ({k: $n, rem: $items, out: []};
        ($i | factorial) as $f
        | (.k / $f | floor) as $idx
        | {
            k: (.k - $idx * $f),
            rem: (.rem[:$idx] + .rem[$idx+1:]),
            out: (.out + [.rem[$idx]])
          }
      )
    | .out
;

def is_prime:
    . as $n
    | if $n < 2 then false
      elif $n < 4 then true
      elif $n % 2 == 0 then false
      else all(range(3; ($n | sqrt | floor) + 1; 2); $n % . != 0)
      end
;

first(
    range(5039; -1; -1)
    | nth_perm(.; [1,2,3,4,5,6,7])
    | map(tostring) | join("") | tonumber
    | select(is_prime)
)
