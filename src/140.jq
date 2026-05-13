# A_G(x) = (x + 3 x^2) / (1 - x - x^2) = N rational requires 5 N^2 + 14 N + 1
# to be a perfect square. Setting M = 5 N + 7 yields M^2 - 5 K^2 = 44.
# Three bi-orbits under the Pell unit (9 + 4 sqrt(5)) cover all (M, K). The
# valid (M >= 12, M ≡ 2 mod 5) elements within each bi-orbit lie 2 Pell steps
# apart, giving the squared-step recurrence M_{n+1} = 322 M_n - M_{n-1}.
# Six rays (two per bi-orbit) generate enough valid M to cover the first 30
# nuggets; we then sort and sum N = (M - 7) / 5.

def ray($prev; $curr; $depth):
    [$curr] +
    (if $depth <= 0 then []
     else (322 * $curr - $prev) as $next
       | ray($curr; $next; $depth - 1)
     end)
;

[
    ray(7; 767; 6),
    ray(7; 1487; 6),
    ray(32; 112; 6),
    ray(112; 32; 6),
    ray(17; 217; 6),
    ray(217; 17; 6)
]
| add
| map((. - 7) / 5)
| sort
| .[0:30]
| add
