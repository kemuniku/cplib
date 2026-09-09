# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/matrix/matrix_mod2
import cplib/matrix/static_matrix_mod2
import options, random, sequtils

proc bruteDet(a: seq[seq[bool]]): bool =
    if a.len == 0: return true
    for j in 0..<a.len:
        var minor: seq[seq[bool]]
        for r in 1..<a.len:
            var row: seq[bool]
            for c in 0..<a.len:
                if c != j: row.add(a[r][c])
            minor.add(row)
        result = result xor (a[0][j] and bruteDet(minor))

proc bruteHaf(a: seq[seq[bool]], vertices: seq[int]): bool =
    if vertices.len == 0: return true
    for k in 1..<vertices.len:
        var rest: seq[int]
        for i in 1..<vertices.len:
            if i != k: rest.add(vertices[i])
        result = result xor (a[vertices[0]][vertices[k]] and bruteHaf(a,rest))

proc check[N: static int](rng: var Rand) =
    for trial in 0..<100:
        var a = initMatrixMod2(N,N)
        var s: StaticMatrixMod2[N,N]
        var rows = newSeqWith(N,newSeq[bool](N))
        for i in 0..<N:
            for j in 0..<N:
                rows[i][j] = rng.rand(1) == 1
                a[i,j] = rows[i][j]
                s[i,j] = rows[i][j]
        let before = a
        let adj = a.adjugate
        let sadj = s.adjugate
        doAssert a.determinant == bruteDet(rows)
        doAssert s.determinant == a.determinant
        for i in 0..<N:
            for j in 0..<N:
                var minor: seq[seq[bool]]
                for r in 0..<N:
                    if r == j: continue
                    var row: seq[bool]
                    for c in 0..<N:
                        if c != i: row.add(rows[r][c])
                    minor.add(row)
                doAssert adj[i,j] == bruteDet(minor)
                doAssert sadj[i,j] == adj[i,j]
        var b = newSeq[bool](N)
        for i in 0..<N: b[i] = rng.rand(1) == 1
        let answer = a.solveLinearSystem(b)
        doAssert answer == s.solveLinearSystem(b)
        var count = 0
        for mask in 0..<(1 shl N):
            var valid = true
            for i in 0..<N:
                var value = false
                for j in 0..<N: value = value xor (a[i,j] and ((mask shr j) and 1) != 0)
                if value != b[i]: valid = false
            if valid: inc count
        doAssert answer.isSome == (count > 0)
        if answer.isSome:
            let solution = answer.get
            doAssert count == 1 shl solution.basis.len
            var represented: seq[int]
            for mask in 0..<(1 shl solution.basis.len):
                var vector = solution.particular
                for k,v in solution.basis:
                    if ((mask shr k) and 1) != 0:
                        for j in 0..<N: vector[j] = vector[j] xor v[j]
                var bits = 0
                for j in 0..<N:
                    if vector[j]: bits = bits or (1 shl j)
                doAssert bits notin represented
                represented.add(bits)
                for i in 0..<N:
                    var value = false
                    for j in 0..<N: value = value xor (a[i,j] and vector[j])
                    doAssert value == b[i]
        doAssert a == before
        when N mod 2 == 0:
            for i in 0..<N:
                for j in 0..<i:
                    rows[j][i] = rows[i][j]
                    a[j,i] = rows[i][j]
                    s[j,i] = rows[i][j]
            doAssert a.hafnian == bruteHaf(rows,toSeq(0..<N))
            doAssert s.hafnian == a.hafnian
var rng = initRand(234)
check[0](rng)
check[1](rng)
check[2](rng)
check[3](rng)
check[4](rng)
check[6](rng)
let empty = initMatrixMod2(0,5).solveLinearSystem(newSeq[bool]()).get
doAssert empty.particular.len == 5 and empty.basis.len == 5
doAssert initMatrixMod2(2,0).solveLinearSystem(@[false,true]).isNone
import cplib/matrix/field_matrix_ops
for (h, w) in [(0,0), (0,65), (65,0), (1,64), (64,1), (63,65), (65,63), (64,128), (128,64), (67,129)]:
    for trial in 0..<8:
        var a = initMatrixMod2(h,w)
        var padded: StaticMatrixMod2[131,133]
        for i in 0..<131:
            for j in 0..<133: padded[i,j] = true
        var rows = newSeqWith(h,newSeq[bool](w))
        var b = newSeq[bool](h)
        for i in 0..<h:
            b[i] = rng.rand(1) == 1
            for j in 0..<w:
                let value = trial != 0 and rng.rand(1) == 1
                a[i,j] = value
                padded[i,j] = value
                rows[i][j] = value
        let before = a
        let savedPadded = padded
        let expected = fieldSolve(rows,w,b)
        doAssert a.solveLinearSystem(b) == expected
        doAssert padded.solveLinearSystem(b,h,w) == expected
        doAssert a == before and padded == savedPadded

block:
    var a = initMatrixMod2(2,65)
    a[0,64] = true
    a[1,64] = true
    doAssert a.solveLinearSystem(@[false,true]).isNone
    let solution = a.solveLinearSystem(@[true,true]).get
    doAssert solution.particular[64] and solution.basis.len == 64

echo "Hello World"
