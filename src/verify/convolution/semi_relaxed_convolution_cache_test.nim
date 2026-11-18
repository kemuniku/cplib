# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/convolution/semi_relaxed_convolution
import cplib/modint/modint

var randomState = 0x123456789abcdefu64
proc nextValue(modulus: int): int =
    randomState = randomState xor (randomState shl 13)
    randomState = randomState xor (randomState shr 7)
    randomState = randomState xor (randomState shl 17)
    int(randomState mod modulus.uint64)

proc expectedCoefficient(fixed, online: seq[int], index, modulus: int): int =
    for i in 0..<min(fixed.len, index + 1):
        result = ((result.int64 + fixed[i].int64 * online[index - i].int64) mod
            modulus.int64).int

proc check[T: BarrettModint or MontgomeryModint](M: typedesc[T],
        fixedCount, onlineCount, pattern: int) =
    let modulus = T.umod.int
    var fixed = newSeq[T](fixedCount)
    var fixedValues = newSeq[int](fixedCount)
    for i in 0..<fixedCount:
        fixedValues[i] = case pattern
            of 0: nextValue(modulus)
            of 1: 0
            else: modulus - 1
        fixed[i] = init(T, fixedValues[i])
    var solver = initSemiRelaxedConvolution(fixed)
    for value in fixed.mitems: value = init(T, 0)
    var online = newSeq[int]()
    for i in 0..<onlineCount:
        online.add(nextValue(modulus))
        let actual = if i mod 3 == 0: solver.add(init(T, online[^1]))
            elif i mod 3 == 1: solver.append(init(T, online[^1]))
            else: solver.get(init(T, online[^1]))
        doAssert actual.val == expectedCoefficient(fixedValues, online, i, modulus),
            $M & " " & $fixedCount & " " & $onlineCount & " " & $i
    doAssert solver.len == onlineCount
    var coefficients = solver.coefficients
    for i in 0..<onlineCount:
        doAssert coefficients[i].val == expectedCoefficient(fixedValues, online, i, modulus)
    if coefficients.len > 0: coefficients[0] = init(T, 0)
    let unchanged = solver.coefficients
    for i in 0..<onlineCount:
        doAssert unchanged[i].val == expectedCoefficient(fixedValues, online, i, modulus)

proc checkCopies[T: BarrettModint or MontgomeryModint](M: typedesc[T]) =
    let modulus = T.umod.int
    var fixed = newSeq[T](300)
    var fixedValues = newSeq[int](fixed.len)
    var online = newSeq[int]()
    for i in 0..<fixed.len:
        fixedValues[i] = nextValue(modulus)
        fixed[i] = init(T, fixedValues[i])
    var original = initSemiRelaxedConvolution(fixed)
    for i in 0..<130:
        online.add(nextValue(modulus))
        doAssert original.add(init(T, online[^1])).val ==
            expectedCoefficient(fixedValues, online, i, modulus)
    var copied = original
    var copiedOnline = online
    GC_fullCollect()
    for i in 130..<260:
        online.add(nextValue(modulus))
        copiedOnline.add(nextValue(modulus))
        doAssert original.add(init(T, online[^1])).val ==
            expectedCoefficient(fixedValues, online, i, modulus)
        doAssert copied.add(init(T, copiedOnline[^1])).val ==
            expectedCoefficient(fixedValues, copiedOnline, i, modulus)
    var moved = move(copied)
    original = initSemiRelaxedConvolution(newSeq[T]())
    GC_fullCollect()
    for i in 260..<390:
        copiedOnline.add(nextValue(modulus))
        doAssert moved.add(init(T, copiedOnline[^1])).val ==
            expectedCoefficient(fixedValues, copiedOnline, i, modulus)
    moved = initSemiRelaxedConvolution(newSeq[T]())
    GC_fullCollect()

for n in [0, 1, 16, 17, 31, 32, 33, 60, 61, 62, 63, 64, 65,
        122, 123, 124, 125, 126, 127, 128, 129, 254, 255, 256, 257, 511, 512, 513]:
    check(modint998244353_barrett, n, n + 3, 0)
    check(modint998244353_montgomery, n, n + 3, 0)
for fixedCount in [0, 1, 16, 17, 62, 63, 64, 123, 124, 125, 126, 127, 128, 189, 190, 191, 300]:
    check(modint998244353_barrett, fixedCount, 513, 0)
    check(modint998244353_montgomery, fixedCount, 513, 0)
for pattern in 1..2:
    check(modint998244353_barrett, 300, 513, pattern)
    check(modint998244353_montgomery, 300, 513, pattern)
check(modint1000000007_barrett, 300, 513, 0)
check(modint1000000007_montgomery, 300, 513, 0)
type CompositeBarrett = StaticBarrettModint[129u32]
type CompositeMontgomery = StaticMontgomeryModint[129u32]
check(CompositeBarrett, 300, 513, 0)
check(CompositeMontgomery, 300, 513, 0)
checkCopies(modint998244353_barrett)
checkCopies(modint998244353_montgomery)
for modulus in [998244353, 469762049, 167772161, 1000000007, 129, 17, 998244353]:
    modint_barrett.setMod(modulus)
    modint_montgomery.setMod(modulus)
    check(modint_barrett, 300, 513, 0)
    check(modint_montgomery, 300, 513, 0)
    checkCopies(modint_barrett)
    checkCopies(modint_montgomery)

proc checkInterleaved() =
    type OtherMint = StaticBarrettModint[469762049u32]
    var fixedA = newSeq[modint998244353_barrett](300)
    var fixedB = newSeq[OtherMint](300)
    var fixedC = newSeq[modint1000000007_montgomery](300)
    var fixedValues = newSeq[int](300)
    for i in 0..<300:
        fixedValues[i] = nextValue(469762049)
        fixedA[i] = init(modint998244353_barrett, fixedValues[i])
        fixedB[i] = init(OtherMint, fixedValues[i])
        fixedC[i] = init(modint1000000007_montgomery, fixedValues[i])
    var a = initSemiRelaxedConvolution(fixedA)
    var b = initSemiRelaxedConvolution(fixedB)
    var c = initSemiRelaxedConvolution(fixedC)
    var online = newSeq[int]()
    for i in 0..<513:
        online.add(nextValue(469762049))
        doAssert a.add(init(modint998244353_barrett, online[^1])).val ==
            expectedCoefficient(fixedValues, online, i, 998244353)
        doAssert b.add(init(OtherMint, online[^1])).val ==
            expectedCoefficient(fixedValues, online, i, 469762049)
        doAssert c.add(init(modint1000000007_montgomery, online[^1])).val ==
            expectedCoefficient(fixedValues, online, i, 1000000007)

checkInterleaved()
GC_fullCollect()
echo "Hello World"
