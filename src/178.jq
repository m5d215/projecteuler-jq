# Count "step numbers": positive integers n <= 10^40 where every two
# consecutive decimal digits differ by exactly 1 and every digit 0..9 appears
# at least once. Forward DP keyed by (last_digit, seen_mask).

def bit_set($m; $b):
    if ($m / $b | floor) % 2 == 0 then $m + $b else $m end
;

[1, 2, 4, 8, 16, 32, 64, 128, 256, 512] as $B

# Initial dp at length 1: d ∈ 1..9, mask = bit_d, count = 1.
| [ range(0; 10240) | 0 ] as $init
| (reduce range(1; 10) as $d ($init;
    ($d * 1024 + $B[$d]) as $i
    | .[$i] = 1
  )) as $dp1

| reduce range(2; 41) as $L (
    {dp: $dp1, total: 0};
    .dp as $old
    | (reduce range(0; 10240) as $i (
        [range(0; 10240) | 0];
        $old[$i] as $v
        | if $v == 0 then .
          else
              ($i / 1024 | floor) as $d
              | ($i % 1024) as $m
              | (if $d > 0 then
                    bit_set($m; $B[$d - 1]) as $nm
                    | (($d - 1) * 1024 + $nm) as $ni
                    | .[$ni] += $v
                else . end)
              | (if $d < 9 then
                    bit_set($m; $B[$d + 1]) as $nm
                    | (($d + 1) * 1024 + $nm) as $ni
                    | .[$ni] += $v
                else . end)
          end
      )) as $new
    | (if $L >= 10 then
          (reduce range(0; 10) as $d (0; . + $new[$d * 1024 + 1023])) as $contrib
          | { dp: $new, total: (.total + $contrib) }
       else { dp: $new, total: .total } end)
  )
| .total
