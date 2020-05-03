def factorize:
    def generate:
        [., {}, 2]
        | until(.[0] == 1;
            . as [$source, $result, $n]
            |
                if $source % $n == 0 then
                    [
                        $source / $n,
                        $result + { "\($n)": ($result["\($n)"] + 1) },
                        $n
                    ]
                else
                    [$source, $result, $n + 1]
                end
          )
        | .[1]
    ;

    last(generate)
;

def product:
    reduce .[] as $item (1; . * $item)
;

[20 | range(2; . + 1) | factorize | to_entries[]]
| group_by(.key)
| map(max_by(.value))
| map(pow(.key | tonumber; .value))
| product
