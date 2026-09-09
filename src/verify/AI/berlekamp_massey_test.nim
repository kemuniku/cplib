# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import random, sequtils
import cplib/fps/berlekamp_massey
import cplib/fps/bostan_mori
import cplib/modint/modint

proc checkRecurrence[T](a, c: seq[T]) =
  for n in c.len..<a.len:
    var expected = init(T, 0)
    for i in 0..<c.len:
      expected += c[i] * a[n - i - 1]
    doAssert a[n].val == expected.val

proc checkExamples[T: BarrettModint or MontgomeryModint](M: typedesc[T]) =
  doAssert berlekampMassey(newSeq[T]()).len == 0
  doAssert berlekampMassey(newSeq[T](10)).len == 0
  doAssert berlekampMassey(@[init(T, 1), init(T, 0), init(T, 0)]).mapIt(it.val) == @[0]
  doAssert berlekampMassey(@[init(T, 0), init(T, 0), init(T, 1)]).len == 3
  let constant = newSeqWith(10, init(T, 7))
  doAssert berlekampMassey(constant).mapIt(it.val) == @[1]
  var geometric: seq[T]
  for value in [1, 3, 9, 27, 81, 243]:
    geometric.add(init(T, value))
  doAssert berlekampMassey(geometric).mapIt(it.val) == @[3]
  var fib: seq[T]
  for value in [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]:
    fib.add(init(T, value))
  let c = berlekampMassey(fib)
  doAssert c.mapIt(it.val) == @[1, 1]
  doAssert linearRecurrenceKth(fib[0..<c.len], c, 20).val == 6765

  var rng = initRand(20260909)
  for d in 1..16:
    for trial in 0..<16:
      let original = newSeqWith(d, init(T, rng.rand(0..100)))
      var a = newSeq[T](4 * d + 10)
      for i in 0..<d:
        a[i] = init(T, rng.rand(0..100))
      for n in d..<a.len:
        for i in 0..<d:
          a[n] += original[i] * a[n - i - 1]
      let inferred = berlekampMassey(a[0..<2 * d])
      doAssert inferred.len <= d
      # 推定に使用していない後続項でも漸化式が成り立つことを確認する。
      checkRecurrence(a, inferred)
      if inferred.len > 0 and trial == 0:
        doAssert linearRecurrenceKth(a[0..<inferred.len], inferred, a.high).val == a[^1].val

# 小さい有限体上で係数を全探索し、最小次数を独立に検証する。
proc minimumOrder(a: seq[int], modulus: int): int =
  var count = 1
  for d in 0..a.len:
    for encoding in 0..<count:
      var code = encoding
      var c = newSeq[int](d)
      for i in 0..<d:
        c[i] = code mod modulus
        code = code div modulus
      var valid = true
      for n in d..<a.len:
        var expected = 0
        for i in 0..<d:
          expected += c[i] * a[n - i - 1]
        if expected mod modulus != a[n]:
          valid = false
          break
      if valid: return d
    count *= modulus

proc checkExhaustive[T: BarrettModint or MontgomeryModint](M: typedesc[T], maxLen: int) =
  let modulus = M.mod.int
  var count = 1
  for n in 0..maxLen:
    for encoding in 0..<count:
      var code = encoding
      var a = newSeq[T](n)
      for i in 0..<n:
        a[i] = init(T, code mod modulus)
        code = code div modulus
      let c = berlekampMassey(a)
      checkRecurrence(a, c)
      doAssert c.len == minimumOrder(a.mapIt(it.val), modulus)
    count *= modulus

checkExamples(modint998244353_barrett)
checkExamples(modint998244353_montgomery)
checkExamples(modint1000000007_barrett)
checkExamples(modint1000000007_montgomery)
modint_barrett.setMod(998244353)
modint_montgomery.setMod(998244353)
checkExamples(modint_barrett)
checkExamples(modint_montgomery)
checkExhaustive(StaticBarrettModint[2u32], 8)
checkExhaustive(StaticMontgomeryModint[3u32], 6)
