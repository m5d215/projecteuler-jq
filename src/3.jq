def primeFactors:
    def generate:
        [., [], 2]
        | until(.[0] == 1;
            . as [$source, $knownPrimes, $n]
            |
                if $source % $n == 0 then
                    [$source / $n, $knownPrimes + [$n], $n]
                else
                    [$source, $knownPrimes, $n + 1]
                end
          )
        | .[1]
    ;

    last(generate)
;

600851475143 | primeFactors | max
