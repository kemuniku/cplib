include cplib/tmpl/fastio
import options
when defined(testStaticMatrixMod2):
    import cplib/matrix/static_matrix_mod2
else:
    import cplib/matrix/matrix_mod2

proc bits(values: seq[bool]): string =
    result = newString(values.len)
    for i, value in values: result[i] = char(ord('0') + int(value))

let n = input(int)
let m = input(int)
when defined(testStaticMatrixMod2):
    var storage: ref StaticMatrixMod2[4096, 4096]
    new storage
    template a: untyped = storage[]
else:
    var a = initMatrixMod2(n, m)
for i in 0..<n:
    a.setRowBits(i, input(string))
let rhs = input(string)
var b = newSeq[bool](n)
for i in 0..<n: b[i] = rhs[i] == '1'
when defined(testStaticMatrixMod2):
    let answer = a.solveLinearSystem(b, n, m)
else:
    let answer = a.solveLinearSystem(b)
if answer.isNone:
    print -1
else:
    let solution = answer.get
    print solution.basis.len
    print bits(solution.particular)
    for vector in solution.basis: print bits(vector)
