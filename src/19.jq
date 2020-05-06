def is_leap_year:
    . % 4 == 0 and (. % 400 == 0 or . % 100 != 0)
;

def days_in_month(year; month):
        if [1, 3, 5, 7, 8, 10, 12] | contains([month]) then
            31
        elif [4, 6, 9, 11] | contains([month]) then
            30
        elif year | is_leap_year then
            29
        else
            28
        end
;

def date_range:
    range(1900; 2000 + 1) as $year
    | range(1; 12 + 1) as $month
    | range(1; days_in_month($year; $month) + 1) as $day
    | [$year, $month, $day]
;

[
    foreach date_range as $date (-1; (. + 1) % 7; $date + [.])
    | select(
        1901 <= .[0] and .[0] <= 2000 and
        .[2] == 1 and
        .[3] == 6
      )
] | length
