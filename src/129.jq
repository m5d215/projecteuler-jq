1000000 as $T

| def A_gt_T($n):
    {k: 1, r: (1 % $n)}
    | until(.r == 0 or .k > $T;
        {k: (.k + 1), r: ((.r * 10 + 1) % $n)}
      )
    | .k > $T
;

{n: 1000001}
| until(
    .n % 2 != 0 and .n % 5 != 0 and A_gt_T(.n);
    {n: (.n + 2)}
  )
| .n
