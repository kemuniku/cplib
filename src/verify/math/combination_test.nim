# verification-helper: PROBLEM https://judge.yosupo.jp/problem/binomial_coefficient_prime_mod
import sequtils, strutils
import atcoder/modint
import cplib/math/combination

var t, m: int
(t, m) = stdin.readLine.split.map(parseInt)
type mint = modint
mint.setMod(m)
var c = initCombination[mint](10_000_000)
for _ in 0..<t:
    var n, k: int
    (n, k) = stdin.readLine.split.map(parseInt)
    echo c.ncr(n, k).val
