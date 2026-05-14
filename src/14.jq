def collatz_len:
    memoize(
        if . == 1 then 1
        elif . % 2 == 0 then (. / 2 | collatz_len) + 1
        else (. * 3 + 1 | collatz_len) + 1
        end
    )
;

reduce range(2; 1000000) as $n ({start: 1, len: 1};
    ($n | collatz_len) as $L
    | if $L > .len then {start: $n, len: $L} else . end
  )
| .start
