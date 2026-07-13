# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/math/crt

assert crt([2, 3, 2], [3, 5, 7]) == (23, 105)
assert crt([1, 3], [4, 6]) == (9, 12)
assert crt([1, 2], [2, 4]) == (0, 0)
assert crt([-1, 2], [5, 7]) == (9, 35)
assert crt([4, 4], [6, 8]) == (4, 24)
assert crt(newSeq[int](), newSeq[int]()) == (0, 1)

let
    remainders = @[2, 3]
    moduli = @[3, 5]
assert crt(remainders, moduli) == (8, 15)
