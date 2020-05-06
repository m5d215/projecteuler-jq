import "./lib" as L;

def multiplies(n):
    def _multiplies(n):
        reduce .[] as $d ([[], 0];
            . as [$ds, $carry]
            | ($d * n + $carry) as $x
            | [$ds + [$x % 10], ($x / 10 | floor)]
        )
        | . as [$ds, $carry]
        | if $carry == 0 then $ds else $ds + [$carry] end
    ;

    if n == 0 or n == 1 then
        .
    elif n % 2 == 0 then
        _multiplies(2) | multiplies(n / 2)
    else
        . as $ds
        | _multiplies(2) | multiplies((n - 1) / 2) | L::mp_add($ds)
    end
;

reduce range(1; 100 + 1) as $n ([1]; multiplies($n)) | add
