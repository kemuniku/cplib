# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import tables
import cplib/math/primefactor

assert primefactor(1) == @[]
assert primefactor(84) == @[2, 2, 3, 7]
assert primefactor(84, false).toCountTable == @[2, 2, 3, 7].toCountTable
let pf = primefactor_table(84)
assert pf[2] == 2
assert pf[3] == 1
assert pf[7] == 1
assert primefactor_tuple(84) == @[(2, 2), (3, 1), (7, 1)]
