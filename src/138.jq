# L^2 = h^2 + (b/2)^2 with h = b +/- 1 leads to x^2 - 5 y^2 = -1 (x = (5b +/- 4)/2,
# y = L). Solutions (x, y) come via multiplication by 9 + 4*sqrt(5), giving y
# recurrence L_n = 18 L_{n-1} - L_{n-2} with L_1 = 1 (degenerate), L_2 = 17.
# Sum L_2 .. L_13 for the 12 smallest non-degenerate triangles.

reduce range(0; 11) as $_ ([1, 17, 17];
    .[0] as $p
    | .[1] as $c
    | (18 * $c - $p) as $next
    | [$c, $next, (.[2] + $next)])
| .[2]
