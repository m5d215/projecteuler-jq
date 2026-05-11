1000000 as $MOD
| 100000 as $MAXN

| ([range(1; 1000) as $k
    | ($k * (3 * $k - 1) / 2) as $gp
    | ($k * (3 * $k + 1) / 2) as $gn
    | (if $k % 2 == 1 then 1 else -1 end) as $sgn
    | (select($gp <= $MAXN) | [$gp, $sgn]),
      (select($gn <= $MAXN) | [$gn, $sgn])
   ] | sort_by(.[0])) as $pent

| {P: [1], n: 0}
| until(.n > 0 and .P[.n] == 0;
    (.n + 1) as $cur
    | .P as $P
    | ((reduce ($pent[] | select(.[0] <= $cur)) as [$g, $sgn] (0;
         . + $sgn * $P[$cur - $g]
       )) % $MOD + $MOD) % $MOD as $pn
    | {P: ($P + [$pn]), n: $cur}
  )
| .n
