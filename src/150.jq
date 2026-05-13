# Build a 1000-row triangle from a linear-congruential PRNG and find the
# minimum sum over all sub-triangles. Row prefix sums let each sub-triangle
# row contribution be O(1); iterating (r, c, k) is O(N^3 / 6).
#
# PRNG: s_0 = 0; s_{k+1} = (615949 s_k + 797807) mod 2^20; t_k = s_k - 2^19.

1000 as $N

| (reduce range(0; $N) as $r ({s: 0, tri: []};
    .s as $s_start
    | ($r + 1) as $len
    | [range(0; $len) | 0] as $row_init
    | (reduce range(0; $len) as $c ({s: $s_start, row: $row_init};
        ((615949 * .s + 797807) % 1048576) as $s_new
        | ($s_new - 524288) as $t
        | {s: $s_new, row: (.row | .[$c] = $t)})) as $rs
    | {s: $rs.s, tri: (.tri + [$rs.row])})) as $state
| $state.tri as $tri

| [$tri[] as $row
   | ($row | length) as $L
   | [range(0; $L) | 0] as $init
   | reduce range(0; $L) as $j ({sum: 0, arr: $init};
       (.sum + $row[$j]) as $new_sum
       | {sum: $new_sum, arr: (.arr | .[$j] = $new_sum)})
   | .arr] as $prefix

| reduce range(0; $N) as $r (1000000000;
    reduce range(0; $r + 1) as $c (.;
        . as $cm
        | (reduce range(1; $N - $r + 1) as $k ({s: 0, m: $cm};
            ($r + $k - 1) as $i
            | $prefix[$i][$c + $k - 1] as $end_sum
            | (if $c == 0 then 0 else $prefix[$i][$c - 1] end) as $start_sum
            | (.s + $end_sum - $start_sum) as $ns
            | {s: $ns, m: (if $ns < .m then $ns else .m end)})).m))
