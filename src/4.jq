def palindromes:
    range(9; 0; -1) as $a
    | range(9; -1; -1) as $b
    | range(9; -1; -1) as $c
    | $a * 100000 + $b * 10000 + $c * 1000 + $c * 100 + $b * 10 + $a
;

def ispalindrome:
    . as $palindrome
    | isempty(
        range(100; 1000) as $x
        | select($palindrome % $x == 0)
        | ($palindrome / $x) as $y
        | select(100 <= $y and $y <= 999)
      )
    | not
;

first(palindromes | select(ispalindrome))
