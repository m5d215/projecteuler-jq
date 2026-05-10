[
    range(1; 10) as $k
    | range(1; 30) as $n
    | select((($n * ($k | log10)) | floor) + 1 == $n)
] | length
