include cplib/tmpl/fastio
import cplib/modint/modint
import options
when defined(testStaticAvxMatrix):
    import cplib/matrix/static_matrix_avx2
elif defined(testStaticMatrix):
    import cplib/matrix/static_matrix
elif defined(testAvxMatrix):
    import cplib/matrix/matrix_avx2
else:
    import cplib/matrix/matrix

type Mint = modint998244353_montgomery
let n = input(int)
when matrixProblem in ["matrix_rank", "system_of_linear_equations"]:
    let m = input(int)
else:
    let m = n

template solve(a: untyped) =
    for i in 0..<n:
        for j in 0..<m: a[i,j] = Mint(input(int))
    when matrixProblem == "matrix_det":
        when defined(testStaticMatrix): echo a.determinant(n)
        else: echo a.determinant
    elif matrixProblem == "matrix_rank":
        when defined(testStaticMatrix): echo a.rank(n,m)
        else: echo a.rank
    elif matrixProblem == "hafnian_of_matrix":
        when defined(testStaticMatrix): echo a.hafnian(n)
        else: echo a.hafnian
    elif matrixProblem == "system_of_linear_equations":
        var b = newSeq[Mint](n)
        for i in 0..<n: b[i] = Mint(input(int))
        when defined(testStaticMatrix):
            let answer = a.solveLinearSystem(b,n,m)
        else:
            let answer = a.solveLinearSystem(b)
        if answer.isNone: echo -1
        else:
            let s = answer.get
            echo s.basis.len
            for j in 0..<m:
                if j > 0: stdout.write " "
                stdout.write $s.particular[j]
            stdout.write "\n"
            for v in s.basis:
                for j in 0..<m:
                    if j > 0: stdout.write " "
                    stdout.write $v[j]
                stdout.write "\n"
    else:
        when matrixProblem == "inverse_matrix":
            when defined(testStaticMatrix):
                let answer = a.inverse(n)
            else:
                let answer = a.inverse
        else:
            when defined(testStaticMatrix):
                let answer = some(a.adjugate(n))
            else:
                let answer = some(a.adjugate)
        if answer.isNone: echo -1
        else:
            let value = answer.get
            for i in 0..<n:
                for j in 0..<n:
                    if j > 0: stdout.write " "
                    stdout.write $value[i,j]
                stdout.write "\n"

when defined(testStaticMatrix):
    proc run[H: static int, W: static int]() =
        var storage: ref StaticMatrix[H,W,Mint]
        new storage
        solve(storage[])
    when matrixProblem == "matrix_rank":
        if n <= m:
            if n <= 1: run[1,250000]()
            elif n <= 2: run[2,250000]()
            elif n <= 4: run[4,125000]()
            elif n <= 8: run[8,62500]()
            elif n <= 16: run[16,31250]()
            elif n <= 32: run[32,15625]()
            elif n <= 64: run[64,7812]()
            elif n <= 128: run[128,3906]()
            elif n <= 256: run[256,1953]()
            else: run[512,976]()
        else:
            if m <= 1: run[250000,1]()
            elif m <= 2: run[250000,2]()
            elif m <= 4: run[125000,4]()
            elif m <= 8: run[62500,8]()
            elif m <= 16: run[31250,16]()
            elif m <= 32: run[15625,32]()
            elif m <= 64: run[7812,64]()
            elif m <= 128: run[3906,128]()
            elif m <= 256: run[1953,256]()
            else: run[976,512]()
    elif matrixProblem == "hafnian_of_matrix": run[38,38]()
    else: run[500,500]()
else:
    var a = initMatrix(n,m,Mint(0))
    solve(a)
