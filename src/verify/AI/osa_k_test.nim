# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import tables
import cplib/math/osa_k

let table = initPrimeFactorTable(100)
assert table.primefactor(1) == @[]
assert table.primefactor(84) == @[2, 2, 3, 7]
let pf = table.primefactor_table(84)
assert pf[2] == 2
assert pf[3] == 1
assert pf[7] == 1
assert table.primefactor_tuple(84) == @[(2, 2), (3, 1), (7, 1)]
