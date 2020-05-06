def product:
    reduce .[] as $n (1; . * $n)
;

########################################################################
# generic iterator/generator
def takeWhile(condition; generator):
    label $L | foreach generator as $item (null; null;
        if $item | condition then
            $item
        else
            break $L
        end
    )
;

def takeWhile(condition):
    takeWhile(condition; .[])
;

########################################################################
# multiprecision
def to_multiprecision:
    if type == "string" then
        split("") | map(tonumber) | reverse
    elif type == "number" then
        def _elements:
            if . == 0 then
                empty
            else
                . % 10, (. / 10 | floor | _elements)
            end
        ;
        if . == 0 then [0] else [_elements] end
    else
        halt
    end
;

def mp_add(b):
    reduce ([., b] | transpose)[] as [$ai, $bi] ([[], 0];
        . as [$digits, $carry]
        | ($carry + $ai + $bi) as $x
        | [$digits + [$x % 10], ($x / 10 | floor)]
    )
    | . as [$digits, $carry]
    |
        if $carry == 0 then
            $digits
        else
            $digits + [1]
        end
;
