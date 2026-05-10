def fact:
    if . <= 1 then 1 else . * ((. - 1) | fact) end
;

[range(0; 10) | fact] as $f
| [
    range(3; 2540160 + 1)
    | select(. == ([tostring | explode[] - 48 | $f[.]] | add))
  ]
| add
