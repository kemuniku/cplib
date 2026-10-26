# verification-helper: PROBLEM https://judge.yosupo.jp/problem/prefix_sum_of_binomial_coefficient

include cplib/tmpl/fastio
import cplib/math/online_combination_prefix_sum
import cplib/modint/modint

type Mint = modint998244353_barrett

let t = ii()
let sums = initOnlineCombinationPrefixSum[Mint](200000)
for _ in 0..<t:
    let n = ii()
    let k = ii()
    print(sums.prefixSum(n, k))
