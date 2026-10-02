# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import sequtils
import cplib/fps/product_tree
import cplib/convolution/convolution
import cplib/modint/modint

declarStaticBarrettModint(Mint257, 257u32)
declarStaticMontgomeryModint(MintNearLimit, 1073692673u32)

proc check[T: BarrettModint or MontgomeryModint](
    M: typedesc[T], n, m, mode: int, primitive: int) =
    var size = 1
    while size < m: size *= 2
    let supports = (T.umod.int - 1) mod size == 0
    let root = if supports: init(T, primitive).pow(
        (T.umod.int - 1) div size) else: init(T, 1)
    var f = newSeq[T](n)
    var xs = newSeq[T](m)
    for i in 0..<n:
        f[i] = init(T, i * i * 13 + i * 31 + 19)
        if i mod 3 == 0: f[i] = init(T, -1 - i)
        if mode == 3: f[i] = init(T, 0)
    for i in 0..<m:
        case mode
        of 0: xs[i] = root.pow(i)
        of 1: xs[i] = root.pow(i mod 3)
        of 2:
            xs[i] = if i mod 3 == 0: init(T, 0)
                elif i mod 3 == 1: root.pow(i) else: init(T, i + 2)
        else: xs[i] = init(T, -1)
    let savedF = f.mapIt(it.val)
    let savedXs = xs.mapIt(it.val)
    let actual = multipointEvaluation(f, xs)
    doAssert actual == multipointEvaluation(f, xs)
    doAssert f.mapIt(it.val) == savedF
    doAssert xs.mapIt(it.val) == savedXs
    doAssert actual.len == m
    for i in 0..<m:
        var expected = init(T, 0)
        for j in countdown(n - 1, 0):
            expected = expected * xs[i] + f[j]
        doAssert actual[i] == expected,
            $M & " n=" & $n & " m=" & $m & " mode=" & $mode & " i=" & $i

proc run[T: BarrettModint or MontgomeryModint](
    M: typedesc[T], primitive: int) =
    for m in [0, 1, 15, 16, 17, 31, 32, 33, 63, 64, 65,
        127, 128, 129, 255, 256, 257]:
        for n in [0, 1, 17, max(0, m - 1), m, m + 1, 2 * m + 1]:
            for mode in 0..3:
                check(M, n, m, mode, primitive)
    var a = newSeq[T](65)
    var b = newSeq[T](73)
    for i in 0..<a.len: a[i] = init(T, -1 - i * 999983)
    for i in 0..<b.len: b[i] = init(T, -1 - i * 1000003)
    doAssert convolution(a, b) == convolution_naive(a, b)
    let product = convolution_naive(a, b)
    var cyclic = newSeq[T](128)
    for i in 0..<product.len: cyclic[i mod 128] += product[i]
    doAssert convolutionCyclicPowerOfTwo(a, b, 128) == cyclic

run(modint998244353_barrett, 3)
run(modint998244353_montgomery, 3)
run(Mint257, 3)
run(MintNearLimit, 3)
run(modint1000000007_barrett, 5)
for modulus in [998244353, 257, 1000000007, 17, 998244353]:
    modint_barrett.setMod(modulus)
    modint_montgomery.setMod(modulus)
    run(modint_barrett, 3)
    run(modint_montgomery, 3)
echo "Hello World"
