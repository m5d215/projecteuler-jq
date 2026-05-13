# Golden nuggets: N such that F(x) = sum_{i>=1} F_i x^i = N has rational solution.
# 5N^2 + 2N + 1 must be a perfect square. With M = 5N + 1: M^2 - 5K^2 = -4,
# solved by (M, K) = (L_n, F_n) for n odd. M = L_n with L_n ≡ 1 mod 5 forces
# n ≡ 1 mod 4. The k-th positive nugget is (L_{4k+1} - 1) / 5.
# k = 15 → n = 61.

{a: 2, b: 1, i: 0}
| until(.i == 61; {a: .b, b: (.a + .b), i: (.i + 1)})
| ((.a - 1) / 5)
