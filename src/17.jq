def translate:
    if . < 0 then empty
    elif . == 1 then "one"
    elif . == 2 then "two"
    elif . == 3 then "three"
    elif . == 4 then "four"
    elif . == 5 then "five"
    elif . == 6 then "six"
    elif . == 7 then "seven"
    elif . == 8 then "eight"
    elif . == 9 then "nine"
    elif . == 10 then "ten"
    elif . == 11 then "eleven"
    elif . == 12 then "twelve"
    elif . == 13 then "thirteen"
    elif . == 14 then "fourteen"
    elif . == 15 then "fifteen"
    elif . == 16 then "sixteen"
    elif . == 17 then "seventeen"
    elif . == 18 then "eighteen"
    elif . == 19 then "nineteen"
    elif . == 20 then "twenty"
    elif . == 30 then "thirty"
    elif . == 40 then "forty"
    elif . == 50 then "fifty"
    elif . == 60 then "sixty"
    elif . == 70 then "seventy"
    elif . == 80 then "eighty"
    elif . == 90 then "ninety"
    elif . < 100 then (. - . % 10 | translate), (. % 10 | translate)
    elif . < 1000 and . % 100 == 0 then (. / 100 | floor | translate), "hundred"
    elif . < 1000 then (. / 100 | floor | translate), "hundred", "and", (. % 100 | translate)
    else "one", "thousand"
    end
;

[range(1; 1000 + 1) | translate | length] | add
