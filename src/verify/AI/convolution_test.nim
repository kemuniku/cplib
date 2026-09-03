# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import sequtils
import cplib/convolution/convolution
import cplib/convolution/relaxed_convolution
import cplib/convolution/semi_relaxed_convolution
import cplib/modint/modint

assert convolution_ll(@[1, 2, 3], @[4, 5]) == @[4, 13, 22, 15]

type Mint = modint998244353_barrett
let f = @[Mint(1), Mint(2), Mint(3)]
let g = @[Mint(4), Mint(5)]
assert convolution_naive(f, g).mapIt(it.val) == @[4, 13, 22, 15]
assert convolution(f, g).mapIt(it.val) == @[4, 13, 22, 15]

proc checkCyclicConvolution[T: BarrettModint or MontgomeryModint](M: typedesc[T]) =
  const n = 128
  var a = newSeq[T](n)
  var b = newSeq[T](73)
  for i in 0..<a.len: a[i] = T(i * 1_000_003 + 17)
  for i in 0..<b.len: b[i] = T(i * 999_983 + 31)
  let product = convolution_naive(a, b)
  var expected = newSeq[T](n)
  for i in 0..<product.len: expected[i mod n] += product[i]
  let actual = convolutionCyclicPowerOfTwo(a, b, n)
  for i in 0..<n:
    doAssert actual[i].val == expected[i].val,
      $M & " " & $i & " " & $actual[i].val & " " & $expected[i].val

checkCyclicConvolution(modint998244353_barrett)
checkCyclicConvolution(modint998244353_montgomery)
checkCyclicConvolution(modint1000000007_barrett)
checkCyclicConvolution(modint1000000007_montgomery)

proc checkRelaxedConvolution[T: BarrettModint or MontgomeryModint](
    M: typedesc[T], n: int) =
  var a = newSeq[T](n)
  var b = newSeq[T](n)
  for i in 0..<n:
    a[i] = T(i * i * 17 + i * 31 + 9)
    b[i] = T(i * i * 13 + i * 29 + 7)
  let expected = convolution_naive(a, b)
  var relaxed = initRelaxedConvolution[T](n)
  for i in 0..<n:
    var pending = init(T, 0)
    for j in 1..<i: pending += a[j] * b[i - j]
    doAssert relaxed.pendingCoefficient.val == pending.val,
      $M & " " & $n & " " & $i
    doAssert relaxed.add(a[i], b[i]).val == expected[i].val,
      $M & " " & $n & " " & $i
  let actual = relaxed.coefficients
  for i in 0..<n:
    doAssert actual[i].val == expected[i].val, $M & " " & $n & " " & $i

proc checkSemiRelaxedConvolution[T: BarrettModint or MontgomeryModint](
    M: typedesc[T], fixedCount, onlineCount: int) =
  var fixed = newSeq[T](fixedCount)
  var online = newSeq[T](onlineCount)
  for i in 0..<fixed.len:
    fixed[i] = T(i * i * 19 + i * 37 + 11)
  for i in 0..<online.len:
    online[i] = T(i * i * 23 + i * 41 + 13)
  let expected = convolution_naive(fixed, online)
  var relaxed = initSemiRelaxedConvolution[T](fixed)
  for i in 0..<online.len:
    let expectedValue = if i < expected.len: expected[i].val else: 0
    doAssert relaxed.add(online[i]).val == expectedValue,
      $M & " " & $fixedCount & " " & $onlineCount & " " & $i
  let actual = relaxed.coefficients
  for i in 0..<online.len:
    let expectedValue = if i < expected.len: expected[i].val else: 0
    doAssert actual[i].val == expectedValue,
      $M & " " & $fixedCount & " " & $onlineCount & " " & $i

for n in [1, 2, 3, 7, 16, 17, 31, 32, 33, 63, 64, 65, 127, 128, 129, 257]:
  checkRelaxedConvolution(modint998244353_barrett, n)
  checkSemiRelaxedConvolution(modint998244353_barrett, n, n)
checkRelaxedConvolution(modint998244353_montgomery, 130)
checkSemiRelaxedConvolution(modint998244353_montgomery, 130, 130)
checkRelaxedConvolution(modint1000000007_barrett, 130)
checkSemiRelaxedConvolution(modint1000000007_barrett, 130, 130)
checkRelaxedConvolution(modint1000000007_montgomery, 130)
checkSemiRelaxedConvolution(modint1000000007_montgomery, 130, 130)
checkSemiRelaxedConvolution(modint998244353_barrett, 17, 70)
checkSemiRelaxedConvolution(modint998244353_barrett, 70, 17)
checkSemiRelaxedConvolution(modint998244353_barrett, 0, 20)

proc checkArbitraryMod[T: BarrettModint or MontgomeryModint](M: typedesc[T]) =
  var a = newSeq[T](61)
  var b = newSeq[T](73)
  for i in 0..<a.len: a[i] = T(i * 1_000_003 + 998_241)
  for i in 0..<b.len: b[i] = T(i * 999_983 + 123_457)
  assert convolution(a, b).mapIt(it.val) ==
    convolution_naive(a, b).mapIt(it.val)

checkArbitraryMod(modint1000000007_barrett)
checkArbitraryMod(modint1000000007_montgomery)

type DynamicBarrett = modint_barrett
DynamicBarrett.setMod(1_000_000_007)
checkArbitraryMod(DynamicBarrett)

type DynamicMontgomery = modint_montgomery
DynamicMontgomery.setMod(1_000_000_007)
checkArbitraryMod(DynamicMontgomery)

proc convolutionNaiveMod[m: static[int]](a, b: seq[int]): seq[int] =
  if a.len == 0 or b.len == 0: return @[]
  result = newSeq[int](a.len + b.len - 1)
  for i in 0..<a.len:
    let ai = ((a[i] mod m) + m) mod m
    for j in 0..<b.len:
      let bj = ((b[j] mod m) + m) mod m
      result[i + j] = ((result[i + j].int64 + ai.int64 * bj.int64) mod
        m.int64).int

assert convolution[1_000_000_007](@[1, -2, 3], @[4, 5]) ==
  @[4, 1_000_000_004, 2, 15]
assert convolution[1](@[1, -2, 3], @[4, 5]) == @[0, 0, 0, 0]
assert convolution[1_000_000_007](newSeq[int](), @[1, 2]) == @[]
var intA = newSeq[int](67)
var intB = newSeq[int](79)
for i in 0..<intA.len: intA[i] = i * 1_000_003 - 50_000_007
for i in 0..<intB.len: intB[i] = i * 999_983 - 30_000_011
assert convolution[1_000_000_007](intA, intB) ==
  convolutionNaiveMod[1_000_000_007](intA, intB)
assert convolution[998_244_353](intA, intB) ==
  convolutionNaiveMod[998_244_353](intA, intB)
