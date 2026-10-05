# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/convolution/convolution
import cplib/modint/modint

proc oracle[T](a, b: seq[T], cycle: int = 0): seq[T] =
    if a.len == 0 or b.len == 0:
        return newSeq[T](cycle)
    let size = if cycle == 0: a.len + b.len - 1 else: cycle
    var values = newSeq[int64](size)
    let modulus = T.umod.int64
    for i in 0..<a.len:
        for j in 0..<b.len:
            let index = if cycle == 0: i + j else: (i + j) mod cycle
            values[index] = (values[index] + a[i].val.int64 * b[j].val.int64) mod modulus
    result = newSeq[T](size)
    for i in 0..<size: result[i] = init(T, values[i])

proc check[T]() =
    var rng = initRand(930172)
    for size in [0, 1, 2, 7, 16, 31, 32, 33, 59, 60, 61, 63, 64, 65,
                 127, 128, 129, 255, 256, 257]:
        for pattern in 0..<5:
            var a = newSeq[T](size)
            for i in 0..<size:
                let value = case pattern
                    of 0: 0
                    of 1: 1
                    of 2: T.umod.int - 1
                    of 3: (if i mod 7 == 0: T.umod.int - 1 else: 0)
                    else: rng.rand(T.umod.int - 1)
                a[i] = init(T, value)
                when T is MontgomeryModint:
                    a[i] += T.umod.int - 1
                    a[i] += 1
            var before = newSeq[uint32](size)
            for i in 0..<size:
                before[i] = cast[ptr uint32](addr a[i])[]
            let expected = oracle(a, a)
            doAssert convolution(a, a) == expected
            var copy = newSeq[T](size)
            for i in 0..<size: copy[i] = a[i]
            doAssert convolution(a, copy) == expected
            for i in 0..<size:
                doAssert cast[ptr uint32](addr a[i])[] == before[i]
            var cycle = 1
            while cycle < max(1, size): cycle *= 2
            doAssert convolutionCyclicPowerOfTwo(a, a, cycle) == oracle(a, a, cycle)
    for dimensions in [(61, 129), (129, 61), (65, 128), (128, 65)]:
        var a = newSeq[T](dimensions[0])
        var b = newSeq[T](dimensions[1])
        for i in 0..<a.len: a[i] = init(T, rng.rand(T.umod.int - 1))
        for i in 0..<b.len: b[i] = init(T, rng.rand(T.umod.int - 1))
        doAssert convolution(a, b) == oracle(a, b)

check[modint998244353_barrett]()
check[modint998244353_montgomery]()
check[StaticBarrettModint[754974721u32]]()
check[StaticMontgomeryModint[469762049u32]]()
check[StaticBarrettModint[1000000007u32]]()
check[StaticBarrettModint[1000u32]]()
for modulus in [998244353, 167772161, 1000000007, 1001]:
    modint_barrett.setMod(modulus)
    modint_montgomery.setMod(modulus)
    check[modint_barrett]()
    check[modint_montgomery]()

proc kernel(output, left: ptr uint32, leftSize: csize_t,
            right: ptr uint32, rightSize, transformSize: csize_t,
            modulus, primitiveRoot: uint32, montgomeryRepresentation: bool
            ) {.importc: "cplib_convolution_ntt_friendly".}
var input = newSeq[uint32](65)
var expected = newSeq[modint998244353_barrett](65)
for i in 0..<input.len:
    input[i] = uint32(i * i + 7)
    expected[i] = init(modint998244353_barrett, input[i].int)
var output = newSeq[uint32](128)
kernel(addr output[0], addr input[0], 65, addr input[0], 64, 128,
       998244353, 3, false)
let product = oracle(expected, expected[0..<64])
for i in 0..<product.len: doAssert output[i].int == product[i].val

echo "Hello World"
