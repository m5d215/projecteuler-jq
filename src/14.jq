def collatz_len:
    {n: ., len: 1}
    | until(.n == 1;
        {n: (if .n % 2 == 0 then .n / 2 else .n * 3 + 1 end),
         len: (.len + 1)}
      )
    | .len
;

reduce range(2; 1000000) as $n ({start: 1, len: 1};
    ($n | collatz_len) as $L
    | if $L > .len then {start: $n, len: $L} else . end
  )
| .start
