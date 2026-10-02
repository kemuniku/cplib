# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sequtils
import cplib/modint/modint
import cplib/convolution/set_transform
import cplib/convolution/bitwise_or_convolution
import cplib/convolution/subset_convolution
import cplib/convolution/bitwise_and_convolution
import cplib/convolution/xor_convolution
import cplib/set_power_series/set_power_series

proc naive[T](a, b: seq[T]): seq[T] =
    result = newSeq[T](a.len)
    for mask in 0..<a.len:
        var sub = mask
        while true:
            result[mask] += a[sub] * b[mask xor sub]
            if sub == 0: break
            sub = (sub - 1) and mask

proc naivePow[T](a: seq[T], e: int): seq[T] =
    result = newSeq[T](a.len)
    result[0] = init(T, 1)
    for k in 0..<e: result = naive(result, a)

proc naiveInv[T](a: seq[T]): seq[T] =
    result = newSeq[T](a.len)
    result[0] = a[0].inv
    for mask in 1..<a.len:
        var sub = mask
        while sub > 0:
            result[mask] -= a[sub] * result[mask xor sub]
            sub = (sub - 1) and mask
        result[mask] *= result[0]

proc naiveSqrt[T](a: seq[T], root: T): seq[T] =
    result = newSeq[T](a.len)
    result[0] = root
    for mask in 1..<a.len:
        var sum = init(T, 0)
        var sub = (mask - 1) and mask
        while sub > 0:
            sum += result[sub] * result[mask xor sub]
            sub = (sub - 1) and mask
        result[mask] = (a[mask] - sum) / (root * 2)

proc naiveBinaryPower[T](a: seq[T], exponent: uint): seq[T] =
    result = newSeq[T](a.len)
    result[0] = init(T, 1)
    var base = a
    var e = exponent
    while e > 0:
        if (e and 1) != 0: result = naive(result, base)
        e = e shr 1
        if e > 0: base = naive(base, base)

proc check[T](a, b: seq[T], n: int) =
    let original = a
    var orOracle = newSeq[T](a.len)
    for i in 0..<a.len:
        for j in 0..<a.len: orOracle[i or j] += a[i] * b[j]
    doAssert bitwiseOrConvolution(a, b) == orOracle
    var subset = a
    var superset = a
    subsetZetaTransform(subset)
    supersetZetaTransform(superset)
    subsetMobiusTransform(subset)
    supersetMobiusTransform(superset)
    doAssert subset == a and superset == a
    doAssert subsetConvolution(a, b) == naive(a, b)
    doAssert subsetConvolution(a, a) == naive(a, a)
    var f = newSeq[T](n + 8)
    for k in 0..<f.len: f[k] = init(T, k * k + 3)
    let actual = polynomialCompositeSetPowerSeries(f, a)
    var expected = newSeq[T](a.len)
    for k in 0..<f.len:
        let power = naivePow(a, k)
        for mask in 0..<a.len: expected[mask] += power[mask] * f[k]
    doAssert actual == expected
    let projection = setPowerProjection(a, b, f.len)
    for k in 0..<f.len:
        let power = naivePow(a, k)
        var dot = init(T, 0)
        for mask in 0..<a.len: dot += power[mask] * b[mask]
        doAssert projection[k] == dot
    var lhs, rhs = init(T, 0)
    for mask in 0..<a.len: lhs += b[mask] * actual[mask]
    for k in 0..<f.len: rhs += f[k] * projection[k]
    doAssert lhs == rhs
    doAssert polynomialCompositeSetPowerSeries(newSeq[T](), a) == newSeq[T](a.len)
    doAssert setPowerProjection(a, b, 0).len == 0
    for e in [0, 1, 2, n, n + 2]: doAssert setPow(a, e) == naivePow(a, e)
    var unit = a
    unit[0] = init(T, 1)
    doAssert setInv(unit) == naiveInv(unit)
    doAssert setPow(unit, -3) == naivePow(naiveInv(unit), 3)
    var identity = newSeq[T](a.len)
    identity[0] = init(T, 1)
    doAssert naive(setPow(unit, low(int)), setPow(unit, high(int))) == naiveInv(unit)
    doAssert setPow(a, high(int)) == naiveBinaryPower(a, uint(high(int)))
    doAssert setPow(unit, low(int)) == naiveBinaryPower(naiveInv(unit), uint(high(int)) + 1u)
    if T.umod.int > n and T.umod.int > 2:
        var nilpotent = a
        nilpotent[0] = init(T, 0)
        let exp = setExp(nilpotent)
        var expOracle = identity
        var factInv = init(T, 1)
        for k in 1..n:
            factInv /= k
            let power = naivePow(nilpotent, k)
            for mask in 0..<a.len: expOracle[mask] += power[mask] * factInv
        doAssert exp == expOracle
        doAssert setLog(exp) == nilpotent
        doAssert setExp(setLog(unit)) == unit
        var logOracle = newSeq[T](a.len)
        var delta = unit
        delta[0] = init(T, 0)
        for k in 1..n:
            let power = naivePow(delta, k)
            let factor = init(T, (if k mod 2 == 1: 1 else: -1)) / init(T, k)
            for mask in 0..<a.len: logOracle[mask] += power[mask] * factor
        doAssert setLog(unit) == logOracle
        let squared = naive(unit, unit)
        doAssert setSqrt(squared, init(T, 1)) == unit
        doAssert setSqrt(unit, init(T, 1)) == naiveSqrt(unit, init(T, 1))
        let opposite = setSqrt(squared, init(T, -1))
        for mask in 0..<a.len: doAssert opposite[mask] == -unit[mask]
    doAssert setSqrt(newSeq[T](a.len), init(T, 0)) == newSeq[T](a.len)
    doAssert a == original

for n in 0..3:
    let size = 1 shl n
    for encoding in 0..<(1 shl size):
        let a = (0..<size).toSeq.mapIt((encoding shr it) and 1)
        var subset, superset = a
        subsetZetaTransform(subset)
        supersetZetaTransform(superset)
        for mask in 0..<size:
            var lo, hi = 0
            for sub in 0..<size:
                if (mask and sub) == sub: lo += a[sub]
                if (mask and sub) == mask: hi += a[sub]
            doAssert subset[mask] == lo and superset[mask] == hi
        subsetMobiusTransform(subset)
        supersetMobiusTransform(superset)
        doAssert subset == a and superset == a
        var expectedOr, expectedAnd, expectedXor = newSeq[int](size)
        for i in 0..<size:
            for j in 0..<size:
                expectedOr[i or j] += a[i] * a[j]
                expectedAnd[i and j] += a[i] * a[j]
                expectedXor[i xor j] += a[i] * a[j]
        doAssert bitwiseOrConvolution(a, a) == expectedOr
        doAssert bitwiseAndConvolution(a, a) == expectedAnd
        doAssert xorConvolution(a, a) == expectedXor
        doAssert subsetConvolution(a, a) == naive(a, a)

var rng = initRand(20261002)
for n in 0..6:
    for trial in 0..<8:
        let a = newSeqWith(1 shl n, rng.rand(0..100))
        let b = newSeqWith(1 shl n, rng.rand(0..100))
        check(a.mapIt(init(modint998244353_barrett, it)), b.mapIt(init(modint998244353_barrett, it)), n)
        check(a.mapIt(init(modint998244353_montgomery, it)), b.mapIt(init(modint998244353_montgomery, it)), n)
        modint_barrett.setMod(998244353)
        check(a.mapIt(init(modint_barrett, it)), b.mapIt(init(modint_barrett, it)), n)
        modint_montgomery.setMod(998244353)
        check(a.mapIt(init(modint_montgomery, it)), b.mapIt(init(modint_montgomery, it)), n)

for modulus in [2, 3, 5, 9]:
    modint_barrett.setMod(modulus)
    for code in 0..<81:
        var a = newSeq[modint_barrett](4)
        var value = code
        for mask in 0..<4:
            a[mask] = init(modint_barrett, value mod 3)
            value = value div 3
        # 小標数・合成数法では除算を含まない演算と単元の逆元を確認する。
        for e in 0..5: doAssert setPow(a, e) == naivePow(a, e)
        doAssert setPowerProjection(a, a, 7).len == 7
        var polynomial = @[init(modint_barrett, 2), init(modint_barrett, 1), init(modint_barrett, 2), init(modint_barrett, 1)]
        var expected = newSeq[modint_barrett](4)
        for e in 0..<polynomial.len:
            let power = naivePow(a, e)
            for mask in 0..<4: expected[mask] += polynomial[e] * power[mask]
        doAssert polynomialCompositeSetPowerSeries(polynomial, a) == expected
        let projected = setPowerProjection(a, a, 7)
        for e in 0..<7:
            let power = naivePow(a, e)
            var dot = init(modint_barrett, 0)
            for mask in 0..<4: dot += a[mask] * power[mask]
            doAssert projected[e] == dot
        a[0] = init(modint_barrett, 1)
        doAssert setInv(a) == naiveInv(a)
        doAssert setPow(a, -2) == naivePow(naiveInv(a), 2)
        if modulus mod 2 == 1: doAssert setSqrt(naive(a, a), init(modint_barrett, 1)) == a

template rejects(body: untyped) =
    block:
        var rejected = false
        try: body
        except AssertionDefect: rejected = true
        doAssert rejected

var empty = newSeq[int]()
subsetZetaTransform(empty)
subsetMobiusTransform(empty)
supersetZetaTransform(empty)
supersetMobiusTransform(empty)
doAssert subsetConvolution(empty, empty).len == 0
doAssert bitwiseOrConvolution(empty, empty).len == 0
var invalid = @[1, 2, 3]
rejects(subsetZetaTransform(invalid))
rejects(subsetMobiusTransform(invalid))
rejects(supersetZetaTransform(invalid))
rejects(supersetMobiusTransform(invalid))
rejects:
    discard subsetConvolution(@[1], @[1, 2])
rejects:
    discard subsetConvolution(invalid, invalid)
rejects:
    discard bitwiseOrConvolution(@[1], @[1, 2])
rejects:
    discard bitwiseOrConvolution(invalid, invalid)
type mint = modint998244353_barrett
let one = init(mint, 1)
let zero = init(mint, 0)
rejects:
    discard setExp(newSeq[mint]())
rejects:
    discard setInv(@[one, one, one])
rejects:
    discard setExp(@[one])
rejects:
    discard setLog(@[zero])
rejects:
    discard setInv(@[zero])
rejects:
    discard setPow(@[zero, one], -1)
rejects:
    discard setSqrt(@[zero, one], zero)
rejects:
    discard setSqrt(@[one], zero)
rejects:
    discard setPowerProjection(@[one], @[one], -1)
rejects:
    discard setPowerProjection(@[one], newSeq[mint](), 0)
modint_barrett.setMod(9)
rejects:
    discard setInv(@[init(modint_barrett, 3)])
rejects:
    discard setExp(@[init(modint_barrett, 0)])
modint_barrett.setMod(2)
rejects:
    discard setExp(newSeq[modint_barrett](4))
rejects:
    discard setSqrt(@[init(modint_barrett, 1)], init(modint_barrett, 1))
echo "Hello World"
