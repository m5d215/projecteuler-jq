def num_div($n):
    if $n == 1 then 1
    else
        ($n | sqrt | floor) as $r
        | reduce range(1; $r + 1) as $i (0;
            if $n % $i == 0 then
                if $n / $i == $i then . + 1 else . + 2 end
            else .
            end
          )
    end
;

# d(T_n) = d(a) * d(b) where a, b coprime and a*b = T_n
# n even: a = n/2, b = n+1
# n odd:  a = n,   b = (n+1)/2
{n: 1, d: 1}
| until(.d > 500;
    (.n + 1) as $n
    | (if $n % 2 == 0
       then num_div($n / 2) * num_div($n + 1)
       else num_div($n) * num_div(($n + 1) / 2)
       end) as $d
    | {n: $n, d: $d}
  )
| .n * (.n + 1) / 2
