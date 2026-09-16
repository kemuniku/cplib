# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import options, random
import cplib/fps/formal_power_series
import cplib/modint/modint

var rng = initRand(20260916)

proc same[T](a, b: seq[T]): bool =
  if a.len != b.len: return false
  for i in 0..<a.len:
    if a[i].val != b[i].val: return false
  return true

proc naiveProduct[T](a, b: seq[T], n: int): seq[T] =
  result = newSeq[T](n)
  for i in 0..<min(a.len, n):
    for j in 0..<min(b.len, n - i): result[i + j] += a[i] * b[j]

proc naiveInverse[T](f: seq[T], n: int): seq[T] =
  result = newSeq[T](n)
  if n == 0: return
  result[0] = f[0].inv
  for i in 1..<n:
    for j in 1..min(i, f.len - 1): result[i] -= f[j] * result[i - j]
    result[i] *= result[0]

proc naiveExp[T](f: seq[T], n: int): seq[T] =
  result = newSeq[T](n)
  if n == 0: return
  result[0] = init(T, 1)
  for i in 1..<n:
    for j in 1..min(i, f.len - 1): result[i] += f[j] * j * result[i - j]
    result[i] /= i

proc check[T: BarrettModint or MontgomeryModint](n: int) =
  for length in [0, 3, n + 5]:
    var f = newSeq[T](length)
    for i in 0..<length: f[i] = init(T, rng.rand(T.umod.int - 1))
    let original = f
    var exponentialInput = f
    if length > 0: exponentialInput[0] = init(T, 0)
    doAssert same(exponentialInput.exp(n), naiveExp(exponentialInput, n))
    var unit = prefix(f, max(1, length))
    unit[0] = init(T, 1)
    let inverse = naiveInverse(unit, n)
    doAssert same(unit.inv(n), inverse)
    var logarithm = naiveProduct(unit.derivative, inverse, max(0, n - 1))
    logarithm.insert(init(T, 0), 0)
    logarithm.setLen(n)
    for i in 1..<n: logarithm[i] /= i
    doAssert same(unit.log(n), logarithm)
    unit[0] = init(T, 3)
    doAssert same(unit.inv(n), naiveInverse(unit, n))
    for shift in [0, 1, 2]:
      var shifted = newSeq[T](shift) & f
      var expected = newSeq[T](n)
      if n > 0: expected[0] = init(T, 1)
      for k in 0..4:
        doAssert same(shifted.pow(k, n), expected),
          $T & " n=" & $n & " len=" & $length & " shift=" & $shift & " k=" & $k
        expected = naiveProduct(expected, shifted, n)
      let square = naiveProduct(shifted, shifted, n)
      let root = square.sqrt(n)
      doAssert root.isSome
      doAssert same(naiveProduct(root.get, root.get, n), square)
    doAssert f == original
  let zero = newSeq[T]()
  doAssert zero.inv(0).len == 0
  doAssert zero.log(0).len == 0
  doAssert same(zero.sqrt(n).get, newSeq[T](n))
  doAssert @[init(T, 0), init(T, 1)].sqrt(max(2, n)).isNone

proc checkSizes[T: BarrettModint or MontgomeryModint]() =
  for n in [0, 1, 2, 3, 7, 16, 31, 32, 33, 60, 63, 64, 65,
            127, 128, 129, 255, 256, 257]:
    check[T](n)

checkSizes[modint998244353_barrett]()
checkSizes[modint998244353_montgomery]()
checkSizes[modint1000000007_barrett]()
checkSizes[modint1000000007_montgomery]()
for modulus in [998244353, 1000000007, 754974721, 998244353]:
  modint_barrett.setMod(modulus)
  modint_montgomery.setMod(modulus)
  for n in [65, 129, 257]:
    check[modint_barrett](n)
    check[modint_montgomery](n)

for modulus in [17, 257]:
  modint_barrett.setMod(modulus)
  modint_montgomery.setMod(modulus)
  check[modint_barrett](modulus)
  check[modint_montgomery](modulus)
  let f = @[init(modint_barrett, 1), init(modint_barrett, 2)]
  doAssert f.inv(300) == naiveInverse(f, 300)

block largeIdentities:
  type M = modint998244353_barrett
  for n in [1023, 1024, 1025, 4097]:
    var f = newSeq[M](n)
    f[0] = init(M, 1)
    for i in 1..<n: f[i] = init(M, rng.rand(998244352))
    var identity = newSeq[M](n)
    identity[0] = init(M, 1)
    doAssert prefix(f * f.inv(n), n) == identity
    doAssert f.log(n).exp(n) == f
    doAssert f.pow(3, n) == prefix(prefix(f * f, n) * f, n)
    let root = f.sqrt(n)
    doAssert root.isSome
    doAssert prefix(root.get * root.get, n) == f
  doAssert @[init(M, 3)].sqrt(1).isNone


block characteristicTwoConstant:
  type M = StaticBarrettModint[2u32]
  doAssert @[init(M, 1)].sqrt(1).get == @[init(M, 1)]

echo "Hello World"
