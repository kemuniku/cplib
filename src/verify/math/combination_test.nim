# verification-helper: PROBLEM https://judge.yosupo.jp/problem/binomial_coefficient_prime_mod
import sequtils, strutils
import atcoder/modint
import cplib/math/combination

let tm = stdin.readLine.split.map(parseInt)
let t = tm[0]
let m = tm[1]
type mint = modint
mint.setMod(m)
var c = initCombination[mint](10_000_000)
for _ in 0..<t:
    let nk = stdin.readLine.split.map(parseInt)
    let n = nk[0]
    let k = nk[1]
    echo c.ncr(n, k).val
