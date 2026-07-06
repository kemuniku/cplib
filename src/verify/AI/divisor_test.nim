# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import algorithm
import cplib/math/divisor

assert divisor(1) == @[1]
assert divisor(12) == @[1, 2, 3, 4, 6, 12]
let unsorted = divisor(36, false)
assert unsorted.sorted == @[1, 2, 3, 4, 6, 9, 12, 18, 36]
