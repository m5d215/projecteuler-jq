1 + reduce range(1; 501) as $k (0;
    ((2 * $k + 1) * (2 * $k + 1)) as $sq
    | . + 4 * $sq - 12 * $k
)
