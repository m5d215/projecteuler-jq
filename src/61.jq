def first2: . / 100 | floor;
def last2: . % 100;
def in4: . >= 1000 and . <= 9999;

{
    "3": [range(45; 141) | . * (. + 1) / 2 | select(in4)],
    "4": [range(32; 100) | . * .],
    "5": [range(26; 82) | . * (3 * . - 1) / 2 | select(in4)],
    "6": [range(23; 71) | . * (2 * . - 1) | select(in4)],
    "7": [range(21; 64) | . * (5 * . - 3) / 2 | select(in4)],
    "8": [range(19; 59) | . * (3 * . - 2) | select(in4)]
} as $by_type

| def find_cycle($first; $cur_first; $remaining; $chain):
    if ($remaining | length) == 0 then
        if $cur_first == $first then $chain else empty end
    else
        $remaining[] as $t
        | $by_type[$t][] as $n
        | select(($n | first2) == $cur_first)
        | find_cycle($first; ($n | last2);
                     ($remaining - [$t]); ($chain + [$n]))
    end
;

  ["3", "4", "5", "6", "7", "8"] as $types
| first(
    $types[] as $start_t
    | $by_type[$start_t][] as $start_n
    | find_cycle(($start_n | first2); ($start_n | last2);
                 ($types - [$start_t]); [$start_n])
  )
| add
