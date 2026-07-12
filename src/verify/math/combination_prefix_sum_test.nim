# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import atcoder/modint
import cplib/math/combination
import cplib/math/combination_prefix_sum

proc check[ModInt]() =
    var queries: seq[(int, int)]
    for x in countdown(20, 0):
        for y in 0..25:
            queries.add((x, y))

    let actual = combination_prefix_sum.combinationPrefixSum[ModInt](queries)
    let combination = initCombination[ModInt](20)
    for queryIndex, (x, y) in queries:
        var expected: ModInt = 0
        for i in 0..min(x, y):
            expected += combination.ncr(x, i)
        doAssert actual[queryIndex] == expected

    let empty: seq[(int, int)] = @[]
    doAssert combination_prefix_sum.combinationPrefixSum[ModInt](empty).len == 0

check[modint998244353]()
check[modint1000000007]()

type DynamicModInt = modint
DynamicModInt.setMod(1_000_000_007)
check[DynamicModInt]()
