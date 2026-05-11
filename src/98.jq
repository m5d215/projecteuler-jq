def parse_words:
    split(",") | map(gsub("\""; ""))
;

def is_square:
    if . < 1 then false
    else (sqrt | round) as $r | $r * $r == . end
;

def build_map($w; $s):
    reduce range(0; ($w | length)) as $i ({fwd: {}, rev: {}, ok: true};
        if .ok then
            ($w[$i:$i + 1]) as $c
            | ($s[$i:$i + 1]) as $d
            | if (.fwd[$c] // null) != null then
                  if .fwd[$c] == $d then . else .ok = false end
              elif (.rev[$d] // null) != null then
                  .ok = false
              else
                  .fwd[$c] = $d | .rev[$d] = $c
              end
        else . end
    )
    | if .ok then .fwd else null end
;

parse_words as $words
| ([$words | group_by(explode | sort | implode)[] | select(length >= 2)]) as $groups
| [
    $groups[] as $group
    | ($group[0] | length) as $L
    | (pow(10; $L - 1) | sqrt | ceil) as $smin
    | (pow(10; $L) - 1 | sqrt | floor) as $smax
    | range($smin; $smax + 1) as $r
    | ($r * $r) as $S
    | ($S | tostring) as $S_str
    | $group[] as $w1
    | build_map($w1; $S_str) as $map
    | select($map != null)
    | $group[] as $w2
    | select($w1 != $w2)
    | ($w2 | split("") | map($map[.]) | add) as $w2num_str
    | select(($w2num_str | .[0:1]) != "0")
    | ($w2num_str | tonumber) as $N
    | select($N | is_square)
    | [$S, $N] | max
  ]
| max
