# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/math/combination
import cplib/modint/modint

type Mint = modint998244353_barrett
let c = initCombination[Mint](10)
assert c.fact[5].val == 120
assert c.ncr(5, 2).val == 10
assert c.npr(5, 2).val == 20
assert c.nhr(3, 2).val == 6
assert c.ncr(2, 5).val == 0
assert c.npr(-1, 0).val == 0
