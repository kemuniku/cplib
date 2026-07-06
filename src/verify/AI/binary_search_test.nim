# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/utils/binary_search

assert meguru_bisect(0, 10, proc(x: int): bool = x * x <= 30) == 5
let root2 = meguru_bisect(0.0, 2.0, proc(x: float): bool = x * x <= 2.0, 1e-12)
assert abs(root2 * root2 - 2.0) < 1e-9
let negRoot2 = meguru_bisect(-2.0, -1.0, proc(x: float): bool = x * x >= 2.0, 1e-12)
assert abs(negRoot2 * negRoot2 - 2.0) < 1e-9
