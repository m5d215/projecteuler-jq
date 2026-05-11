def roman_to_int:
    {M: 1000, D: 500, C: 100, L: 50, X: 10, V: 5, I: 1} as $v
    | . as $s
    | (length) as $L
    | reduce range(0; $L) as $i (0;
        $v[$s[$i:$i + 1]] as $cur
        | $v[$s[$i + 1:$i + 2]] as $nxt
        | if $nxt != null and $cur < $nxt then . - $cur else . + $cur end
      )
;

def int_to_roman:
    [[1000, "M"], [900, "CM"], [500, "D"], [400, "CD"],
     [100, "C"], [90, "XC"], [50, "L"], [40, "XL"],
     [10, "X"], [9, "IX"], [5, "V"], [4, "IV"], [1, "I"]] as $table
    | reduce $table[] as [$v, $s] ({n: ., out: ""};
        until(.n < $v; {n: (.n - $v), out: (.out + $s)})
      )
    | .out
;

[inputs | (length - (roman_to_int | int_to_roman | length))] | add
