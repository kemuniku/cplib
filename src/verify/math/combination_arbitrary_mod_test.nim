# verification-helper: PROBLEM https://judge.yosupo.jp/problem/binomial_coefficient
import sequtils, strutils
import cplib/math/combination_arbitrary_mod

let tm = stdin.readLine.split.map(parseInt)
let c = initCombinationArbitraryMod(10_000_000, tm[1])
for _ in 0..<tm[0]:
    let nr = stdin.readLine.split.map(parseInt)
    echo c.ncr(nr[0], nr[1])
