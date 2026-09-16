# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import math
import cplib/fps/formal_power_series
import cplib/fps/sparse_formal_power_series
import cplib/modint/modint

proc check[T: BarrettModint or MontgomeryModint]() =
  let p = T.umod.int
  let f = @[init(T, 0), init(T, 0), init(T, 0), init(T, 1)]
  let integrated = f.integral
  doAssert integrated[4].val == init(T, 4).inv.val
  var coefficients = newSeq[T](p - 1)
  for i in 1..<p:
    if gcd(i, p) == 1: coefficients[i - 1] = init(T, 1)
  let actual = coefficients.integral
  for i in 1..<p:
    let expected = coefficients[i - 1] / i
    doAssert actual[i].val == expected.val, $T & " mod=" & $p & " i=" & $i

  let exponent = sfps[T](x^4)
  let unit = sfps[T](1 + x^4)
  let denseExponent = exponent.toDense(5)
  let denseUnit = unit.toDense(5)
  for result in [exponent.exp(5), denseExponent.exp(5)]:
    for i in 0..<5:
      doAssert result[i].val == (if i == 0 or i == 4: 1 else: 0)
  for result in [unit.log(5), denseUnit.log(5)]:
    for i in 0..<5:
      doAssert result[i].val == (if i == 4: 1 else: 0)
  for result in [unit.pow(2, 5), denseUnit.pow(2, 5)]:
    for i in 0..<5:
      doAssert result[i].val == (if i == 0: 1 elif i == 4: 2 else: 0)

declarStaticBarrettModint(CompositeBarrett, 15u32)
declarStaticMontgomeryModint(CompositeMontgomery, 15u32)
check[CompositeBarrett]()
check[CompositeMontgomery]()
for modulus in [15, 17, 21, 35, 17, 15]:
  modint_barrett.setMod(modulus)
  modint_montgomery.setMod(modulus)
  check[modint_barrett]()
  check[modint_montgomery]()

echo "Hello World"
