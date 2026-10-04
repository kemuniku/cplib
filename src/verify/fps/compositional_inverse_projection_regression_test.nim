# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import random
import cplib/fps/composition
import cplib/modint/modint
import cplib/fps/power_projection

proc naiveCompose[T](f, g: seq[T], n: int): seq[T] =
    doAssert g.len == 0 or g[0].val == 0
    result = newSeq[T](n)
    var power = newSeq[T](n)
    power[0] = init(T, 1)
    for k in 0..<min(f.len, n):
        for i in k..<n: result[i] += f[k] * power[i]
        var next = newSeq[T](n)
        for i in k..<n:
            for j in 1..<min(g.len, n-i): next[i+j] += power[i] * g[j]
        power = move(next)

proc oracle[T](f: seq[T], n: int): seq[T] =
    result = newSeq[T](n)
    var powers = newSeq[seq[T]](n)
    for i in 0..<n: powers[i] = newSeq[T](n)
    let slopeInverse = f[1].inv
    for degree in 1..<n:
        for exponent in 2..degree:
            for j in 1..<degree:
                powers[exponent][degree] += result[j] * powers[exponent - 1][degree - j]
        for exponent in 2..<min(f.len, degree + 1):
            result[degree] -= f[exponent] * powers[exponent][degree]
        result[degree] *= slopeInverse
        if degree == 1: result[degree] = slopeInverse
        powers[1][degree] = result[degree]

var checked = 0
proc check[T](f: seq[T], n: int, useOracle = true) =
    let g = f.compositionalInverse(n)
    doAssert g.len == max(n, 0)
    if n <= 0: return
    var identity = newSeq[T](n)
    if n > 1: identity[1] = init(T, 1)
    doAssert naiveCompose(f, g, n) == identity
    doAssert naiveCompose(g, f, n) == identity
    if useOracle: doAssert g == oracle(f, n)
    inc checked

proc suite[T](seed: int) =
    var rng = initRand(seed)
    for n in [-1, 0, 1, 2, 3, 4, 7, 8, 9, 15, 16, 17, 31, 32, 33, 60, 61, 63, 64, 65, 66, 127, 128, 129, 130, 255, 256, 257]:
        for rep in 0..<3:
            var f = newSeq[T](max(2, n + (rep-1)*3))
            f[1] = init(T, 1 + rng.rand(15))
            for i in 2..<f.len: f[i] = init(T, rng.rand(1000))
            check(f, n, n <= 66)
    for rep in 0..<120:
        let n = rng.rand(2..80)
        var f = newSeq[T](n)
        f[1] = init(T, rng.rand(1..1000))
        for i in 2..<n: f[i] = init(T, rng.rand(1000))
        check(f, n, n <= 30)
    for n in [64, 65, 127, 128, 129, 257]:
        check(@[init(T, 0), init(T, 7)], n, false)
        var f = newSeq[T](n)
        f[1] = init(T, 1)
        f[^1] = init(T, 19)
        check(f, n, false)

suite[modint998244353_barrett](17)
suite[modint998244353_montgomery](23)
suite[modint1000000007_barrett](29)
suite[modint1000000007_montgomery](31)
type Tiny = StaticBarrettModint[5u32]
var combinations = 1
for n in 2..6:
    for code in 0..<combinations:
        for linear in 1..4:
            var f = newSeq[Tiny](n)
            f[1] = init(Tiny, linear)
            var value = code
            for i in 2..<n:
                f[i] = init(Tiny, value mod 5)
                value = value div 5
            check(f, n)
    combinations *= 5
for n in [63, 64, 65]: check(@[init(Tiny, 0), init(Tiny, 2), init(Tiny, 1)], n, false)
type Boundary = StaticBarrettModint[97u32]
for n in [63, 64, 65, 96, 97, 98, 129]:
    check(@[init(Boundary, 0), init(Boundary, 7), init(Boundary, 5), init(Boundary, 3)], n, false)
type Ring = StaticBarrettModint[9u32]
for n in [2, 7, 64, 65]:
    for linear in [1, 2, 4, 5, 7, 8]:
        check(@[init(Ring, 0), init(Ring, linear), init(Ring, 3), init(Ring, 4)], n, false)
modint_barrett.setMod(998244353)
suite[modint_barrett](37)
modint_montgomery.setMod(998244353)
suite[modint_montgomery](41)
doAssert checked == 4418
proc projectionSuite[T]() =
    var rng = initRand(47)
    for n in [1, 2, 3, 7, 8, 9, 31, 32, 33, 63, 64, 65]:
        for constant in [0, 1, 2]:
            var f, g = newSeq[T](n)
            f[0] = init(T, constant)
            for i in 1..<n: f[i] = init(T, rng.rand(1000))
            for i in 0..<n: g[i] = init(T, rng.rand(1000))
            for m in [0, n-1, n, 2*n]:
                let got = f.powerProjection(g, m)
                var power = g
                for k in 0..m:
                    doAssert got[k] == power[n-1]
                    var next = newSeq[T](n)
                    for i in 0..<n:
                        for j in 0..<n-i: next[i+j] += power[i] * f[j]
                    power = move(next)
projectionSuite[modint998244353_barrett]()
projectionSuite[modint998244353_montgomery]()
echo "Hello World"
