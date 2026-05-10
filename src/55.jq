import "./lib" as L;

def is_palindrome:
    . == reverse
;

def is_lychrel($n):
    {x: ($n | L::to_multiprecision), i: 0, found: false}
    | until(.found or .i >= 50;
        .x as $x
        | ($x | L::mp_add($x | reverse)) as $new
        | {
            x: $new,
            i: (.i + 1),
            found: ($new | is_palindrome)
          }
      )
    | .found | not
;

[range(1; 10000) | select(is_lychrel(.))] | length
