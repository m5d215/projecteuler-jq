def num_to_mp:
    tostring | split("") | map(tonumber) | reverse
;

def mp_add($b):
    reduce ([., $b] | transpose)[] as [$ai, $bi] ([[], 0];
        . as [$digits, $carry]
        | ($carry + ($ai // 0) + ($bi // 0)) as $x
        | [$digits + [$x % 10], ($x / 10 | floor)]
    )
    | . as [$digits, $carry]
    | if $carry == 0 then $digits else $digits + [$carry] end
;

def is_palindrome:
    . == reverse
;

def is_lychrel($n):
    {x: ($n | num_to_mp), i: 0, found: false}
    | until(.found or .i >= 50;
        .x as $x
        | ($x | mp_add($x | reverse)) as $new
        | {
            x: $new,
            i: (.i + 1),
            found: ($new | is_palindrome)
          }
      )
    | .found | not
;

[range(1; 10000) | select(is_lychrel(.))] | length
