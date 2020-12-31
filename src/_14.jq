def collatz:
    if . % 2 == 0 then
        . / 2
    else
        3 * . + 1
    end
;

def update(n):
    if has("\(n)") then
        .
    else
        (n | collatz) as $m
        | update($m)
        | .["\($m)"] as $length
        | setpath(["\(n)"]; $length + 1)
    end
;

reduce range(1; 1000000) as $n ({ "1": 1 }; update($n))
| . as $memo
| keys
| max_by($memo[.])
