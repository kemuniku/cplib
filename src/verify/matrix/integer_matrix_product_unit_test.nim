# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/matrix/matrix
import cplib/modint/modint
import sequtils
import verify/matrix/integer_product/oracle

proc checkDynamic[T]() =
    var rng = initRand(55710)
    for h in [0, 1, 2, 7]:
        for k in [0, 1, 3, 8]:
            for w in [0, 1, 2, 3, 4, 9]:
                var aa = newSeqWith(h, newSeq[T](k))
                var bb = newSeqWith(k, newSeq[T](w))
                var a = initMatrix[T](h, k, T(0))
                var b = initMatrix[T](k, w, T(0))
                for i in 0..<h:
                    for j in 0..<k:
                        aa[i][j] = T(rng.rand(0..5))
                        a[i, j] = aa[i][j]
                for i in 0..<k:
                    for j in 0..<w:
                        bb[i][j] = T(rng.rand(0..5))
                        b[i, j] = bb[i][j]
                let expected = oracle(aa, bb, h, k, w)
                let originalA = a
                let originalB = b
                let c = a * b
                doAssert c.h == h and c.w == w
                for i in 0..<h:
                    for j in 0..<w: doAssert c[i, j] == expected[i][j]
                doAssert a == originalA and b == originalB
                a *= b
                doAssert a == c and b == originalB
    var a = initMatrix[T](2, 2, T(0))
    a[0, 0] = T(1)
    a[0, 1] = T(2)
    a[1, 0] = T(3)
    a[1, 1] = T(4)
    let expected = oracle(@[@[T(1), T(2)], @[T(3), T(4)]],
                          @[@[T(1), T(2)], @[T(3), T(4)]], 2, 2, 2)
    a *= a
    for i in 0..<2:
        for j in 0..<2: doAssert a[i, j] == expected[i][j]

template checkType(T: typedesc) =
    checkDynamic[T]()

checkType(int)
checkType(int8)
checkType(int16)
checkType(int32)
checkType(int64)
checkType(uint)
checkType(uint8)
checkType(uint16)
checkType(uint32)
checkType(uint64)
checkType(float64)
checkType(modint998244353_montgomery)

block:
    let a = initMatrix[int](@[@[int.high div 4, -7], @[8, -3]])
    let b = initMatrix[int](@[@[2, 0, -1, 0], @[0, -1, 0, -2]])
    let expected = oracle(@[@[int.high div 4, -7], @[8, -3]],
                          @[@[2, 0, -1, 0], @[0, -1, 0, -2]], 2, 2, 4)
    let c = a * b
    for i in 0..<2:
        for j in 0..<4: doAssert c[i, j] == expected[i][j]
block:
    let a = initMatrix[uint64](@[@[uint64.high, 7'u64], @[8'u64, 3'u64]])
    let b = initMatrix[uint64](@[@[2'u64, 3'u64], @[5'u64, 7'u64]])
    let expected = oracle(@[@[uint64.high, 7'u64], @[8'u64, 3'u64]],
                          @[@[2'u64, 3'u64], @[5'u64, 7'u64]], 2, 2, 2)
    let c = a * b
    for i in 0..<2:
        for j in 0..<2: doAssert c[i, j] == expected[i][j]
    let b4 = initMatrix[uint64](@[@[2'u64, 3'u64, 5'u64, 7'u64],
                                         @[5'u64, 7'u64, 11'u64, 13'u64]])
    let expected4 = oracle(@[@[uint64.high, 7'u64], @[8'u64, 3'u64]],
                           @[@[2'u64, 3'u64, 5'u64, 7'u64],
                             @[5'u64, 7'u64, 11'u64, 13'u64]], 2, 2, 4)
    let c4 = a * b4
    for i in 0..<2:
        for j in 0..<4: doAssert c4[i, j] == expected4[i][j]

echo "Hello World"
