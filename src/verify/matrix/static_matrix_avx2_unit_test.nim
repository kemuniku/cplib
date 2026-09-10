# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/modint/modint
import cplib/matrix/static_matrix_avx2 as fixed
import cplib/matrix/matrix_avx2 as dynamic
import options, random
var rng = initRand(73519)
proc check[H: static int,W: static int,T]() =
    for trial in 0..<5:
        var a = fixed.initMatrix[H,W,T]()
        var b = dynamic.initMatrix[T](H,W)
        for i in 0..<H:
            for j in 0..<W:
                let v = T.init(if trial == 0: 0 else: rng.rand(100))
                a[i,j] = v
                b[i,j] = v
        let saved = a
        doAssert a.rank == b.rank
        var rhs = newSeq[T](H)
        for i in 0..<H: rhs[i] = T.init(rng.rand(10))
        let x = a.solveLinearSystem(rhs)
        let y = b.solveLinearSystem(rhs)
        doAssert x.isSome == y.isSome
        if x.isSome:
            doAssert x.get.basis.len == y.get.basis.len
            for i in 0..<W: doAssert x.get.particular[i].val == y.get.particular[i].val
            for k in 0..<x.get.basis.len:
                for i in 0..<W: doAssert x.get.basis[k][i].val == y.get.basis[k][i].val
        for n in 0..min(H,W):
            var c = dynamic.initMatrix[T](n,n)
            for i in 0..<n:
                for j in 0..<n: c[i,j] = a[i,j]
            doAssert a.determinant(n).val == c.determinant.val
            let inv = a.inverse(n)
            let refInv = c.inverse
            doAssert inv.isSome == refInv.isSome
            let adj = a.adjugate(n)
            let refAdj = c.adjugate
            for i in 0..<H:
                for j in 0..<W:
                    doAssert adj[i,j].val == (if i < n and j < n: refAdj[i,j].val else: 0)
                    if inv.isSome:
                        doAssert inv.get[i,j].val == (if i < n and j < n: refInv.get[i,j].val else: 0)
        doAssert a == saved
        var right = fixed.initMatrix[W,H,T]()
        var refRight = dynamic.initMatrix[T](W,H)
        for i in 0..<W:
            for j in 0..<H:
                right[i,j] = T.init(rng.rand(100))
                refRight[i,j] = right[i,j]
        let product = a * right
        let refProduct = b * refRight
        for i in 0..<H:
            for j in 0..<H: doAssert product[i,j].val == refProduct[i,j].val
    var a = fixed.initMatrix[H,W,T]()
    for n in countup(0,min(H,W),2):
        var b = dynamic.initMatrix[T](n,n)
        for i in 0..<n:
            for j in 0..<i:
                let v = T.init(rng.rand(100))
                a[i,j] = v
                a[j,i] = v
                b[i,j] = v
                b[j,i] = v
        doAssert a.hafnian(n).val == b.hafnian.val

template run(T: typedesc) =
    check[0,0,T]()
    check[0,9,T]()
    check[9,0,T]()
    check[1,1,T]()
    check[2,2,T]()
    check[3,4,T]()
    check[4,4,T]()
    check[4,5,T]()
    check[5,4,T]()
    check[7,9,T]()
    check[9,7,T]()
    check[17,18,T]()
run(modint998244353_montgomery)
run(modint1000000007_barrett)
for modulus in [3,17,1073741789]:
    modint_montgomery.setMod(modulus)
    run(modint_montgomery)
    modint_barrett.setMod(modulus)
    run(modint_barrett)
let a = fixed.toMatrix([[modint998244353_montgomery.init(1),modint998244353_montgomery.init(2)],[modint998244353_montgomery.init(3),modint998244353_montgomery.init(4)]])
doAssert a.pow(2) == a*a
doAssert a + a == a * modint998244353_montgomery.init(2)
doAssert a-a == fixed.initMatrix[2,2,modint998244353_montgomery]()
doAssert $a == "1 2\n3 4"
doAssert (a + modint998244353_montgomery.init(1)).sum.val == 14
modint_montgomery.setMod(17)
let stale = fixed.initMatrix[2,2,modint_montgomery]()
modint_montgomery.setMod(19)
template rejects(body: untyped) =
    block:
        var raised = false
        try: body
        except AssertionDefect: raised = true
        doAssert raised
rejects: discard stale.rank
rejects: discard stale.determinant
rejects: discard stale.inverse
rejects: discard stale.adjugate
rejects: discard stale.hafnian
rejects: discard stale.solveLinearSystem(@[modint_montgomery.init(0),modint_montgomery.init(0)])
echo "Hello World"
