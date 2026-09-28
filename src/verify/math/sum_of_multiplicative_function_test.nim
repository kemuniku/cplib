# verification-helper: PROBLEM https://judge.yosupo.jp/problem/sum_of_multiplicative_function
include cplib/tmpl/sheep
import cplib/modint/modint
import cplib/math/multiplicative_prefix_sum

type Mint = StaticMontgomeryModint[469762049'u32]
let t = ii()
for _ in 0..<t:
    let n = ii()
    let a = init(Mint, ii())
    let b = init(Mint, ii())
    let answer = multiplicativePrefixSum(n, @[a, b],
        proc(p, e: int): Mint = a * e + b * p)
    print answer
