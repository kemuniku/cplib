# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import random
import cplib/fps/composition
import cplib/fps/power_projection
import cplib/modint/modint

proc naiveCompose[T](outer, inner: seq[T], n: int): seq[T] =
    result = newSeq[T](max(n, 0))
    if n <= 0: return
    var power = newSeq[T](n)
    power[0] = init(T, 1)
    for k in 0..<min(outer.len, n):
        for i in k..<n: result[i] += outer[k] * power[i]
        var next = newSeq[T](n)
        for i in k..<n:
            for j in 1..<min(inner.len, n - i):
                next[i + j] += power[i] * inner[j]
        power = move(next)

proc suite[T](seed: int) =
    var rng = initRand(seed)
    for n in [-1, 0, 1, 2, 3, 4, 7, 8, 9, 15, 16, 17, 30, 31, 32,
              33, 59, 60, 61, 63, 64, 65, 127, 128, 129, 255, 256, 257]:
        for shape in 0..<7:
            var f = newSeq[T](max(0, n + 3))
            var g = newSeq[T](max(0, n + 5))
            for i in 0..<f.len: f[i] = init(T, rng.rand(T.umod.int - 1))
            for i in 1..<g.len:
                if shape != 4 and (shape != 1 or i mod 7 == 0):
                    g[i] = init(T, rng.rand(T.umod.int - 1))
            if shape == 2: g.setLen(min(g.len, 4))
            if shape == 3: f.setLen(min(f.len, 3))
            if shape == 4: g.setLen(0)
            if shape >= 5:
                let degree = (if shape == 5: 1 else: 7)
                g = newSeq[T](degree + 1)
                g[degree] = -init(T, rng.rand(1..T.umod.int - 1))
            if shape == 0:
                for i in 0..<f.len: f[i] = -f[i]
                for i in 1..<g.len: g[i] = -g[i]
            let savedF = f
            let savedG = g
            doAssert f.compose(g, n) == naiveCompose(f, g, n)
            doAssert f == savedF and g == savedG
            doAssert f.compose(g) == naiveCompose(f, g, f.len)
        doAssert newSeq[T](0).compose(newSeq[T](0), n) == newSeq[T](max(0, n))
    for repetition in 0..<80:
        let n = rng.rand(1..90)
        var f = newSeq[T](rng.rand(0..110))
        var g = newSeq[T](rng.rand(0..110))
        for i in 0..<f.len: f[i] = init(T, rng.rand(T.umod.int - 1))
        for i in 1..<g.len: g[i] = init(T, rng.rand(T.umod.int - 1))
        doAssert f.compose(g, n) == naiveCompose(f, g, n)
    for n in [511, 512, 513, 1023, 1024, 1025, 4095, 4096, 4097]:
        var f, g, weight = newSeq[T](n)
        for i in 0..<n:
            f[i] = init(T, rng.rand(T.umod.int - 1))
            weight[n - 1 - i] = init(T, rng.rand(T.umod.int - 1))
            if i > 0: g[i] = init(T, rng.rand(T.umod.int - 1))
        let composed = f.compose(g, n)
        let projected = g.powerProjection(weight, n - 1)
        var left, right = init(T, 0)
        for i in 0..<n:
            left += composed[i] * weight[n - 1 - i]
            right += f[i] * projected[i]
        doAssert left == right
    var rejected = false
    try:
        discard @[init(T, 1), init(T, 2)].compose(@[init(T, 1)], 2)
    except AssertionDefect:
        rejected = true
    doAssert rejected

suite[modint998244353_barrett](11)
suite[modint998244353_montgomery](17)
suite[modint1000000007_barrett](19)
suite[modint1000000007_montgomery](23)
suite[StaticBarrettModint[9u32]](29)
suite[StaticBarrettModint[97u32]](31)
suite[StaticBarrettModint[257u32]](33)
suite[StaticMontgomeryModint[257u32]](35)
modint_barrett.setMod(998244353)
suite[modint_barrett](37)
modint_barrett.setMod(1000000007)
suite[modint_barrett](41)
modint_montgomery.setMod(998244353)
suite[modint_montgomery](43)
modint_montgomery.setMod(167772161)
suite[modint_montgomery](45)
modint_montgomery.setMod(1000000007)
suite[modint_montgomery](47)
echo "Hello World"
