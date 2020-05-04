# a = e^2 - f^2
# b = 2ef
# c = e^2 + f^2

(1 + 1000 | sqrt | ceil) as $upto
| range(1; $upto) | . as $f
| range($f + 1; $upto) | . as $e

| ($e * $e - $f * $f) as $a
| (2 * $e * $f) as $b
| ($e * $e + $f * $f) as $c

| select($a + $b + $c == 1000)
| $a * $b * $c
