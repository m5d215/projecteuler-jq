# (b - a) | c on a Pythagorean triple gives a + b = d*m, c = d*k where
# m^2 - 2 k^2 = -1. Solutions follow x_{n+1} = 6 x_n - x_{n-1}, starting
# (m_1, k_1) = (1, 1) (degenerate), (m_2, k_2) = (7, 5).
# Each (m, k) parameterizes (a, b, c) = d * ((m-1)/2, (m+1)/2, k);
# perimeter = d * (m + k). Count d with perimeter < 10^8.

100000000 as $N
| reduce range(0; 25) as $_ ([1, 1, 7, 5, 0];
    .[2] as $m
    | .[3] as $k
    | ($m + $k) as $per
    | (if $per < $N then (($N - 1) / $per | floor) else 0 end) as $cnt
    | [.[2], .[3], 6 * .[2] - .[0], 6 * .[3] - .[1], .[4] + $cnt])
| .[4]
