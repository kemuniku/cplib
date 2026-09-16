# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import options, random
import cplib/fps/sparse_formal_power_series
import cplib/fps/formal_power_series
import cplib/modint/modint

var rng = initRand(20260916)

proc same[T](a, b: seq[T]): bool =
  if a.len != b.len: return false
  for i in 0..<a.len:
    if a[i].val != b[i].val: return false
  true

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
  for count in [0, 1, 8]:
    var terms: seq[SparseTerm[T]]
    for j in 0..<count:
      terms.add((1 + rng.rand(n + 10), init(T, rng.rand(T.umod.int - 1))))
    let f = initSparseFPS[T](terms)
    let original = f
    let dense = f.toDense(n)
    doAssert same(f.exp(n), naiveExp(dense, n))
    let unit = f + 1
    let denseUnit = unit.toDense(n)
    doAssert same(unit.log(n), denseUnit.log(n))
    var numerator = newSeq[T](max(n - 5, 0))
    for i in 0..<numerator.len: numerator[i] = init(T, rng.rand(T.umod.int - 1))
    for constant in [1, 3]:
      let denominator = f + constant
      let expectedInverse = naiveInverse(denominator.toDense(max(n, 1)), n)
      doAssert same(denominator.inv(n), expectedInverse)
      doAssert same(numerator.divPrefix(denominator, n),
        naiveProduct(numerator, expectedInverse, n))
    for shift in [0, 1, 2, n + 1]:
      var shiftedTerms: seq[SparseTerm[T]]
      for term in f + 4:
        shiftedTerms.add((term.degree + shift, term.coefficient))
      let shifted = initSparseFPS[T](shiftedTerms)
      let shiftedDense = shifted.toDense(n)
      var expected = newSeq[T](n)
      if n > 0: expected[0] = init(T, 1)
      for k in 0..4:
        doAssert same(shifted.pow(k, n), expected)
        expected = naiveProduct(expected, shiftedDense, n)
      let root = shifted.sqrt(n)
      if shift < n and shift mod 2 == 1:
        doAssert root.isNone
      else:
        doAssert root.isSome
        doAssert same(naiveProduct(root.get, root.get, n), shiftedDense)
    doAssert same(unit.pow(T.umod.int, n), denseUnit.pow(T.umod.int, n))
    doAssert f == original
  doAssert initSparseFPS[T]([(0, init(T, 1)), (1, init(T, 2))]).inv(300).len == 300

proc checkSizes[T: BarrettModint or MontgomeryModint]() =
  for n in [0, 1, 2, 3, 17, 31, 32, 63, 64, 65, 129, 257]: check[T](n)

checkSizes[modint998244353_barrett]()
checkSizes[modint998244353_montgomery]()
checkSizes[modint1000000007_barrett]()
checkSizes[modint1000000007_montgomery]()
for modulus in [998244353, 1000000007, 17, 257, 998244353]:
  modint_barrett.setMod(modulus)
  modint_montgomery.setMod(modulus)
  for n in [1, min(modulus, 65), min(modulus, 129)]:
    check[modint_barrett](n)
    check[modint_montgomery](n)
  if modulus <= 257:
    check[modint_barrett](modulus)
    check[modint_montgomery](modulus)

block longSeries:
  type M = modint998244353_barrett
  let unit = sfps[M](1 + 3*x + 7*x^17 + 11*x^1000 + 13*x^8192)
  let exponent = sfps[M](3*x + 7*x^17 + 11*x^1000 + 13*x^8192)
  for n in [1024, 4097]:
    let dense = unit.toDense(n)
    doAssert same(unit.inv(n), dense.inv(n))
    doAssert same(unit.log(n), dense.log(n))
    doAssert same(exponent.exp(n), exponent.toDense(n).exp(n))
    doAssert same(unit.pow(1234567, n), dense.pow(1234567, n))
    let root = unit.sqrt(n)
    doAssert root.isSome
    doAssert same(prefix(root.get * root.get, n), dense)
  doAssert sfps[M](3 + x^5).sqrt(20).isNone

block compositeInverse:
  type M = StaticBarrettModint[35u32]
  let f = sfps[M](2 + 3*x + 5*x^11)
  doAssert same(f.inv(80), naiveInverse(f.toDense(80), 80))

echo "Hello World"
