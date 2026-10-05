# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/fps/polynomial_interpolation
import cplib/modint/modint
import sequtils

type Mint257 = StaticBarrettModint[257u32]
type Mint9 = StaticBarrettModint[9u32]
type Montgomery9 = StaticMontgomeryModint[9u32]
type MintComposite = StaticBarrettModint[1022117u32]
type MontgomeryComposite = StaticMontgomeryModint[1022117u32]

proc check[T: BarrettModint or MontgomeryModint](M: typedesc[T], n, mode: int) =
    let modulus = T.umod.int64
    var coefficients = newSeq[T](n)
    var expected = newSeq[int64](n)
    var xs = newSeq[T](n)
    var ys = newSeq[T](n)
    var size = 1
    while size < n: size *= 2
    let useRoots = mode == 2 and modulus.int in [998244353, 257, 17] and size < modulus.int and
        (modulus.int - 1) mod size == 0
    let root = if useRoots: init(T, 3).pow((modulus.int - 1) div size)
        else: init(T, 1)
    for i in 0..<n:
        expected[i] = if mode == 3: 0i64 else: (i.int64 * i.int64 * 37 + 19) mod modulus
        coefficients[i] = init(T, expected[i])
        xs[i] = if useRoots: root.pow(i)
            elif mode == 1: init(T, n - 1 - i) else: init(T, i)
    for i in 0..<n:
        var y = 0i64
        for j in countdown(n - 1, 0):
            y = (y * xs[i].val.int64 + expected[j]) mod modulus
        ys[i] = init(T, y)
    let savedXs = xs.mapIt(it.val)
    let savedYs = ys.mapIt(it.val)
    let actual = polynomialInterpolation(xs, ys)
    doAssert actual == coefficients,
        $M & " n=" & $n & " mode=" & $mode
    doAssert xs.mapIt(it.val) == savedXs
    doAssert ys.mapIt(it.val) == savedYs
    doAssert actual == polynomialInterpolation(xs, ys)

proc run[T: BarrettModint or MontgomeryModint](M: typedesc[T], maxN: int) =
    for n in [0, 1, 2, 3, 7, 15, 16, 17, 31, 32, 33,
        63, 64, 65, 127, 128, 129, 255, 256, 257]:
        if n <= maxN:
            for mode in 0..3: check(M, n, mode)

proc checkInvalid[T: BarrettModint or MontgomeryModint](M: typedesc[T]) =
    var caught = false
    try:
        discard polynomialInterpolation(@[init(T, 0)], newSeq[T](0))
    except AssertionDefect:
        caught = true
    doAssert caught
    caught = false
    try:
        discard polynomialInterpolation(@[init(T, 1), init(T, 1)],
            @[init(T, 0), init(T, 1)])
    except AssertionDefect:
        caught = true
    doAssert caught
    for n in [64, 65]:
        var xs = newSeq[T](n)
        for i in 0..<n: xs[i] = init(T, i)
        xs[^1] = xs[0]
        caught = false
        try:
            discard polynomialInterpolation(xs, newSeq[T](n))
        except AssertionDefect:
            caught = true
        doAssert caught

run(modint998244353_barrett, 257)
run(modint998244353_montgomery, 257)
run(modint1000000007_barrett, 129)
run(modint1000000007_montgomery, 129)
run(Mint257, 257)
run(Mint9, 3)
run(Montgomery9, 3)
run(MintComposite, 129)
run(MontgomeryComposite, 129)
checkInvalid(modint998244353_barrett)
checkInvalid(modint998244353_montgomery)
checkInvalid(Mint9)
for modulus in [998244353, 9, 17, 25, 15, 1022117, 998244353]:
    modint_barrett.setMod(modulus)
    modint_montgomery.setMod(modulus)
    let maxN = if modulus == 9 or modulus == 15: 3
        elif modulus == 25: 3 else: min(129, modulus)
    run(modint_barrett, maxN)
    run(modint_montgomery, maxN)
    checkInvalid(modint_barrett)
    checkInvalid(modint_montgomery)
modint_barrett.setMod(8)
run(modint_barrett, 2)
echo "Hello World"
