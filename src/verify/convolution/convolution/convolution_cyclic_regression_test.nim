# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import random
import cplib/convolution/convolution
import cplib/modint/modint

proc suite[T](seed: int) =
    var rng = initRand(seed)
    for n in [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024]:
        for repetition in 0..<12:
            let lengths = [0, 1, max(0, n div 2 - 1), n div 2,
                           min(n, n div 2 + 1), max(0, n - 1), n]
            let flen = (if repetition < lengths.len: lengths[repetition]
                        else: rng.rand(0..n))
            let glen = (if repetition < lengths.len: lengths[^(repetition + 1)]
                        else: rng.rand(0..n))
            var f = newSeq[T](flen)
            var g = newSeq[T](glen)
            for i in 0..<flen: f[i] = init(T, rng.rand(0..T.umod.int - 1))
            for i in 0..<glen: g[i] = init(T, rng.rand(0..T.umod.int - 1))
            let savedF = f
            let savedG = g
            var expected = newSeq[T](n)
            for i in 0..<flen:
                for j in 0..<glen: expected[(i + j) mod n] += f[i] * g[j]
            doAssert convolutionCyclicPowerOfTwo(f, g, n) == expected
            doAssert f == savedF and g == savedG
        var full = newSeq[T](n)
        for i in 0..<n: full[i] = init(T, T.umod.int - 1 - i mod 3)
        var expected = newSeq[T](n)
        for i in 0..<n:
            for j in 0..<n: expected[(i + j) mod n] += full[i] * full[j]
        doAssert convolutionCyclicPowerOfTwo(full, full, n) == expected
        doAssert convolutionCyclicPowerOfTwo(@[init(T, 3)], @[init(T, 7)], n)[0] == init(T, 21)

suite[modint998244353_barrett](11)
suite[modint998244353_montgomery](17)
suite[StaticBarrettModint[167772161u32]](19)
suite[StaticMontgomeryModint[167772161u32]](23)
suite[modint1000000007_barrett](29)
suite[modint1000000007_montgomery](31)
modint_barrett.setMod(998244353)
suite[modint_barrett](37)
modint_barrett.setMod(1000000007)
suite[modint_barrett](41)
modint_montgomery.setMod(998244353)
suite[modint_montgomery](43)
modint_montgomery.setMod(1000000007)
suite[modint_montgomery](47)
echo "Hello World"
