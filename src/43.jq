[
    range(0; 1000) as $v | select($v % 17 == 0)
    | ($v / 100 | floor) as $d8
    | (($v / 10 | floor) % 10) as $d9
    | ($v % 10) as $d10
    | select($d8 != $d9 and $d8 != $d10 and $d9 != $d10)

    | range(0; 10) as $d7
    | select($d7 != $d8 and $d7 != $d9 and $d7 != $d10)
    | select(($d7 * 100 + $d8 * 10 + $d9) % 13 == 0)

    | range(0; 10) as $d6
    | select($d6 != $d7 and $d6 != $d8 and $d6 != $d9 and $d6 != $d10)
    | select(($d6 * 100 + $d7 * 10 + $d8) % 11 == 0)

    | range(0; 10) as $d5
    | select($d5 != $d6 and $d5 != $d7 and $d5 != $d8 and $d5 != $d9 and $d5 != $d10)
    | select(($d5 * 100 + $d6 * 10 + $d7) % 7 == 0)

    | range(0; 10) as $d4
    | select($d4 != $d5 and $d4 != $d6 and $d4 != $d7 and $d4 != $d8 and $d4 != $d9 and $d4 != $d10)
    | select(($d4 * 100 + $d5 * 10 + $d6) % 5 == 0)

    | range(0; 10) as $d3
    | select($d3 != $d4 and $d3 != $d5 and $d3 != $d6 and $d3 != $d7 and $d3 != $d8 and $d3 != $d9 and $d3 != $d10)
    | select(($d3 * 100 + $d4 * 10 + $d5) % 3 == 0)

    | range(0; 10) as $d2
    | select($d2 != $d3 and $d2 != $d4 and $d2 != $d5 and $d2 != $d6 and $d2 != $d7 and $d2 != $d8 and $d2 != $d9 and $d2 != $d10)
    | select(($d2 * 100 + $d3 * 10 + $d4) % 2 == 0)

    | (45 - $d2 - $d3 - $d4 - $d5 - $d6 - $d7 - $d8 - $d9 - $d10) as $d1
    | $d1 * 1000000000 + $d2 * 100000000 + $d3 * 10000000 + $d4 * 1000000
      + $d5 * 100000 + $d6 * 10000 + $d7 * 1000 + $d8 * 100 + $d9 * 10 + $d10
] | add
