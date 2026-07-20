# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/math/maxplus
import sets

type M = MaxPlus[int]

let negInf = M.negInfinity
let a: M = 3
let b: M = -2

assert negInf.isNegInfinity
assert not a.isNegInfinity
assert a.val == 3
assert negInf.get(-100) == -100
assert $negInf == "-inf"
assert (a + b).val == 3
assert (a * b).val == 1
assert a + negInf == a
assert a * negInf == negInf
assert M.zero == negInf
assert M.one.val == 0
assert (a ^ 3).val == 9
assert negInf ^ 0 == M.one
assert negInf < b and b < a
assert toHashSet([a, b, negInf, a]).len == 3
