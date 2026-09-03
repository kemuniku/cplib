# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import options, sequtils
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

proc naivePowEnumerate[T: BarrettModint or MontgomeryModint](
    f, g: seq[T], m: int): seq[T] =
  let n = f.len - 1
  result = newSeq[T](m + 1)
  var power = @[init(T, 1)]
  for exponent in 0..m:
    let product = power * g
    if n < product.len: result[exponent] = product[n]
    power = prefix(power * f, n + 1)

block basicOperations:
  let f = @[Mint(1), Mint(2), Mint(3)]
  let g = @[Mint(4), Mint(5)]
  assert f.coefficient(0).val == 1
  assert f.coefficient(2).val == 3
  assert f.coefficient(-1).val == 0
  assert f.coefficient(3).val == 0
  assert (f + g).values == @[5, 7, 3]
  assert (f + 4).values == @[5, 2, 3]
  assert (4 + f).values == @[5, 2, 3]
  var h = f
  h += -2
  assert h.values == @[998244352, 2, 3]
  var empty: seq[Mint]
  empty += 7
  assert empty.values == @[7]
  assert (f - g).values == @[998244350, 998244350, 3]
  assert (f * g).values == @[4, 13, 22, 15]
  assert (f / @[Mint(1), Mint(1)]).values == @[1, 1, 2]
  assert (@[Mint(1), Mint(2)] / @[Mint(1), Mint(1), Mint(1), Mint(1)]).values ==
    @[1, 1, 998244351, 0]
  var quotient = f
  quotient /= @[Mint(1), Mint(1)]
  assert quotient.values == @[1, 1, 2]
  let zero: seq[Mint] = @[]
  assert (zero / @[Mint(1), Mint(2)]).values == @[0, 0]
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

block logarithmIgnoresHigherTerms:
  type SmallMint = StaticBarrettModint[17u32]
  var f = newSeq[SmallMint](18)
  f[0] = init(SmallMint, 1)
  for i in 1..<f.len: f[i] = init(SmallMint, i * i + 3 * i + 1)
  assert f.log(2).mapIt(it.val) == @[0, f[1].val]

proc checkRelaxedFormalPowerSeries[T: BarrettModint or MontgomeryModint](
    M: typedesc[T], n: int) =
  var unit = newSeq[T](n)
  var exponent = newSeq[T](n)
  unit[0] = T(1)
  for i in 1..<n:
    unit[i] = T(i * i * 17 + i * 31 + 9)
    exponent[i] = T(i * i * 13 + i * 29 + 7)

  let inverse = unit.inv(n)
  let relaxedInverse = unit.invRelaxed(n)
  let logarithm = unit.log(n)
  let relaxedLogarithm = unit.logRelaxed(n)
  let exponential = exponent.exp(n)
  let relaxedExponential = exponent.expRelaxed(n)
  let power = unit.pow(37, n)
  let relaxedPower = unit.powRelaxed(37, n)
  let square = prefix(unit * unit, n)
  var inverseState = initRelaxedInv[T](n)
  var logarithmState = initRelaxedLog[T](n)
  var exponentialState = initRelaxedExp[T](n)
  var powerState = initRelaxedPow[T](n, 37)
  var squareRootState = initRelaxedSqrt[T](n)
  for i in 0..<n:
    doAssert relaxedInverse[i].val == inverse[i].val, $M & " inv " & $n & " " & $i
    doAssert relaxedLogarithm[i].val == logarithm[i].val, $M & " log " & $n & " " & $i
    doAssert relaxedExponential[i].val == exponential[i].val, $M & " exp " & $n & " " & $i
    doAssert relaxedPower[i].val == power[i].val, $M & " pow " & $n & " " & $i
    doAssert inverseState.add(unit[i]).val == inverse[i].val,
      $M & " streaming inv " & $n & " " & $i
    doAssert logarithmState.add(unit[i]).val == logarithm[i].val,
      $M & " streaming log " & $n & " " & $i
    doAssert exponentialState.add(exponent[i]).val == exponential[i].val,
      $M & " streaming exp " & $n & " " & $i
    doAssert powerState.add(unit[i]).val == power[i].val,
      $M & " streaming pow " & $n & " " & $i
    let rootCoefficient = squareRootState.add(square[i])
    doAssert rootCoefficient.isSome and rootCoefficient.get.val == unit[i].val,
      $M & " streaming sqrt " & $n & " " & $i
  doAssert inverseState.len == n and inverseState.coefficients.len == n
  doAssert logarithmState.len == n and logarithmState.coefficients.len == n
  doAssert exponentialState.len == n and exponentialState.coefficients.len == n
  doAssert powerState.len == n and powerState.coefficients.len == n
  doAssert squareRootState.len == n and
    squareRootState.coefficients.get.len == n

  let relaxedRoot = square.sqrtRelaxed(n)
  doAssert relaxedRoot.isSome, $M & " sqrt " & $n
  let restoredSquare = prefix(relaxedRoot.get * relaxedRoot.get, n)
  for i in 0..<n:
    doAssert restoredSquare[i].val == square[i].val,
      $M & " sqrt " & $n & " " & $i

block relaxedFormalPowerSeries:
  for n in [1, 2, 3, 7, 16, 17, 31, 32, 33, 63, 64, 65, 127, 130]:
    checkRelaxedFormalPowerSeries(Mint, n)
  checkRelaxedFormalPowerSeries(modint998244353_montgomery, 70)
  checkRelaxedFormalPowerSeries(modint1000000007_barrett, 70)
  checkRelaxedFormalPowerSeries(modint1000000007_montgomery, 70)

  let shifted = @[Mint(0), Mint(0), Mint(4), Mint(12), Mint(13), Mint(9)]
  let shiftedRoot = shifted.sqrtRelaxed(12)
  assert shiftedRoot.isSome
  assert prefix(shiftedRoot.get * shiftedRoot.get, 12).values ==
    prefix(shifted, 12).values
  assert @[Mint(0), Mint(1)].sqrtRelaxed(2).isNone

  var shiftedPowerState = initRelaxedPow[Mint](12, 2)
  var shiftedPower = newSeq[Mint](12)
  for i in 0..<shiftedPower.len:
    let coefficient = if i < shifted.len: shifted[i] else: Mint(0)
    shiftedPower[i] = shiftedPowerState.add(coefficient)
  assert shiftedPower.values == prefix(shifted * shifted, 12).values

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

proc checkMultipointEvaluation[T: BarrettModint or MontgomeryModint](
    M: typedesc[T], pointCount, coefficientCount: int) =
  var f = newSeq[T](coefficientCount)
  var xs = newSeq[T](pointCount)
  for i in 0..<f.len: f[i] = T(i * i * 17 + i * 31 + 9)
  for i in 0..<xs.len: xs[i] = T(i * i * 13 + i * 29 + 7)
  let actual = multipointEvaluation[T](f, xs)
  assert actual.len == xs.len
  for i in 0..<xs.len:
    doAssert actual[i].val == f.eval(xs[i]).val,
      $M & " " & $pointCount & " " & $coefficientCount & " " & $i

proc checkPolynomialInterpolation[T: BarrettModint or MontgomeryModint](
    M: typedesc[T], n: int) =
  var polynomial = newSeq[T](n)
  var xs = newSeq[T](n)
  var ys = newSeq[T](n)
  for i in 0..<n:
    polynomial[i] = T(i * i * 19 + i * 37 + 11)
    xs[i] = T(i * 3 + 2)
  for i in 0..<n:
    ys[i] = polynomial.eval(xs[i])
  let restored = polynomialInterpolation(xs, ys)
  for i in 0..<n:
    doAssert restored[i].val == polynomial[i].val, $M & " " & $n & " " & $i

block multipointEvaluationVariousSizes:
  for pointCount in [0, 1, 2, 7, 16, 17, 31, 32, 63, 64, 65, 127, 128, 129]:
    for coefficientCount in [0, 1, 5, 19, 70, 150]:
      checkMultipointEvaluation(Mint, pointCount, coefficientCount)
  checkMultipointEvaluation(modint998244353_montgomery, 129, 173)
  checkMultipointEvaluation(modint1000000007_barrett, 70, 131)
  checkMultipointEvaluation(modint1000000007_montgomery, 70, 131)

block polynomialInterpolationVariousSizes:
  for n in [1, 2, 7, 16, 17, 31, 32, 65, 130]:
    checkPolynomialInterpolation(Mint, n)
  checkPolynomialInterpolation(modint998244353_montgomery, 70)
  checkPolynomialInterpolation(modint1000000007_barrett, 70)
  checkPolynomialInterpolation(modint1000000007_montgomery, 70)

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

block powEnumeration:
  for n in [0, 1, 2, 3, 4, 7, 8, 15, 16, 31, 70]:
    var f = newSeq[Mint](n + 1)
    var g = newSeq[Mint](n + 4)
    for i in 0..<f.len: f[i] = Mint(17 * i * i + 31 * i + 3)
    for i in 0..<g.len: g[i] = Mint(23 * i * i + 11 * i + 5)
    for m in [0, 1, 5, n, n + 3]:
      assert powEnumerate(f, g, m) == naivePowEnumerate(f, g, m)
    assert powEnumerate(f, g) == naivePowEnumerate(f, g, n)
    assert powEnumerate(f) ==
      naivePowEnumerate(f, @[Mint(1)], n)

  let zeroConstant = @[Mint(0), Mint(2), Mint(3), Mint(5), Mint(7)]
  assert powEnumerate(zeroConstant, 8) ==
    naivePowEnumerate(zeroConstant, @[Mint(1)], 8)

proc checkCompositionalInverse[T: BarrettModint or MontgomeryModint](
    M: typedesc[T], n: int) =
  var f = newSeq[T](n)
  f[1] = T(3)
  for i in 2..<n: f[i] = T(i * i * 23 + i * 41 + 13)
  let inverse = compositionalInverse(f, n)
  let composed = compose(f, inverse, n)
  for i in 0..<n:
    let expected = if i == 1: 1 else: 0
    doAssert composed[i].val == expected, $M & " " & $n & " " & $i

block compositionalInverseVariousSizes:
  for n in [2, 3, 4, 5, 7, 8, 9, 15, 16, 17, 31, 32, 33, 65, 130]:
    checkCompositionalInverse(Mint, n)
  checkCompositionalInverse(modint998244353_montgomery, 70)
  checkCompositionalInverse(modint1000000007_barrett, 70)
  checkCompositionalInverse(modint1000000007_montgomery, 70)

block bostanMoriAndRecurrence:
  let p = @[Mint(0), Mint(1)]
  let q = @[Mint(1), Mint(-1), Mint(-1)]
  let fib = @[0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89]
  for i in 0..<fib.len: assert bostanMori(p, q, i).val == fib[i]
  for i in 0..<fib.len:
    assert linearRecurrenceKth(@[Mint(0), Mint(1)], @[Mint(1), Mint(1)], i).val == fib[i]

block sparseOperations:
  let literal = sfps[Mint](x + x^3 + x^4 + x^6)
  assert literal == initSparseFPS[Mint](@[
    (degree: 1, coefficient: Mint(1)),
    (degree: 3, coefficient: Mint(1)),
    (degree: 4, coefficient: Mint(1)),
    (degree: 6, coefficient: Mint(1))
  ])
  let runtimeCoefficient = Mint(7)
  let weightedLiteral = SFPS[Mint](3 - 2*x + runtimeCoefficient*x^2 + x^2 - x^5)
  assert weightedLiteral == initSparseFPS[Mint](@[
    (degree: 0, coefficient: Mint(3)),
    (degree: 1, coefficient: Mint(-2)),
    (degree: 2, coefficient: Mint(8)),
    (degree: 5, coefficient: Mint(-1))
  ])
  let runtimeDegree = 9
  assert sfps[Mint](x^runtimeDegree + 4*x^(runtimeDegree + 2)) ==
    initSparseFPS[Mint](@[
      (degree: 9, coefficient: Mint(1)),
      (degree: 11, coefficient: Mint(4))
    ])

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

  let withoutConstant = sfps[Mint](2*x + x^3)
  assert withoutConstant + 5 == sfps[Mint](5 + 2*x + x^3)
  assert 5 + withoutConstant == sfps[Mint](5 + 2*x + x^3)
  assert sfps[Mint](5 + 2*x + x^3) + -5 == withoutConstant
  var addedInPlace = withoutConstant
  addedInPlace += 7
  assert addedInPlace == sfps[Mint](7 + 2*x + x^3)
  var emptySparse = initSparseFPS[Mint]([])
  emptySparse += 4
  assert emptySparse == sfps[Mint](4)

  let dense = @[Mint(7), Mint(1), Mint(4), Mint(9), Mint(2)]
  let sparseDense = sparse.toDense(sparse.degree + 1)
  assert (dense * sparse).values == (dense * sparseDense).values
  assert (sparse * dense).values == (dense * sparseDense).values
  assert dense.mulPrefix(sparse, 4).values == prefix(dense * sparseDense, 4).values
  assert (dense / sparse).values ==
    prefix(dense * sparseDense.inv(dense.len), dense.len).values
  assert dense.divPrefix(sparse, 12).values ==
    prefix(prefix(dense, 12) * sparseDense.inv(12), 12).values

  var inplace = dense
  let expectedProduct = dense.mulPrefix(sparse, dense.len)
  inplace *= sparse
  assert inplace == expectedProduct
  inplace /= sparse
  assert inplace == dense

  var quotient = dense
  quotient /= sparse
  assert quotient == dense.divPrefix(sparse, dense.len)

  var empty: seq[Mint]
  empty *= sparse
  assert empty.len == 0

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
  let denominatorInverse = denominator.inv(denominator.len)
  for i in 0..<composed.len:
    assert composed[i].val == denominatorInverse[i].val

  let enumerateF = @[
    OtherMint(2), OtherMint(3), OtherMint(5), OtherMint(7), OtherMint(11)]
  let enumerateG = @[OtherMint(13), OtherMint(17), OtherMint(19)]
  let enumerated = powEnumerate(enumerateF, enumerateG, 12)
  let naiveEnumerated = naivePowEnumerate(enumerateF, enumerateG, 12)
  for i in 0..<enumerated.len:
    assert enumerated[i].val == naiveEnumerated[i].val

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
