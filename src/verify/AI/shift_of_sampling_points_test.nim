# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import random, sequtils
import cplib/fps/shift_of_sampling_points
import cplib/modint/modint

proc evaluate[T](f: seq[T], x: T): T =
  result = init(T, 0)
  for i in countdown(f.high, 0): result = result * x + f[i]

proc checkShift[T: BarrettModint or MontgomeryModint](M: typedesc[T]) =
  let modulus = T.umod.int
  var rng = initRand(20260910)
  var lengths = @[0, 1, 2, 3, 7, 16, 31, 64, 65, 129, 257]
  if modulus <= 257: lengths.add(modulus)
  for n in lengths:
    if n > modulus: continue
    let f = newSeqWith(n, init(T, rng.rand(0..<modulus)))
    var ys = newSeq[T](n)
    for i in 0..<n: ys[i] = evaluate(f, init(T, i))
    let original = ys.mapIt(it.val)
    for t in [0, 1, n div 2, n, n + 1, -1, -n, modulus - 2]:
      for m in [0, 1, max(0, n - 1), n, n + 3, 2 * n + 7]:
        let shifted = shiftOfSamplingPoints(ys, init(T, t), m)
        doAssert shifted.len == m
        for i in 0..<m:
          doAssert shifted[i].val == evaluate(f, init(T, t) + i).val,
            $M & " n=" & $n & " m=" & $m & " t=" & $t & " i=" & $i
      doAssert shiftOfSamplingPoints(ys, init(T, t)).mapIt(it.val) ==
        shiftOfSamplingPoints(ys, init(T, t), n).mapIt(it.val)
    doAssert ys.mapIt(it.val) == original

  doAssert shiftOfSamplingPoints(newSeq[T](min(70, modulus)), init(T, 100), 97).mapIt(it.val) ==
    newSeq[int](97)

checkShift(modint998244353_barrett)
checkShift(modint998244353_montgomery)
checkShift(modint1000000007_barrett)
checkShift(modint1000000007_montgomery)
for modulus in [998244353, 1000000007]:
  modint_barrett.setMod(modulus)
  modint_montgomery.setMod(modulus)
  checkShift(modint_barrett)
  checkShift(modint_montgomery)
checkShift(StaticBarrettModint[101u32])
checkShift(StaticMontgomeryModint[101u32])
checkShift(StaticBarrettModint[2u32])
checkShift(StaticMontgomeryModint[3u32])

block invalidInput:
  type Mint = StaticBarrettModint[7u32]
  var rejected = false
  try:
    discard shiftOfSamplingPoints(newSeq[Mint](), init(Mint, 0), -1)
  except AssertionDefect:
    rejected = true
  doAssert rejected
  rejected = false
  try:
    discard shiftOfSamplingPoints(newSeq[Mint](8), init(Mint, 0), 1)
  except AssertionDefect:
    rejected = true
  doAssert rejected
