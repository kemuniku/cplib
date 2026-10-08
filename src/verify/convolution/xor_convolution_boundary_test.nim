# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import random, sequtils
import cplib/convolution/xor_convolution
import cplib/modint/modint

assert xorConvolution(@[2], @[3]) == @[6]
assert xorConvolution(@[-2], @[3]) == @[-6]
var singleton = @[7]
FastHadamardTransForm(singleton)
assert singleton == @[7]
let a = @[modint998244353_montgomery.init(2)]
let b = @[modint998244353_montgomery.init(3)]
assert xorConvolution(a, b)[0].val == 6

var rng = initRand(4900)
for power in 0..5:
    let n = 1 shl power
    for trial in 0..<20:
        let a = newSeqWith(n, rng.rand(-10..10))
        let b = newSeqWith(n, rng.rand(-10..10))
        var expected = newSeq[int](n)
        for i in 0..<n:
            for j in 0..<n:
                expected[i xor j] += a[i] * b[j]
        assert xorConvolution(a, b) == expected

template expectAssertion(body: untyped) =
    block:
        var raised = false
        try:
            body
        except AssertionDefect:
            raised = true
        assert raised

expectAssertion:
    discard xorConvolution(@[1, 2], @[3])
expectAssertion:
    discard xorConvolution(@[1, 2, 3], @[4, 5, 6])
expectAssertion:
    discard xorConvolution(newSeq[int](), newSeq[int]())
expectAssertion:
    var invalid = @[1, 2, 3]
    FastHadamardTransForm(invalid)

proc checkModular[T: BarrettModint or MontgomeryModint](M: typedesc[T]) =
    for power in 0..5:
        let n = 1 shl power
        let a = newSeqWith(n, M.init(rng.rand(-100..100)))
        let b = newSeqWith(n, M.init(rng.rand(-100..100)))
        let beforeA = a.mapIt(it.val)
        let beforeB = b.mapIt(it.val)
        var expected = newSeq[T](n)
        for i in 0..<n:
            for j in 0..<n: expected[i xor j] += a[i] * b[j]
        assert xorConvolution(a, b).mapIt(it.val) == expected.mapIt(it.val)
        assert a.mapIt(it.val) == beforeA and b.mapIt(it.val) == beforeB

checkModular(modint998244353_barrett)
checkModular(modint998244353_montgomery)
modint_barrett.setMod(101)
modint_montgomery.setMod(101)
checkModular(modint_barrett)
checkModular(modint_montgomery)
assert xorConvolution(@[1.25, -2.5], @[-0.5, 1.0]) == @[-3.125, 2.5]
