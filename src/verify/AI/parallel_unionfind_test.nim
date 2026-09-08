# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sequtils
import cplib/collections/parallel_unionfind

var rng = initRand(368415)
for n in [0, 1, 2, 3, 4, 5, 15, 16, 17, 63, 64, 65]:
    let uf = initParallelUnionFind(n)
    var labels = toSeq(0..<n)
    var sums = toSeq(1..n)
    var calls = 0
    proc onMerge(x, y: int) =
        doAssert x != y
        doAssert uf.root(x) == x and uf.root(y) == y
        doAssert uf.siz(x) >= uf.siz(y)
        sums[x] += sums[y]
        inc calls
    for query in 0..<200:
        let len = rng.rand(n)
        let a = rng.rand(n - len)
        let b = rng.rand(n - len)
        var merged = 0
        for i in 0..<len:
            let x = labels[a + i]
            let y = labels[b + i]
            if x != y:
                inc merged
                for j in 0..<n:
                    if labels[j] == y: labels[j] = x
        let before = calls
        if len == 1 and query mod 2 == 0:
            doAssert uf.unite(a, b, onMerge) == (merged != 0)
        else:
            doAssert uf.unite(a, b, len, onMerge) == merged
        doAssert calls - before == merged
        doAssert uf.count == n - calls
        doAssert uf.roots().len == uf.count
        for x in 0..<n:
            var size, sum: int
            for y in 0..<n:
                doAssert uf.issame(x, y) == (labels[x] == labels[y])
                if labels[x] == labels[y]:
                    inc size
                    sum += y + 1
            doAssert uf.siz(x) == size
            doAssert sums[uf.root(x)] == sum

let uf = initParallelUnionFind(20)
uf.unite(0, 5, 5)
let cp = uf.copy()
doAssert cp.unite(0, 10, 10) == 10
doAssert uf.count == 15
doAssert not uf.issame(0, 10)
doAssert uf.unite(0, 10)
doAssert not uf.unite(0, 10)
doAssert not cp.issame(0, 1)
cp.unite(0, 1, 19)
doAssert cp.count == 1
doAssert uf.count == 14
echo "Hello World"
