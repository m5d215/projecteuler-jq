[inputs | split(",") | map(tonumber)] as $m
| ($m | length) as $N
| 99999999 as $INF

| def relax_cell($i; $j):
    (
        [
            if $i > 0       then .[$i - 1][$j] else $INF end,
            if $i < $N - 1  then .[$i + 1][$j] else $INF end,
            if $j > 0       then .[$i][$j - 1] else $INF end,
            if $j < $N - 1  then .[$i][$j + 1] else $INF end
        ] | min
    ) as $bn
    | (if $i == 0 and $j == 0 then 0 else $bn end) as $base
    | .[$i][$j] = ([.[$i][$j], $base + $m[$i][$j]] | min)
;

def fwd_pass:
    reduce range(0; $N) as $i (.;
        reduce range(0; $N) as $j (.;
            relax_cell($i; $j)
        )
    );

def bwd_pass:
    reduce range($N - 1; -1; -1) as $i (.;
        reduce range($N - 1; -1; -1) as $j (.;
            relax_cell($i; $j)
        )
    );

(
    [range(0; $N) | [range(0; $N) | $INF]]
    | .[0][0] = $m[0][0]
)
| {cur: ., prev: null}
| until(.cur == .prev;
    .cur as $c | {cur: ($c | fwd_pass | bwd_pass), prev: $c}
  )
| .cur[$N - 1][$N - 1]
