# Count laminae (square frames) of area at most 10^6.
# A lamina has outer side m and inner side m - 2k, with k >= 1 and m >= 2k+1.
# Area = m^2 - (m-2k)^2 = 4k(m-k), so 4k(m-k) <= 10^6 means k(m-k) <= 250000.
# For each k, valid m runs over [2k+1, k + floor(250000/k)], contributing
# max(0, floor(250000/k) - k).

250000 as $T
| reduce range(1; ($T | sqrt | floor) + 1) as $k (0;
    ($T / $k | floor) as $q
    | (if $q > $k then . + ($q - $k) else . end)
)
