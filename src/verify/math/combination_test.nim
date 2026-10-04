# verification-helper: PROBLEM https://judge.yosupo.jp/problem/binomial_coefficient_prime_mod
include cplib/tmpl/fastio
import atcoder/modint
import cplib/math/combination
let t = ii()
let m = ii()
type Mint = modint
Mint.setMod(m)
let c = initCombination[Mint](10_000_000)
var output = newStringOfCap(t * 11)
for _ in 0..<t:
    let n = ii()
    let k = ii()
    output.add($c.ncr(n, k).val)
    output.add('\n')
stdout.write(output)
