import cplib/modint/modint
import options, random, sequtils
when defined(testStaticMatrix):
    import cplib/matrix/static_matrix
elif defined(testAvxMatrix):
    import cplib/matrix/matrix_avx2
else:
    import cplib/matrix/matrix

type Mint = modint998244353_montgomery

proc bruteDet(a: seq[seq[Mint]]): Mint =
    if a.len == 0: return Mint(1)
    for col in 0..<a.len:
        var minor: seq[seq[Mint]]
        for i in 1..<a.len:
            var row: seq[Mint]
            for j in 0..<a.len:
                if j != col: row.add(a[i][j])
            minor.add(row)
        if col mod 2 == 0: result += a[0][col]*bruteDet(minor)
        else: result -= a[0][col]*bruteDet(minor)

proc bruteHaf(a: seq[seq[Mint]], vertices: seq[int]): Mint =
    if vertices.len == 0: return Mint(1)
    for k in 1..<vertices.len:
        var rest: seq[int]
        for i in 1..<vertices.len:
            if i != k: rest.add(vertices[i])
        result += a[vertices[0]][vertices[k]]*bruteHaf(a, rest)

proc checkSquare[N: static int](rng: var Rand) =
    for trial in 0..<50:
        var rows = newSeqWith(N, newSeq[Mint](N))
        for i in 0..<N:
            for j in 0..<N: rows[i][j] = Mint(rng.rand(4))
        if trial mod 3 == 0 and N > 1: rows[N-1] = rows[0]
        when defined(testStaticMatrix):
            var a: StaticMatrix[N,N,Mint]
        else:
            var a = initMatrix(N,N,Mint(0))
        for i in 0..<N:
            for j in 0..<N: a[i,j] = rows[i][j]
        let before = a
        let det = bruteDet(rows)
        doAssert a.determinant.val == det.val
        let adj = a.adjugate
        for i in 0..<N:
            for j in 0..<N:
                var minor: seq[seq[Mint]]
                for r in 0..<N:
                    if r == j: continue
                    var row: seq[Mint]
                    for c in 0..<N:
                        if c != i: row.add(rows[r][c])
                    minor.add(row)
                var expected = bruteDet(minor)
                if (i+j) mod 2 != 0: expected = -expected
                doAssert adj[i,j].val == expected.val, $N & " " & $trial & " " & $rows & " at " & $i & "," & $j & " actual=" & $adj[i,j] & " expected=" & $expected
        let inv = a.inverse
        doAssert inv.isSome == (det.val != 0)
        if inv.isSome:
            for i in 0..<N:
                for j in 0..<N:
                    var v = Mint(0)
                    for k in 0..<N: v += a[i,k]*inv.get[k,j]
                    doAssert v.val == int(i==j)
        doAssert a == before
        when N mod 2 == 0:
            for i in 0..<N:
                for j in 0..<i:
                    rows[j][i] = rows[i][j]
                    a[j,i] = rows[i][j]
            doAssert a.hafnian.val == bruteHaf(rows, toSeq(0..<N)).val

proc checkRect[H: static int, W: static int](rng: var Rand) =
    for trial in 0..<80:
        when defined(testStaticMatrix):
            var a: StaticMatrix[H,W,Mint]
        else:
            var a = initMatrix(H,W,Mint(0))
        var b = newSeq[Mint](H)
        var known = newSeq[Mint](W)
        for j in 0..<W: known[j] = Mint(rng.rand(3))
        for i in 0..<H:
            for j in 0..<W:
                a[i,j] = Mint(rng.rand(2))
                b[i] += a[i,j]*known[j]
        if trial mod 3 == 0 and H > 0: b[H-1] += 1
        let before = a
        let answer = a.solveLinearSystem(b)
        let rank = a.rank
        if answer.isSome:
            let s = answer.get
            doAssert s.particular.len == W
            doAssert s.basis.len == W-rank
            for i in 0..<H:
                var value = Mint(0)
                for j in 0..<W: value += a[i,j]*s.particular[j]
                doAssert value.val == b[i].val
                for v in s.basis:
                    value = Mint(0)
                    for j in 0..<W: value += a[i,j]*v[j]
                    doAssert value.val == 0
            var leaders: seq[int]
            for v in s.basis:
                var last = -1
                for j in 0..<W:
                    if v[j].val != 0: last = j
                doAssert last >= 0 and last notin leaders
                leaders.add(last)
        else:
            doAssert trial mod 3 == 0 and H > 0
        doAssert a == before

var rng = initRand(123456)
checkSquare[0](rng)
checkSquare[1](rng)
checkSquare[2](rng)
checkSquare[3](rng)
checkSquare[4](rng)
checkSquare[5](rng)
checkSquare[6](rng)
checkRect[0,0](rng)
checkRect[0,3](rng)
checkRect[3,0](rng)
checkRect[2,4](rng)
checkRect[4,2](rng)
checkRect[4,4](rng)
template checkOtherField(T: typedesc) =
    block:
        when defined(testStaticMatrix):
            var a: StaticMatrix[2,2,T]
        else:
            var a = initMatrix(2,2,T(0))
        a[0,0] = T(2)
        a[0,1] = T(3)
        a[1,0] = T(3)
        a[1,1] = T(4)
        doAssert a.determinant.val == T(-1).val
        doAssert a.rank == 2
        doAssert a.inverse.get[0,0].val == T(-4).val
        doAssert a.adjugate[0,1].val == T(-3).val
        doAssert a.hafnian.val == T(3).val
        let solution = a.solveLinearSystem(@[T(5),T(7)]).get
        doAssert solution.basis.len == 0
        doAssert solution.particular[0].val == T(1).val
        doAssert solution.particular[1].val == T(1).val
        a[1,0] = T(2)+T(7)-T(7)
        a[1,1] = T(3)
        doAssert a.rank == 1
        doAssert a.determinant.val == 0
        doAssert a.inverse.isNone
        doAssert a.solveLinearSystem(@[T(0),T(1)]).isNone
        doAssert a.adjugate[1,0].val == T(-2).val

checkOtherField(modint998244353_barrett)
modint_montgomery.setMod(17)
checkOtherField(modint_montgomery)
modint_barrett.setMod(17)
checkOtherField(modint_barrett)
when not defined(testAvxMatrix):
    modint_barrett.setMod(2)
    checkOtherField(modint_barrett)
when defined(testStaticMatrix):
    var padded: StaticMatrix[5,6,Mint]
    padded[0,1] = Mint(2)
    padded[1,0] = Mint(3)
    padded[4,5] = Mint(123)
    doAssert padded.rank(2,3) == 2
    doAssert padded.determinant(2).val == Mint(-6).val
    doAssert padded.inverse(2).get[4,5].val == 0
    doAssert padded.adjugate(2)[4,5].val == 0
    doAssert padded.solveLinearSystem(@[Mint(0),Mint(0)],2,3).get.basis.len == 1
else:
    let empty = initMatrix(0,3,Mint(0))
    doAssert (-empty).w == 3
    doAssert empty != initMatrix(0,2,Mint(0))
echo "Hello World"
