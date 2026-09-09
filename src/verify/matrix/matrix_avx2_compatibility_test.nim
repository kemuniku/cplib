# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/modint/modint
import cplib/matrix/matrix as legacy
import cplib/matrix/matrix_avx2 as fast

proc checkCompatibility[T]() =
    ## 関数APIと新旧Matrixを同時にimportしても名前解決できることを確認する。
    let rows = @[@[T.init(1), T.init(2)], @[T.init(3), T.init(4)]]
    let oldMatrix = legacy.initMatrix(rows)
    let newMatrix = fast.initMatrix(rows)
    let oldProduct = fast.matrixProduct(oldMatrix, oldMatrix)
    let oldProductExplicit = fast.matrixProduct[T](oldMatrix, oldMatrix)
    let newProduct = fast.matrixProduct(newMatrix, newMatrix)
    let newProductExplicit = fast.matrixProduct[T](newMatrix, newMatrix)
    for i in 0 ..< 2:
        for j in 0 ..< 2:
            doAssert oldProduct[i, j].val == newProduct[i, j].val
            doAssert oldProductExplicit[i, j].val == oldProduct[i, j].val
    doAssert newProductExplicit == newProduct
    doAssert fast.toMatrix(rows) == newMatrix
    doAssert fast.initMatrix[T](2, 2, 1)[0, 0].val == 1
    doAssert fast.initMatrix(@[T.init(1), T.init(2)], true).h == 2
    doAssert fast.identity_matrix[T](2) * newMatrix == newMatrix
    doAssert newMatrix.pow(2) == newProduct
    doAssert (5 - newMatrix)[0, 0].val == 4

proc checkLegacyShapes[T]() =
    ## 従来のMatrixへの結果復元が矩形と空行列に対応し、入力を変更しないことを確認する。
    let a = legacy.initMatrix(@[
        @[T.init(1), T.init(2), T.init(3)],
        @[T.init(4), T.init(5), T.init(6)]])
    let b = legacy.initMatrix(@[
        @[T.init(7), T.init(8), T.init(9), T.init(10)],
        @[T.init(11), T.init(12), T.init(13), T.init(14)],
        @[T.init(15), T.init(16), T.init(17), T.init(18)]])
    let savedA = a
    let savedB = b
    var c = fast.matrixProduct(a, b)
    let expected = [[74, 80, 86, 92], [173, 188, 203, 218]]
    doAssert c.h == 2 and c.w == 4
    for i in 0 ..< c.h:
        for j in 0 ..< c.w:
            doAssert c[i, j].val == expected[i][j]
    doAssert a == savedA and b == savedB
    c[0, 0] = T.init(99)
    doAssert a == savedA and b == savedB
    for i in 0 ..< a.h:
        for j in 0 ..< a.w:
            doAssert a[i, j].val == 1 + i * 3 + j
    for i in 0 ..< b.h:
        for j in 0 ..< b.w:
            doAssert b[i, j].val == 7 + i * 4 + j
    for shape in [(0, 0, 0), (4, 0, 0), (3, 2, 0), (0, 3, 4), (2, 0, 5)]:
        let (h, w, k) = shape
        let emptyA = legacy.initMatrix[T](h, w, T.init(0))
        let emptyB = legacy.initMatrix[T](w, k, T.init(0))
        let emptyC = fast.matrixProduct(emptyA, emptyB)
        doAssert emptyC.h == h and emptyC.w == k

checkCompatibility[modint998244353_montgomery]()
checkCompatibility[modint1000000007_barrett]()
checkLegacyShapes[modint998244353_montgomery]()
checkLegacyShapes[modint1000000007_barrett]()
doAssert fast.matrixProduct(@[2u32], @[2u32], 1, 1, 1) == @[4u32]
doAssert fast.matrixProduct(@[@[2u32]], @[@[2u32]]) == @[@[4u32]]
echo "Hello World"
