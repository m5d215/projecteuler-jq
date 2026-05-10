def permutations:
    if length == 0 then []
    else
        . as $arr
        | range(0; length) as $i
        | [$arr[$i]] + ($arr[:$i] + $arr[$i+1:] | permutations)
    end
;

def is_prime:
    . as $n
    | if $n < 2 then false
      elif $n < 4 then true
      elif $n % 2 == 0 then false
      else all(range(3; ($n | sqrt | floor) + 1; 2); $n % . != 0)
      end
;

[[1,2,3,4,5,6,7] | permutations | map(tostring) | join("") | tonumber]
| sort | reverse
| first(.[] | select(is_prime))
