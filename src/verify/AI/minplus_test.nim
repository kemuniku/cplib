# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/math/minplus
import sets

type M = MinPlus[int]

let inf = M.infinity
let a: M = 3
let b: M = -2

assert inf.isInfinity
assert not a.isInfinity
assert a.val == 3
assert inf.get(100) == 100
assert $inf == "inf"
assert (a + b).val == -2
assert (a * b).val == 1
assert a + inf == a
assert a * inf == inf
assert M.zero == inf
assert M.one.val == 0
assert (a ^ 3).val == 9
assert inf ^ 0 == M.one
assert b < a and a < inf
assert toHashSet([a, b, inf, a]).len == 3
