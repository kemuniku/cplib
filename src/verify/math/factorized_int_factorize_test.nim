# verification-helper: PROBLEM https://judge.yosupo.jp/problem/factorize
import cplib/math/factorized_int
import strscans, strutils

var q: int
discard stdin.readLine.scanf("$i", q)
for _ in 0..<q:
    var a: int
    discard stdin.readLine.scanf("$i", a)
    let value = initFactorizedInt(a)
    var ans: seq[int]
    for (p, exponent) in value.primeFactors:
        for _ in 0..<exponent:
            ans.add(p)
    if ans.len == 0: echo 0
    else: echo ans.len, " ", ans.join(" ")
