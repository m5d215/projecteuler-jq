def multiple(n):
    reduce .[] as $d ([[], 0];
        . as [$ds, $carry]
        | ($d * n + $carry) as $x
        | [$ds + [$x % 10], ($x / 10 | floor)]
    )
    | . as [$ds, $carry]
    | if $carry == 0 then $ds else $ds + [$carry] end
;

# optimize: 2^1000 = 4^500
reduce range(0; 500) as $_ ([1]; multiple(4)) | add
