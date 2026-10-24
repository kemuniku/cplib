import os, strutils, times, random
import cplib/modint/modint
import cplib/math/online_combination_prefix_sum
import cplib/math/isqrt

type Mint = modint998244353_barrett
let n = if paramCount() >= 1: parseInt(paramStr(1)) else: 160000
let q = if paramCount() >= 2: parseInt(paramStr(2)) else: 100000
var rng = initRand(1085)
var queries = newSeq[(int, int)](q)
for i in 0..<q:
    let x = rng.rand(n)
    queries[i] = (x, rng.rand(x))
let start = cpuTime()
let sums = initOnlineCombinationPrefixSum[Mint](n)
let built = cpuTime()
var checksum: Mint = 0
for (x, k) in queries:
    checksum += sums.prefixSum(x, k)
let queried = cpuTime()
for i in 0..<min(q, 1000):
    let (x, k) = queries[i]
    doAssert sums.prefixSum(x, k) + sums.prefixSum(x, x - k - 1) == Mint(2).pow(x)
    if x < n:
        doAssert sums.prefixSum(x + 1, k) == sums.prefixSum(x, k) + sums.prefixSum(x, k - 1)
let rows = n div (isqrt(n) + 1) + 1
echo "N=", n, " Q=", q, " samples=", rows * (rows + 1) div 2,
    " build_s=", built - start, " query_s=", queried - built, " checksum=", checksum
