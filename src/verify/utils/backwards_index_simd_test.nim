# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/bitset_avx2
import cplib/collections/bitset_avx512
import cplib/collections/staticbitset_avx2
import cplib/collections/staticbitset_avx512
import cplib/collections/fenwick_avx2
import cplib/collections/waveletmatrix_fenwick
import cplib/matrix/matrix_avx2
import cplib/modint/modint

template checkBits(init: untyped) =
    block:
        var b = init
        b[^1] = true
        b[^130] = 1
        doAssert b[^1] and b[^130]
        doAssert b[129] and b[0]
checkBits(bitset_avx2.initBitSet(130))
checkBits(bitset_avx512.initBitSet(130))
checkBits(staticbitset_avx2.initBitSet(130))
checkBits(staticbitset_avx512.initBitSet(130))
var f = initFenwickTreeAvx2(@[1, 2, 3])
f[^1] = 7
doAssert f[^1] == 7 and f[2] == 7
let w = initWaveletMatrixFenwick(@[(1, 2), (3, 4)])
w[^1] = 9
doAssert w[^1] == 9 and w[1] == 9
var m = initMatrix[modint998244353_montgomery](2, 3)
m[0][^1] = 42
m[0][^1] += 1
doAssert m[0][2].val == 43
let frozen = m
let row = frozen[0]
doAssert row[^1].val == 43

echo "Hello World"
