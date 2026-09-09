# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/modint/modint
import cplib/matrix/matrix as plain
import cplib/matrix/matrix_avx2 as avx
import cplib/matrix/matrix_product_avx2 as product
import random, options

var rng = initRand(8042026)

proc randomElement[T](): T =
    let choice = rng.rand(3)
    result = T.init(if choice == 0: 0 elif choice == 1: 1 elif choice == 2: T.umod.int-1 else: rng.rand(T.umod.int-1))
    when T is MontgomeryModint:
        if rng.rand(1) == 1:
            let raw = cast[uint32](result)
            result = cast[T](if raw >= T.umod: raw - T.umod else: raw + T.umod)

proc compareMatrix[T](a: avx.Matrix[T], b: plain.Matrix[T]) =
    doAssert a.h == b.h and a.w == b.w
    for i in 0..<a.h:
        for j in 0..<a.w: doAssert a[i,j].val == b[i,j].val

proc compareSolution[T](a, b: Option[LinearSystemSolution[T]]) =
    doAssert a.isSome == b.isSome
    if a.isNone: return
    let x = a.get
    let y = b.get
    doAssert x.particular.len == y.particular.len and x.basis.len == y.basis.len
    for i in 0..<x.particular.len: doAssert x.particular[i].val == y.particular[i].val
    for i in 0..<x.basis.len:
        for j in 0..<x.particular.len: doAssert x.basis[i][j].val == y.basis[i][j].val

proc checkField[T]() =
    for n in [0,1,2,7,8,9,15,16,17,31,32,33]:
        for trial in 0..<4:
            var a = avx.initMatrix[T](n,n)
            var b = plain.initMatrix(n,n,T.init(0))
            for i in 0..<n:
                for j in 0..<n:
                    let value = if trial == 0: T.init(0) else: randomElement[T]()
                    a[i,j] = value
                    b[i,j] = value
            if n > 1 and trial == 1:
                for j in 0..<n:
                    a[n-1,j] = a[0,j]
                    b[n-1,j] = b[0,j]
            if n > 2 and trial == 2:
                for j in 0..<n:
                    a[n-1,j] = a[0,j]
                    a[n-2,j] = a[0,j]
                    b[n-1,j] = b[0,j]
                    b[n-2,j] = b[0,j]
            let saved = a
            doAssert a.rank == b.rank
            doAssert a.determinant.val == b.determinant.val
            compareMatrix(a.adjugate,b.adjugate)
            let ai = a.inverse
            let bi = b.inverse
            doAssert ai.isSome == bi.isSome
            if ai.isSome: compareMatrix(ai.get,bi.get)
            doAssert a == saved
    for (h,w) in [(0,9),(9,0),(3,65),(65,3),(8,17),(17,8),(31,33),(33,31)]:
        for trial in 0..<3:
            var a = avx.initMatrix[T](h,w)
            var b = plain.initMatrix(h,w,T.init(0))
            var rhs = newSeq[T](h)
            for i in 0..<h:
                rhs[i] = randomElement[T]()
                for j in 0..<w:
                    let value = if trial == 0: T.init(0) else: randomElement[T]()
                    a[i,j] = value
                    b[i,j] = value
            let saved = a
            doAssert a.rank == b.rank
            compareSolution(a.solveLinearSystem(rhs),b.solveLinearSystem(rhs))
            doAssert a == saved
    for n in [0,2,8,16,18,20]:
        var a = avx.initMatrix[T](n,n)
        var b = plain.initMatrix(n,n,T.init(0))
        for i in 0..<n:
            a[i,i] = T.init(1)
            b[i,i] = T.init(1)
            for j in 0..<i:
                let value = randomElement[T]()
                a[i,j] = value
                a[j,i] = value
                b[i,j] = value
                b[j,i] = value
        let saved = a
        doAssert a.hafnian.val == b.hafnian.val
        doAssert a == saved
    var a = avx.initMatrix[T](17,17)
    var b = plain.initMatrix(17,17,T.init(0))
    for i in 0..<17:
        a[i,i] = T.init(1)
        b[i,i] = T.init(1)
        for j in 0..<i:
            let zero = when T is MontgomeryModint: cast[T](T.umod) else: T.init(0)
            a[i,j] = zero
            b[i,j] = zero
    doAssert a.rank == 17 and a.determinant.val == 1
    compareMatrix(a*a,product.matrixProduct(b,b))

checkField[modint998244353_montgomery]()
checkField[modint998244353_barrett]()
checkField[modint1000000007_montgomery]()
checkField[modint1000000007_barrett]()
for modulus in [3,17,1073741789]:
    modint_montgomery.setMod(modulus)
    checkField[modint_montgomery]()
    modint_barrett.setMod(modulus)
    checkField[modint_barrett]()

template rejects(body: untyped) =
    block:
        var raised = false
        try: body
        except AssertionDefect: raised = true
        doAssert raised

modint_montgomery.setMod(17)
let stale = avx.initMatrix[modint_montgomery](2,2)
modint_montgomery.setMod(19)
rejects: discard stale.rank
rejects: discard stale.determinant
rejects: discard stale.inverse
rejects: discard stale.adjugate
rejects: discard stale.hafnian
rejects: discard stale.solveLinearSystem(@[modint_montgomery.init(0),modint_montgomery.init(0)])
echo "Hello World"
