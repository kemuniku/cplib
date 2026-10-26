# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/modint/modint
import cplib/math/online_combination_prefix_sum
import cplib/math/combination_prefix_sum

template expectValueError(body: untyped) =
    block:
        var caught = false
        try:
            body
        except ValueError:
            caught = true
        doAssert caught

proc check[M](limit: int) =
    var pascal = newSeq[seq[M]](limit + 1)
    var prefixes = newSeq[seq[M]](limit + 1)
    for n in 0..limit:
        pascal[n] = newSeq[M](n + 1)
        pascal[n][0] = 1
        pascal[n][n] = 1
        for k in 1..<n:
            pascal[n][k] = pascal[n - 1][k - 1] + pascal[n - 1][k]
        prefixes[n] = newSeq[M](n + 1)
        var s: M = 0
        for k in 0..n:
            s += pascal[n][k]
            prefixes[n][k] = s
    proc expected(n, k: int): M =
        if k < 0: return M(0)
        return prefixes[n][min(n, k)]

    # 小さい構築上限を全探索し、奇偶の行・幅、中央の反射点とブロック境界を検査。
    for cap in 0..limit:
        if cap > 64 and cap != limit: continue
        let sums = initOnlineCombinationPrefixSum[M](cap)
        for n in countdown(cap, 0):
            for k in -2..cap + 2:
                doAssert sums.prefixSum(n, k) == expected(n, k)
            doAssert sums.prefixSum(n, low(int)) == M(0)
            doAssert sums.prefixSum(n, high(int)) == expected(n, n)
            doAssert sums.rangeSum(n, low(int), high(int)) == expected(n, n)
            doAssert sums.rangeSum(n, high(int), low(int)) == M(0)
            doAssert sums.rangeSum(n, low(int), low(int)) == M(0)
            doAssert sums.rangeSum(n, high(int), high(int)) == M(0)
            if cap <= 26:
                for l in -2..cap + 2:
                    for r in -2..cap + 2:
                        var want: M = 0
                        for k in max(l, 0)..<min(r, n + 1):
                            want += pascal[n][k]
                        doAssert sums.rangeSum(n, l, r) == want
        expectValueError: discard sums.prefixSum(-1, 0)
        expectValueError: discard sums.prefixSum(cap + 1, -1)
        expectValueError: discard sums.rangeSum(-1, 5, 2)
    let sums = initOnlineCombinationPrefixSum[M](limit)
    var rng = initRand(1085)
    var previous = 0
    for q in 0..<10000:
        let n = (rng.rand(limit) + previous) mod (limit + 1)
        let k = rng.rand(limit + 10) - 5
        let answer = sums.prefixSum(n, k)
        doAssert answer == expected(n, k)
        previous = int(answer.val) mod (limit + 1)
        let l = rng.rand(limit + 10) - 5
        let r = rng.rand(limit + 10) - 5
        let want = if l >= r: M(0) else: expected(n, r - 1) - expected(n, l - 1)
        doAssert sums.rangeSum(n, l, r) == want
    expectValueError: discard initOnlineCombinationPrefixSum[M](-1)
    expectValueError: discard initOnlineCombinationPrefixSum[M](int(M.umod()))

check[modint998244353_barrett](250)
check[modint1000000007_barrett](250)
check[modint998244353_montgomery](250)
check[modint1000000007_montgomery](250)
modint_barrett.setMod(101)
check[modint_barrett](100)
modint_barrett.setMod(2)
check[modint_barrett](1)
modint_montgomery.setMod(101)
check[modint_montgomery](100)
modint_barrett.setMod(101)
let dynamicSums = initOnlineCombinationPrefixSum[modint_barrett](10)
modint_barrett.setMod(103)
expectValueError: discard dynamicSums.prefixSum(0, -1)
expectValueError: discard dynamicSums.rangeSum(0, 2, 1)
modint_barrett.setMod(101)
doAssert dynamicSums.prefixSum(4, 2).val == 11

let online = initOnlineCombinationPrefixSum[modint998244353_barrett](100)
var queries: seq[(int, int)]
for n in 0..100:
    for k in 0..n:
        queries.add((n, k))
let offline = combinationPrefixSum[modint998244353_barrett](queries)
for i, query in queries:
    doAssert online.prefixSum(query[0], query[1]) == offline[i]
block:
    type Mint = modint998244353_barrett
    const limit = 200000
    let sums = initOnlineCombinationPrefixSum[Mint](limit)
    var rng = initRand(1085)
    for i in 0..<1000:
        let n = rng.rand(limit)
        let k = rng.rand(n)
        doAssert sums.prefixSum(n, k) + sums.prefixSum(n, n - k - 1) == Mint(2).pow(n)
        if n < limit:
            doAssert sums.prefixSum(n + 1, k) == sums.prefixSum(n, k) + sums.prefixSum(n, k - 1)

echo "Hello World"
