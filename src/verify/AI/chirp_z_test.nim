# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import random, sequtils
import cplib/fps/chirp_z
import cplib/fps/product_tree
import cplib/modint/modint

var checks = 0
proc check[T: BarrettModint or MontgomeryModint](f: seq[T], a, r: T, m: int) =
    let saved = f.mapIt(it.val)
    var xs = newSeq[T](m)
    var expected = newSeq[T](m)
    var x = a
    for i in 0..<m:
        xs[i] = x
        for j in countdown(f.high, 0): expected[i] = expected[i] * x + f[j]
        x *= r
    let actual = multipointEvaluationGeometric(f, a, r, m)
    doAssert actual == expected, $T & " n=" & $f.len & " m=" & $m & " a=" & $a & " r=" & $r
    if T.umod != 1: doAssert actual == multipointEvaluation(f, xs)
    doAssert chirpZ(f, r, m, a) == expected
    if a == init(T, 1): doAssert chirpZ(f, r, m) == expected
    doAssert f.mapIt(it.val) == saved
    inc checks

proc run[T: BarrettModint or MontgomeryModint]() =
    var rng = initRand(20261002)
    for n in [0, 1, 2, 59, 60, 61, 63, 64, 65, 127, 129]:
        var f = newSeq[T](n)
        for j in 0..<n: f[j] = init(T, rng.rand(T.umod.int - 1))
        for m in [0, 1, 2, 7, 61, 65, 129]:
            for r in [0, 1, -1, 2, 3]:
                check(f, init(T, 7), init(T, r), m)
            check(f, init(T, 0), init(T, 2), m)
            check(f, init(T, 1), init(T, 2), m)
    for trial in 0..<40:
        let n = rng.rand(257)
        let m = rng.rand(257)
        var f = newSeq[T](n)
        for j in 0..<n:
            f[j] = init(T, if trial mod 5 == 0: 0 else: rng.rand(T.umod.int - 1))
        check(f, init(T, rng.rand(T.umod.int - 1)), init(T, rng.rand(T.umod.int - 1)), m)
    let large = @[init(T, high(int)), init(T, low(int)), init(T, 0), init(T, high(int) - 17)]
    check(large, init(T, high(int)), init(T, low(int)), 67)
    check(large, init(T, low(int)), init(T, high(int)), 67)

proc exhaustive[T: BarrettModint or MontgomeryModint](maxN: int) =
    let p = T.umod.int
    var count = 1
    for n in 0..maxN:
        for encoded in 0..<count:
            var f = newSeq[T](n)
            var code = encoded
            for j in 0..<n:
                f[j] = init(T, code mod p)
                code = code div p
            for a in 0..<p:
                for r in 0..<p:
                    for m in 0..4: check(f, init(T, a), init(T, r), m)
        count *= p

declarStaticBarrettModint(Mint3, 3u32)
declarStaticMontgomeryModint(Mint5, 5u32)
declarStaticBarrettModint(CompositeBarrett, 129u32)
declarStaticMontgomeryModint(CompositeMontgomery, 129u32)
exhaustive[Mint3](3)
exhaustive[Mint5](2)
run[modint998244353_barrett]()
run[modint998244353_montgomery]()
run[modint1000000007_barrett]()
run[modint1000000007_montgomery]()
run[CompositeBarrett]()
run[CompositeMontgomery]()
for modulus in [17, 998244353, 129, 1000000007, 9, 17]:
    modint_barrett.setMod(modulus)
    modint_montgomery.setMod(modulus)
    run[modint_barrett]()
    run[modint_montgomery]()
modint_barrett.setMod(1)
check(@[init(modint_barrett, 7), init(modint_barrett, 9)], init(modint_barrett, 3), init(modint_barrett, 2), 5)
doAssert checks == 16134
echo "Hello World"
