# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/modint/modint

type MintM = modint998244353_montgomery
var a = init(MintM, 10)
var b = init(MintM, 3)
assert (a + b).val == 13
assert (a - b).val == 7
assert (a * b).val == 30
assert (a / b * b).val == 10
assert (a + 998244353).val == 10
assert (2 + b).val == 5
assert (20 - b).val == 17
assert (4 * b).val == 12
assert (MintM.init(2).pow(10)).val == 1024
assert $MintM.init(-1) == "998244352"
assert (MintM.init(2) / 2).val == 1
assert MintM.init(3).estimate_rational() == "3/1"

type MintB = modint1000000007_barrett
assert (MintB.init(1_000_000_008) + MintB.init(2)).val == 3
assert (MintB.init(2).pow(5)).val == 32

type DynM = modint_montgomery
DynM.setMod(101)
assert (DynM.init(100) + 2).val == 1
assert (DynM.init(3) * 4).val == 12

type DynB = modint_barrett
DynB.setMod(97)
assert (DynB.init(-1) + 2).val == 1
assert (DynB.init(5) / 5).val == 1
