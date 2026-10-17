# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/matrix/static_matrix
import cplib/modint/modint
import sequtils
import verify/matrix/integer_product/oracle

proc checkStatic[H, K, W: static int, T]() =
    var a: StaticMatrix[H, K, T]
    var b: StaticMatrix[K, W, T]
    var aa = newSeqWith(H, newSeq[T](K))
    var bb = newSeqWith(K, newSeq[T](W))
    for i in 0..<H:
        for j in 0..<K:
            aa[i][j] = T((i * 7 + j * 3) mod 6)
            a[i, j] = aa[i][j]
    for i in 0..<K:
        for j in 0..<W:
            bb[i][j] = T((i * 3 + j * 11) mod 6)
            b[i, j] = bb[i][j]
    let expected = oracle(aa, bb, H, K, W)
    let originalA = a
    let originalB = b
    let c = a * b
    for i in 0..<H:
        for j in 0..<W: doAssert c[i, j] == expected[i][j]
    doAssert a == originalA and b == originalB
    when K == W:
        a *= b
        doAssert a == c and b == originalB
    when H == K and K == W:
        var d = originalA
        let square = oracle(aa, aa, H, K, W)
        d *= d
        for i in 0..<H:
            for j in 0..<W: doAssert d[i, j] == square[i][j]

template checkType(T: typedesc) =
    checkStatic[0, 0, 0, T]()
    checkStatic[0, 3, 4, T]()
    checkStatic[2, 0, 4, T]()
    checkStatic[2, 3, 0, T]()
    checkStatic[1, 1, 1, T]()
    checkStatic[2, 3, 4, T]()
    checkStatic[3, 3, 3, T]()
    checkStatic[4, 4, 4, T]()
    checkStatic[8, 8, 8, T]()
    checkStatic[7, 8, 9, T]()

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
    let sa = initMatrix([[uint64.high, 7'u64], [8'u64, 3'u64]])
    let sb = initMatrix([[2'u64, 3'u64], [5'u64, 7'u64]])
    let expected = oracle(@[@[uint64.high, 7'u64], @[8'u64, 3'u64]],
                          @[@[2'u64, 3'u64], @[5'u64, 7'u64]], 2, 2, 2)
    let sc = sa * sb
    for i in 0..<2:
        for j in 0..<2: doAssert sc[i, j] == expected[i][j]

block:
    let a = initMatrix([[int.high div 4, -7], [8, -3]])
    let b = initMatrix([[2, 0, -1, 0], [0, -1, 0, -2]])
    let expected = oracle(@[@[int.high div 4, -7], @[8, -3]],
                          @[@[2, 0, -1, 0], @[0, -1, 0, -2]], 2, 2, 4)
    let c = a * b
    for i in 0..<2:
        for j in 0..<4: doAssert c[i, j] == expected[i][j]

block:
    var a: StaticMatrix[8, 8, uint64]
    var b: StaticMatrix[8, 8, uint64]
    var aa = newSeqWith(8, newSeq[uint64](8))
    var bb = newSeqWith(8, newSeq[uint64](8))
    for i in 0..<8:
        a[i, i] = uint64.high
        b[i, i] = 2'u64
        aa[i][i] = uint64.high
        bb[i][i] = 2'u64
    let expected = oracle(aa, bb, 8, 8, 8)
    a *= b
    for i in 0..<8:
        for j in 0..<8: doAssert a[i, j] == expected[i][j]

echo "Hello World"
