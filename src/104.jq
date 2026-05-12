def is_pandigital_19($d):
    ($d | tostring) as $s
    | ($s | length) == 9
      and (($s | explode | sort) == [49, 50, 51, 52, 53, 54, 55, 56, 57])
;

def first9($f):
    ($f | log10 | floor) as $e
    | ($f / pow(10; $e - 8) | floor)
;

{k: 2, la: 1, lb: 1, fa: 1.0, fb: 1.0}
| until(
    is_pandigital_19(.lb) and is_pandigital_19(first9(.fb));
    .la as $la | .lb as $lb | .fa as $fa | .fb as $fb
    | {
        k: (.k + 1),
        la: $lb,
        lb: (($la + $lb) % 1000000000),
        fa: $fb,
        fb: ($fa + $fb)
      }
    | if .fb > 1e100
      then .fa = (.fa / 1e50) | .fb = (.fb / 1e50)
      else . end
  )
| .k
