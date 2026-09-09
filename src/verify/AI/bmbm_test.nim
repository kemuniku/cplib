# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import random, sequtils
import cplib/fps/bmbm
import cplib/modint/modint

proc checkBmbm[T: BarrettModint or MontgomeryModint](M: typedesc[T]) =
  let empty = newSeq[T]()
  let zeros = newSeq[T](8)
  let impulse = @[init(T, 1), init(T, 0), init(T, 0)]
  let delayed = @[init(T, 0), init(T, 0), init(T, 1),
      init(T, 0), init(T, 0), init(T, 0)]
  let constant = newSeqWith(6, init(T, 7))
  let geometric = @[init(T, 1), init(T, 3), init(T, 9), init(T, 27)]
  let fib = @[init(T, 0), init(T, 1), init(T, 1), init(T, 2)]
  for k in [0, 1, 2, 3, 8, 100, int.high]:
    doAssert bmbm(empty, k).val == 0
    doAssert bmbm(zeros, k).val == 0
    doAssert bmbm(impulse, k).val == (if k == 0: 1 else: 0)
    doAssert bmbm(delayed, k).val == (if k == 2: 1 else: 0)
    doAssert bmbm(constant, k).val == 7
    doAssert bmbm(geometric, k).val == init(T, 3).pow(k).val
  doAssert bmbm(fib, 20).val == 6765
  for a in [empty, fib]:
    var rejected = false
    try:
      discard bmbm(a, -1)
    except AssertionDefect:
      rejected = true
    doAssert rejected

  var rng = initRand(20260909)
  for d in [1, 2, 3, 8, 32, 65]:
    for trial in 0..<8:
      var c = newSeq[T](d)
      var a = newSeq[T](4 * d + 10)
      for i in 0..<d:
        c[i] = init(T, rng.rand(0..100))
        a[i] = init(T, rng.rand(0..100))
      for n in d..<a.len:
        for i in 0..<d:
          a[n] += c[i] * a[n - i - 1]
      let samples = a[0..<2 * d]
      for k in [0, d, samples.high, samples.len, a.high]:
        doAssert bmbm(samples, k).val == a[k].val

checkBmbm(modint998244353_barrett)
checkBmbm(modint998244353_montgomery)
checkBmbm(modint1000000007_barrett)
checkBmbm(modint1000000007_montgomery)
modint_barrett.setMod(998244353)
modint_montgomery.setMod(998244353)
checkBmbm(modint_barrett)
checkBmbm(modint_montgomery)
