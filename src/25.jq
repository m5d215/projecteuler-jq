import "./lib" as L;

{a: [1], b: [1], i: 2}
| until(.b | length >= 1000;
    .a as $a
    | .b as $b
    | {
        a: $b,
        b: ($a | L::mp_add($b)),
        i: (.i + 1)
      }
  )
| .i
