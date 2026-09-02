# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import std/[options, sequtils]
include cplib/fps/fps
import cplib/modint/modint

type Mint = modint998244353_barrett

proc values(f: seq[Mint]): seq[int] = f.mapIt(it.val)

proc naiveComposition[T: BarrettModint or MontgomeryModint](
    outer, inner: seq[T], n: int): seq[T] =
  result = newSeq[T](n)
  var power = @[init(T, 1)]
  for coefficient in outer:
    result += prefix(power * coefficient, n)
    result.setLen(n)
    power = prefix(power * inner, n)

block basicOperations:
  let f = @[Mint(1), Mint(2), Mint(3)]
  let g = @[Mint(4), Mint(5)]
  assert (f + g).values == @[5, 7, 3]
  assert (f - g).values == @[998244350, 998244350, 3]
  assert (f * g).values == @[4, 13, 22, 15]
  assert f.derivative.values == @[2, 6]
  assert f.derivative.integral.values == @[0, 2, 3]
  assert f.eval(Mint(2)).val == 17

block inverseLogExpAndPower:
  var f = newSeq[Mint](130)
  f[0] = 1
  for i in 1..<f.len: f[i] = Mint((i * i * 17 + i * 31 + 9) mod 1000)
  let inverse = f.inv(f.len)
  assert prefix(f * inverse, f.len).values == @[1] & newSeq[int](f.len - 1)
  let logarithm = f.log(f.len)
  assert logarithm.exp(f.len).values == f.values
  assert f.pow(3, f.len).values == prefix(f * f * f, f.len).values
  let shifted = @[Mint(0), Mint(0), Mint(3), Mint(2), Mint(5)]
  assert shifted.pow(2, 10).values == prefix(shifted * shifted, 10).values
  assert shifted.pow(0, 5).values == @[1, 0, 0, 0, 0]

block squareRoot:
  let f = @[Mint(2), Mint(5), Mint(7), Mint(11), Mint(13), Mint(17)]
  let square = prefix(f * f, 12)
  let root = square.sqrt(12)
  assert root.isSome
  assert prefix(root.get * root.get, 12).values == square.values
  assert @[Mint(0), Mint(1)].sqrt(2).isNone

block polynomialDivision:
  let f = @[Mint(1), Mint(4), Mint(2), Mint(8), Mint(3), Mint(9)]
  let g = @[Mint(2), Mint(1), Mint(3)]
  let (q, r) = f.divmod(g)
  assert (q * g + r).normalized.values == f.values
  assert r.len < g.len
  assert (f div g).values == q.values
  assert (f mod g).values == r.values

block evaluationAndInterpolation:
  let f = @[Mint(7), Mint(1), Mint(4), Mint(9), Mint(2), Mint(6)]
  let xs = toSeq(0..<10).mapIt(Mint(it * 3 + 2))
  let ys = multipointEvaluation(f, xs)
  for i in 0..<xs.len: assert ys[i] == f.eval(xs[i])
  let interpolated = polynomialInterpolation(xs[0..<f.len], ys[0..<f.len])
  assert interpolated.values == f.values
  assert polynomialInterpolation(newSeq[Mint](), newSeq[Mint]()).len == 0

block shift:
  let f = @[Mint(3), Mint(1), Mint(4), Mint(1), Mint(5), Mint(9)]
  let c = Mint(17)
  let shifted = f.taylorShift(c)
  for x in 0..8:
    assert shifted.eval(Mint(x)) == f.eval(Mint(x) + c)

block compositionAndInverse:
  let f = @[Mint(7), Mint(1), Mint(4), Mint(9), Mint(2), Mint(6)]
  let g = @[Mint(0), Mint(3), Mint(1), Mint(5)]
  var naive = newSeq[Mint](12)
  var power = @[Mint(1)]
  for coefficient in f:
    naive += prefix(power * coefficient, naive.len)
    power = prefix(power * g, naive.len)
  assert compose(f, g, naive.len).values == naive.values
  let h = @[Mint(0), Mint(3), Mint(1), Mint(4), Mint(1), Mint(5), Mint(9)]
  let inverse = h.compositionalInverse(20)
  var identity = newSeq[Mint](20)
  identity[1] = 1
  assert compose(h, inverse, 20).values == identity.values
  assert compose(inverse, h, 20).values == identity.values

  for n in [2, 3, 4, 5, 7, 8, 9, 15, 16, 23]:
    var randomOuter = newSeq[Mint](n)
    var randomInner = newSeq[Mint](n)
    for i in 0..<n: randomOuter[i] = Mint(13 * i * i + 29 * i + 7)
    for i in 1..<n: randomInner[i] = Mint(31 * i * i + 11 * i + 5)
    assert compose(randomOuter, randomInner, n) ==
      naiveComposition(randomOuter, randomInner, n)

  var longOuter = newSeq[Mint](512)
  var longInner = newSeq[Mint](512)
  for i in 0..<longOuter.len: longOuter[i] = 1
  for i in 1..<longInner.len: longInner[i] = Mint(i * i + 7 * i + 3)
  var oneMinusInner = -longInner
  oneMinusInner[0] += 1
  assert compose(longOuter, longInner, longOuter.len).values ==
    oneMinusInner.inv(oneMinusInner.len).values

block bostanMoriAndRecurrence:
  let p = @[Mint(0), Mint(1)]
  let q = @[Mint(1), Mint(-1), Mint(-1)]
  let fib = @[0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89]
  for i in 0..<fib.len: assert bostanMori(p, q, i).val == fib[i]
  for i in 0..<fib.len:
    assert linearRecurrenceKth(@[Mint(0), Mint(1)], @[Mint(1), Mint(1)], i).val == fib[i]

block sparseOperations:
  let sparse = initSparseFPS[Mint](@[
    (degree: 3, coefficient: Mint(5)),
    (degree: 0, coefficient: Mint(2)),
    (degree: 1, coefficient: Mint(3)),
    (degree: 3, coefficient: Mint(-1)),
    (degree: 7, coefficient: Mint(0))
  ])
  assert sparse.len == 3
  assert sparse.degree == 3
  assert sparse.constantTerm == Mint(2)
  assert sparse.coefficient(2) == Mint(0)
  assert sparse.toDense(5).values == @[2, 3, 0, 4, 0]

  let dense = @[Mint(7), Mint(1), Mint(4), Mint(9), Mint(2)]
  let sparseDense = sparse.toDense(sparse.degree + 1)
  assert (dense * sparse).values == (dense * sparseDense).values
  assert (sparse * dense).values == (dense * sparseDense).values
  assert dense.mulPrefix(sparse, 4).values == prefix(dense * sparseDense, 4).values
  assert (dense / sparse).values ==
    prefix(dense * sparseDense.inv(dense.len), dense.len).values
  assert dense.divPrefix(sparse, 12).values ==
    prefix(prefix(dense, 12) * sparseDense.inv(12), 12).values

block sparseElementaryFunctions:
  let unit = initSparseFPS[Mint](@[
    (degree: 0, coefficient: Mint(1)),
    (degree: 1, coefficient: Mint(2)),
    (degree: 3, coefficient: Mint(3)),
    (degree: 5, coefficient: Mint(5))
  ])
  let exponent = initSparseFPS[Mint](@[
    (degree: 1, coefficient: Mint(2)),
    (degree: 4, coefficient: Mint(7)),
    (degree: 6, coefficient: Mint(11))
  ])
  let n = 160
  let unitDense = unit.toDense(n)
  let exponentDense = exponent.toDense(n)
  assert unit.inv(n) == unitDense.inv(n)
  assert unit.log(n) == unitDense.log(n)
  assert unit.pow(17, n) == unitDense.pow(17, n)
  assert exponent.exp(n) == exponentDense.exp(n)

  let square = initSparseFPS[Mint](@[
    (degree: 0, coefficient: Mint(1)),
    (degree: 3, coefficient: Mint(2)),
    (degree: 6, coefficient: Mint(1))
  ])
  let root = square.sqrt(n)
  assert root.isSome
  assert prefix(root.get * root.get, n) == square.toDense(n)

block sparseSingleCoefficient:
  let unit = initSparseFPS[Mint](@[
    (degree: 0, coefficient: Mint(1)),
    (degree: 1, coefficient: Mint(2)),
    (degree: 3, coefficient: Mint(3)),
    (degree: 5, coefficient: Mint(5))
  ])
  let exponent = initSparseFPS[Mint](@[
    (degree: 1, coefficient: Mint(2)),
    (degree: 4, coefficient: Mint(7)),
    (degree: 6, coefficient: Mint(11))
  ])
  let n = 2000
  let inverse = unit.inv(n)
  let logarithm = unit.log(n)
  let power = unit.pow(123, n)
  let exponential = exponent.exp(n)
  for degree in [0, 1, 2, 3, 7, 31, 127, 511, n - 1]:
    assert unit.invCoefficient(degree) == inverse[degree]
    assert unit.logCoefficient(degree) == logarithm[degree]
    assert unit.powCoefficient(123, degree) == power[degree]
    assert exponent.expCoefficient(degree) == exponential[degree]

  let shifted = initSparseFPS[Mint](@[
    (degree: 2, coefficient: Mint(3)),
    (degree: 3, coefficient: Mint(5)),
    (degree: 7, coefficient: Mint(11))
  ])
  let shiftedDense = shifted.toDense(300)
  let shiftedPower = shiftedDense.pow(9, 300)
  for degree in [0, 17, 18, 19, 51, 127, 299]:
    assert shifted.powCoefficient(9, degree) == shiftedPower[degree]

block arbitraryModulus:
  type OtherMint = modint1000000007_montgomery
  var f = newSeq[OtherMint](75)
  f[0] = 1
  for i in 1..<f.len: f[i] = OtherMint(i * i + 123 * i + 45)
  let product = prefix(f * f.inv(f.len), f.len)
  assert product[0].val == 1
  for i in 1..<product.len: assert product[i].val == 0
  var outer = newSeq[OtherMint](70)
  var inner = newSeq[OtherMint](70)
  for i in 0..<outer.len: outer[i] = 1
  for i in 1..<inner.len: inner[i] = OtherMint(11 * i * i + 5 * i + 2)
  var denominator = -inner
  denominator[0] += 1
  let composed = compose(outer, inner, outer.len)
  assert composed == denominator.inv(denominator.len)

  let sparse = initSparseFPS[OtherMint](@[
    (degree: 0, coefficient: OtherMint(1)),
    (degree: 1, coefficient: OtherMint(3)),
    (degree: 4, coefficient: OtherMint(7))
  ])
  let inverse = sparse.inv(300)
  let logarithm = sparse.log(300)
  let power = sparse.pow(31, 300)
  assert sparse.invCoefficient(299).val == inverse[299].val
  assert sparse.logCoefficient(299).val == logarithm[299].val
  assert sparse.powCoefficient(31, 299).val == power[299].val
