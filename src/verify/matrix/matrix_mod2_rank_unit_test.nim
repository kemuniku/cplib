# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/matrix/matrix_mod2
import cplib/matrix/field_matrix_ops
import random, sequtils, strutils

var rng = initRand(712053)
for (h, w) in [(0,0), (0,129), (256,0), (255,65), (256,7), (256,8), (257,9),
        (256,63), (257,64), (256,65), (257,129), (320,257), (511,33)]:
    for trial in 0..<5:
        var rows = newSeqWith(h, newSeq[bool](w))
        var a = initMatrixMod2(h,w)
        for i in 0..<h:
            for j in 0..<w:
                var value = trial > 0 and rng.rand(1) == 1
                if trial == 2 and i >= 7:
                    value = rows[i mod 7][j] xor rows[(i+1) mod 7][j]
                if trial == 3 and (j < 67 or j mod 8 < 4): value = false
                if trial == 4: value = j == w-1
                rows[i][j] = value
                a[i,j] = value
        let before = a
        let expected = fieldRank(rows,w)
        doAssert a.rank == expected
        doAssert a == before

for n in [256,257,320]:
    var a = initMatrixMod2(n,n)
    for i in 0..<n:
        a[i,n-1-i] = true
        for j in n-i..<n: a[i,j] = rng.rand(1) == 1
    let before = a
    doAssert a.rank == n
    doAssert a.determinant
    doAssert a == before
    a.setRowBits(n-1, a.rowBits(0))
    let singular = a
    doAssert a.rank == n-1
    doAssert not a.determinant
    doAssert a == singular

for width in [0,1,7,8,63,64,65,129,193,257]:
    var a = initMatrixMod2(2,width)
    for length in [0,1,7,8,63,64,65,129,193,257]:
        if length > width: continue
        a.setRowBits(0,repeat('1',width))
        a.setRowBits(1,repeat('1',width))
        var text = newString(length)
        for j in 0..<length: text[j] = "01x"[rng.rand(2)]
        a.setRowBits(0,text)
        for j in 0..<width:
            doAssert a[0,j] == (j < length and text[j] == '1')
            doAssert a[1,j]

echo "Hello World"
