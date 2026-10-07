# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/modint/modint
import cplib/convolution/ntt

declarStaticBarrettModint(Barrett41, 41u32)
declarStaticMontgomeryModint(Montgomery41, 41u32)
declarStaticBarrettModint(Barrett641, 641u32)
declarStaticMontgomeryModint(Montgomery641, 641u32)

proc check[T: BarrettModint or MontgomeryModint]() =
  let modulus = T.umod.int
  var maximum = 1
  while (modulus - 1) mod (maximum * 2) == 0:
    maximum *= 2
  maximum = min(maximum, 1024)
  var rng = initRand(97531)
  var empty: seq[T]
  empty.ntt()
  empty.intt()
  doAssert empty.len == 0
  var n = 1
  while n <= maximum:
    for trial in 0..<5:
      var a, b = newSeq[T](n)
      for i in 0..<n:
        a[i] = init(T, if trial == 0: i else: rng.rand(modulus - 1))
        b[i] = init(T, if trial == 0: n - i else: rng.rand(modulus - 1))
      var fa = a
      var fb = b
      fa.ntt()
      fb.ntt()
      var product = newSeq[T](n)
      for i in 0..<n: product[i] = fa[i] * fb[i]
      product.intt()
      var expected = newSeq[T](n)
      for i in 0..<n:
        for j in 0..<n:
          expected[(i+j) mod n] += a[i]*b[j]
      doAssert product == expected
      fa.intt()
      fb.intt()
      doAssert fa == a
      doAssert fb == b
    n *= 2

check[Barrett41]()
check[Montgomery41]()
check[Barrett641]()
check[Montgomery641]()
check[modint998244353_barrett]()
check[modint998244353_montgomery]()
for modulus in [3, 5, 17, 41, 97, 193, 257, 641, 7681, 41]:
  modint_barrett.setMod(modulus)
  check[modint_barrett]()
  modint_montgomery.setMod(modulus)
  check[modint_montgomery]()
echo "Hello World"
