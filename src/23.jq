import "./lib" as L;

def primes:
    def _isprime(knownPrimes):
        . as $n
        | [knownPrimes | L::takeWhile(. * . <= $n)] # optimize
        | all($n % . != 0)
    ;

    def _next(knownPrimes):
        first(
            knownPrimes[-1] + 1 | while(true; . + 1)
            | select(. % 2 != 0 and (. == 5 or . % 5 != 0)) # optimize
            | select(_isprime(knownPrimes))
        )
    ;

    [2]
    | while(true; . as $knownPrimes | $knownPrimes + [_next($knownPrimes)])
    | .[-1]
;

def with_index:
    [[range(0; length)], .] | transpose
;

def abundants:
    20000 as $N
    | [L::takeWhile(. < $N + 1; primes)] as $primes

    | reduce range(2; $N + 1) as $n ([{}, {}];
        def _primeFactors(n):
            if n < length then
                .[n]
            else
                ($primes | map(select(n % . == 0))[0]) as $minimumP
                | _primeFactors(n / $minimumP)
                | .["\($minimumP)"] += 1
            end
        ;

        . + [_primeFactors($n)]
    )

    | map(
        reduce (to_entries[] | [(.key | tonumber), .value]) as [$prime, $count] ([1];
            length as $n
            | reduce range(0; $count) as $_ (.; . + (.[-$n:] | map(. * $prime)))
            | sort
        )
    )

    | with_index[12:]
    | map(select(
        . as [$n, $factors]
        | $factors[:-1] | add > $n
    ))

    | map(.[0])
;

#abundants
#| length, .

28 as $N |
[L::takeWhile(. < $N + 1; primes)] as $primes |

reduce range(2; $N + 1) as $n ([{}, {}];
    def _primeFactors(n):
        if n < length then
            .[n]
        else
            ($primes | map(select(n % . == 0))[0]) as $minimumP
            | _primeFactors(n / $minimumP)
            | .["\($minimumP)"] += 1
        end
    ;

    . + [_primeFactors($n)]
)
| .[]

#map(
#    reduce (to_entries[] | [(.key | tonumber), .value]) as [$prime, $count] ([1];
#        length as $n
#        | reduce range(0; $count) as $_ (.; . + (.[-$n:] | map(. * $prime)))
#        | sort
#    )
#)
