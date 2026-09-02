# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import sequtils
import cplib/convolution/convolution_old
import cplib/modint/modint

assert convolution_ll(@[1, 2, 3], @[4, 5]) == @[4, 13, 22, 15]

type Mint = modint998244353_barrett
let f = @[Mint(1), Mint(2), Mint(3)]
let g = @[Mint(4), Mint(5)]
assert convolution_naive(f, g).mapIt(it.val) == @[4, 13, 22, 15]
assert convolution(f, g).mapIt(it.val) == @[4, 13, 22, 15]

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
