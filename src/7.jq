def takeWhile(condition):
    label $L
    | foreach .[] as $item (null; null;
        if $item | condition then
            $item
        else
            break $L
        end
        )
;

def isprime(knownPrimes):
    . as $n
    | [knownPrimes | takeWhile(. * . <= $n)] # optimize
    | all($n % . != 0)
;

def next(knownPrimes):
    first(
        knownPrimes[-1] + 1 | while(true; . + 1)
        | select(. % 2 != 0 and (. == 5 or . % 5 != 0)) # optimize
        | select(isprime(knownPrimes))
    )
;

def primes:
    [2]
    | while(true; . as $knownPrimes | $knownPrimes + [next($knownPrimes)])
    | .[-1]
;

nth(10000; primes)
