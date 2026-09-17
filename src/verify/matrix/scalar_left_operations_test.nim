# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/matrix/matrix as dynamicMatrix
import cplib/matrix/static_matrix as staticMatrix

let d = dynamicMatrix.initMatrix(@[@[2, 3], @[4, 5]])
let s = staticMatrix.initMatrix([[2, 3], [4, 5]])
assert (10 - d) == dynamicMatrix.initMatrix(@[@[8, 7], @[6, 5]])
assert (10 - s) == staticMatrix.initMatrix([[8, 7], [6, 5]])

template checkScalarLeft(op: untyped) =
    block:
        let ld = op(19, d)
        let ls = op(19, s)
        let rd = op(d, 2)
        let rs = op(s, 2)
        for i in 0..<2:
            for j in 0..<2:
                assert ld[i, j] == op(19, d[i, j])
                assert ls[i, j] == op(19, s[i, j])
                assert rd[i, j] == op(d[i, j], 2)
                assert rs[i, j] == op(s[i, j], 2)
checkScalarLeft(`+`)
checkScalarLeft(`-`)
checkScalarLeft(`div`)
checkScalarLeft(`mod`)
checkScalarLeft(`shl`)
checkScalarLeft(`shr`)
checkScalarLeft(`and`)
checkScalarLeft(`or`)
checkScalarLeft(`xor`)
assert d == dynamicMatrix.initMatrix(@[@[2, 3], @[4, 5]])
assert s == staticMatrix.initMatrix([[2, 3], [4, 5]])
let fd = dynamicMatrix.initMatrix(@[@[1.5, -2.0]])
let fs = staticMatrix.initMatrix([[1.5, -2.0]])
assert 3.0 - fd == dynamicMatrix.initMatrix(@[@[1.5, 5.0]])
assert 3.0 - fs == staticMatrix.initMatrix([[1.5, 5.0]])
let empty = dynamicMatrix.initMatrix(0, 3, 0)
let emptyResult = 10 - empty
assert emptyResult.h == 0 and emptyResult.w == 3
let emptyStatic = staticMatrix.initMatrix[0, 3, int](0)
assert (10 - emptyStatic).h == 0
