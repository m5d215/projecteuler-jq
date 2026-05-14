# Paper sheets envelope Markov chain.
# State = [a2, a3, a4, a5] counts of each size. After batch 1 the envelope
# always holds [1,1,1,1]. Picking A_k uses one A5 and returns one of each
# strictly smaller size (k+1..5), so transitions are:
#   A5: [a2,a3,a4,a5-1]      A4: [a2,a3,a4-1,a5+1]
#   A3: [a2,a3-1,a4+1,a5+1]  A2: [a2-1,a3+1,a4+1,a5+1]
# Probability of being drawn = count / total. Accumulate the probability of
# a single-sheet envelope across batches 2..15 (14 pre-draw states).

def transitions:
    .[0] as $a2 | .[1] as $a3 | .[2] as $a4 | .[3] as $a5
    | ($a2 + $a3 + $a4 + $a5) as $t
    | [ (if $a5 > 0 then [$a5/$t, [$a2,$a3,$a4,$a5-1]] else empty end),
        (if $a4 > 0 then [$a4/$t, [$a2,$a3,$a4-1,$a5+1]] else empty end),
        (if $a3 > 0 then [$a3/$t, [$a2,$a3-1,$a4+1,$a5+1]] else empty end),
        (if $a2 > 0 then [$a2/$t, [$a2-1,$a3+1,$a4+1,$a5+1]] else empty end) ]
;

def step:
    . as $d
    | reduce ($d | to_entries[]) as $e ({};
        ($e.key | fromjson) as $s
        | $e.value as $p
        | reduce ($s | transitions[]) as $tr (.;
            ($tr[1] | tojson) as $k
            | .[$k] = ((.[$k] // 0) + $p * $tr[0])
        )
    )
;

def single_prob:
    [to_entries[] | select((.key | fromjson | add) == 1) | .value] | add // 0
;

def format6:
    (. * 1000000 + 0.5 | floor) as $n
    | ($n / 1000000 | floor) as $i
    | ($n - $i * 1000000 | tostring) as $f
    | "\($i)." + (("000000" + $f) | .[-6:])
;

reduce range(14) as $_ ([{"[1,1,1,1]": 1}, 0];
    .[0] as $d
    | .[1] as $a
    | [$d | step, $a + ($d | single_prob)]
)
| .[1]
| format6
