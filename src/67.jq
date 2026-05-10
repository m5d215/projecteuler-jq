[inputs | split(" ") | map(tonumber)]
| reverse
| reduce .[1:][] as $line (.[0];
    [$line, .[0:-1], .[1:]]
    | transpose
    | map([.[0] + .[1], .[0] + .[2]] | max)
  )
| .[0]
