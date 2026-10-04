# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, bitops
import cplib/convolution/subset_convolution
import cplib/modint/modint

proc oracle(a, b: seq[int], modulus: int): seq[int] =
    result = newSeq[int](a.len)
    for mask in 0..<a.len:
        var sub = mask
        while true:
            result[mask] = int((uint64(result[mask]) + uint64(a[sub]) * uint64(b[mask xor sub])) mod uint64(modulus))
            if sub == 0: break
            sub = (sub - 1) and mask

proc check[T](a, b: seq[int]) =
    var left, right = newSeq[T](a.len)
    for i in 0..<a.len:
        left[i] = init(T, a[i])
        right[i] = init(T, b[i])
    let expected = oracle(a, b, T.umod.int)
    let actual = subsetConvolution(left, right)
    let square = subsetConvolution(left, left)
    let squareExpected = oracle(a, a, T.umod.int)
    for i in 0..<a.len:
        doAssert actual[i].val == expected[i]
        doAssert square[i].val == squareExpected[i]
        doAssert left[i].val == a[i] and right[i].val == b[i]

for n in 0..3:
    let size = 1 shl n
    for x in 0..<(1 shl size):
        for y in 0..<(1 shl size):
            var a, b = newSeq[int](size)
            for i in 0..<size:
                a[i] = (x shr i) and 1
                b[i] = (y shr i) and 1
            var expected = newSeq[int](size)
            for mask in 0..<size:
                var sub = mask
                while true:
                    expected[mask] += a[sub] * b[mask xor sub]
                    if sub == 0: break
                    sub = (sub - 1) and mask
            doAssert subsetConvolution(a, b) == expected

var rng = initRand(937)
modint_barrett.setMod(998244353)
modint_montgomery.setMod(998244353)
for n in 0..9:
    for repeat in 0..<20:
        var a, b = newSeq[int](1 shl n)
        for i in 0..<a.len:
            a[i] = rng.rand(998244352)
            b[i] = rng.rand(998244352)
        check[modint998244353_barrett](a, b)
        check[modint998244353_montgomery](a, b)
        check[modint_barrett](a, b)
        check[modint_montgomery](a, b)
    for edge in [0, 1, 998244352]:
        var a, b = newSeq[int](1 shl n)
        for i in 0..<a.len: a[i] = edge
        b[0] = 1
        check[modint998244353_barrett](a, b)
        check[modint998244353_montgomery](a, b)
        for i in 0..<b.len: b[i] = edge
        check[modint998244353_barrett](a, b)
        check[modint998244353_montgomery](a, b)
for modulus in [2, 3, 5, 9, 1000000007]:
    modint_barrett.setMod(modulus)
    for repeat in 0..<20:
        var a, b = newSeq[int](64)
        for i in 0..<a.len:
            a[i] = rng.rand(modulus - 1)
            b[i] = rng.rand(modulus - 1)
        check[modint_barrett](a, b)
    if modulus mod 2 == 1:
        modint_montgomery.setMod(modulus)
        for repeat in 0..<20:
            var a, b = newSeq[int](64)
            for i in 0..<a.len:
                a[i] = rng.rand(modulus - 1)
                b[i] = rng.rand(modulus - 1)
            check[modint_montgomery](a, b)
for repeat in 0..<30:
    var a, b = newSeq[int](256)
    for i in 0..<a.len:
        a[i] = rng.rand(8) - 4
        b[i] = rng.rand(8) - 4
    var expected = newSeq[int](a.len)
    for i in 0..<a.len:
        for j in 0..<a.len:
            if (i and j) == 0: expected[i or j] += a[i] * b[j]
    doAssert subsetConvolution(a, b) == expected
var overflowed = false
try: discard subsetConvolution(@[high(int)], @[2])
except OverflowDefect: overflowed = true
doAssert overflowed
echo "Hello World"
