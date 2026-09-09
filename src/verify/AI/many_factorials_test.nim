# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import algorithm, random, sequtils
import cplib/math/many_factorials
import cplib/modint/modint

proc checkFactorials[T: BarrettModint or MontgomeryModint](M: typedesc[T]) =
  let modulus = T.umod.int
  doAssert many_factorials.manyFactorials[T](newSeq[int]()).len == 0
  doAssert many_factorials.manyFactorials[T]([modulus, modulus + 1, int.high]).mapIt(it.val) == @[0, 0, 0]
  doAssert many_factorials.manyFactorials[T]([0, 1, 0]).mapIt(it.val) == @[1, 1, 1]

  let limit = min(modulus - 1, 100000)
  var fact = newSeq[T](limit + 1)
  fact[0] = init(T, 1)
  for i in 1..limit: fact[i] = fact[i - 1] * i
  var ns: seq[int]
  for n in 0..min(limit, 1100): ns.add(n)
  for n in [2047, 2048, 2049, 4095, 4096, 4097, 32767, 32768, 32769, limit]:
    if n <= limit: ns.add(n)
  var rng = initRand(20260910)
  for i in 0..<1000: ns.add(rng.rand(0..limit))
  ns = ns & ns
  rng.shuffle(ns)
  let actual = many_factorials.manyFactorials[T](ns)
  for i, n in ns: doAssert actual[i].val == fact[n].val, $M & " n=" & $n
  for blockSize in [1, 64, 1024]:
    let table = initLargeFactorial[T](maxN = limit, blockSize = blockSize)
    for n in ns:
      doAssert table.fact(n).val == fact[n].val,
        $M & " n=" & $n & " blockSize=" & $blockSize
    doAssert table.fact(modulus).val == 0
    doAssert table.fact(int.high).val == 0
  for n in [1023, 1024, 1025, 4095, 4096, 4097, limit]:
    if n <= limit: doAssert many_factorials.manyFactorials[T]([n])[0].val == fact[n].val

  if modulus <= 100001:
    ns = toSeq(0..modulus + 3)
    ns.reverse
    let exhaustive = many_factorials.manyFactorials[T](ns)
    let table = initLargeFactorial[T]()
    for i, n in ns:
      let expected = if n < modulus: fact[n].val else: 0
      doAssert exhaustive[i].val == expected, $M & " n=" & $n
      doAssert table.fact(n).val == expected, $M & " online n=" & $n
  else:
    let offsets = @[0, 1, 2, 31, 32, 63, 64, 1023, 1024, 32767, 32768, 32769]
    ns = offsets.mapIt(modulus - 1 - it)
    ns.add([modulus, modulus + 1, int.high, 0])
    let nearModulus = many_factorials.manyFactorials[T](ns)
    let table = initLargeFactorial[T](blockSize = 32768)
    for i, k in offsets:
      var expected = fact[k].inv
      if (k and 1) == 0: expected = -expected
      doAssert nearModulus[i].val == expected.val, $M & " k=" & $k
      doAssert table.fact(ns[i]).val == expected.val, $M & " online k=" & $k
    doAssert nearModulus[^4..^1].mapIt(it.val) == @[0, 0, 0, 1]

checkFactorials(modint998244353_barrett)
checkFactorials(modint998244353_montgomery)
checkFactorials(modint1000000007_barrett)
checkFactorials(modint1000000007_montgomery)
for modulus in [998244353, 1000000007]:
  modint_barrett.setMod(modulus)
  modint_montgomery.setMod(modulus)
  checkFactorials(modint_barrett)
  checkFactorials(modint_montgomery)
checkFactorials(StaticBarrettModint[2u32])
checkFactorials(StaticMontgomeryModint[3u32])
checkFactorials(StaticBarrettModint[65537u32])
checkFactorials(StaticMontgomeryModint[65537u32])

block invalidInput:
  var rejected = false
  try:
    discard many_factorials.manyFactorials[modint998244353_barrett]([0, -1])
  except AssertionDefect:
    rejected = true
  doAssert rejected

template expectAssertion(body: untyped) =
  block:
    var rejected = false
    try:
      body
    except AssertionDefect:
      rejected = true
    doAssert rejected

block onlineBounds:
  type Mint = StaticBarrettModint[101u32]
  let zero = initLargeFactorial[Mint](maxN = 0)
  let limited = initLargeFactorial[Mint](maxN = 10, blockSize = 4)
  let full = initLargeFactorial[Mint](maxN = int.high)
  doAssert zero.fact(0).val == 1
  doAssert zero.fact(101).val == 0
  doAssert limited.fact(10).val == 72
  doAssert full.fact(100).val == 100
  doAssert limited.fact(10).val == 72
  expectAssertion: discard zero.fact(1)
  expectAssertion: discard limited.fact(11)
  expectAssertion: discard limited.fact(-1)
  expectAssertion: discard initLargeFactorial[Mint](maxN = -2)
  for blockSize in [-1, 0, 3]:
    expectAssertion: discard initLargeFactorial[Mint](blockSize = blockSize)
  var uninitialized: LargeFactorial[Mint]
  expectAssertion: discard uninitialized.fact(0)

proc checkModulusChange[T: BarrettModint or MontgomeryModint](M: typedesc[T]) =
  T.setMod(101)
  let first = initLargeFactorial[T]()
  T.setMod(103)
  let second = initLargeFactorial[T]()
  doAssert second.fact(102).val == 102
  expectAssertion: discard first.fact(0)
  T.setMod(101)
  doAssert first.fact(100).val == 100
  expectAssertion: discard second.fact(0)

checkModulusChange(modint_barrett)
checkModulusChange(modint_montgomery)
