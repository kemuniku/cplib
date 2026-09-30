# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/weightedunionfind

proc makeUnionFind(): WeightedUnionFind[int] =
    result = initWeightedUnionFind(6)
    doAssert result.unite(0, 1, 10)
    doAssert result.unite(2, 3, 20)
    doAssert result.unite(0, 2, 30)
    doAssert result.unite(4, 5, -7)

block:
    var uf = makeUnionFind()
    doAssert uf.diff(0, 3) == 50
    doAssert uf.diff(3, 0) == -50
    doAssert uf.diff(1, 3) == 40
    doAssert uf.diff(3, 2) == -20
    doAssert uf.diff(3, 3) == 0
    doAssert uf.diff(4, 5) == -7
    doAssert uf.diff(5, 4) == 7
    doAssert uf.count == 2
    doAssert uf.siz(3) == 4
    doAssert uf.unite(1, 3, 40)
    doAssert not uf.unite(1, 3, 41)

block:
    var uf = makeUnionFind()
    doAssert uf.diff(3, 0) == -50

block:
    var uf = initWeightedUnionFind(4, int64)
    doAssert uf.unite(0, 1, 10'i64)
    doAssert uf.unite(2, 3, -20'i64)
    doAssert uf.unite(0, 2, 30'i64)
    doAssert uf.diff(0, 3) == 10'i64
    doAssert uf.diff(3, 1) == 0'i64

echo "Hello World"
