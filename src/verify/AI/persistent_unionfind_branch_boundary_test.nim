# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/persistent_unionfind

proc checkBoundary(n, boundary: int) =
    let left = boundary - 1
    let right = boundary
    let last = n - 1
    let original = initPersistentUnionFind(n)
    let first = original.unite(left, right)
    let sibling = original.unite(0, last)
    let merged = first.unite(right, last)
    let redundant = merged.unite(left, last)
    let selfUnion = first.unite(right, right)
    doAssert original.count == n
    doAssert first.count == n - 1
    doAssert sibling.count == n - 1
    doAssert merged.count == n - 2
    doAssert redundant.count == merged.count
    doAssert selfUnion.count == first.count
    for x in [0, left, right, last]:
        doAssert original.root(x) == x
        doAssert original.siz(x) == 1
        doAssert first.root(x) == (if x == right: left else: x)
        doAssert first.siz(x) == (if x == left or x == right: 2 else: 1)
        doAssert sibling.root(x) == (if x == last: 0 else: x)
        doAssert sibling.siz(x) == (if x == 0 or x == last: 2 else: 1)
        doAssert merged.root(x) == (if x == right or x == last: left else: x)
        doAssert merged.siz(x) == (if x == left or x == right or x == last: 3 else: 1)
        doAssert redundant.root(x) == merged.root(x)
        doAssert redundant.siz(x) == merged.siz(x)
        doAssert selfUnion.root(x) == first.root(x)
        doAssert selfUnion.siz(x) == first.siz(x)
        for y in [0, left, right, last]:
            doAssert original.issame(x, y) == (x == y)
            doAssert first.issame(x, y) == (first.root(x) == first.root(y))
            doAssert sibling.issame(x, y) == (sibling.root(x) == sibling.root(y))
            doAssert merged.issame(x, y) == (merged.root(x) == merged.root(y))
    redundant.count = -1
    selfUnion.count = -2
    doAssert merged.count == n - 2
    doAssert first.count == n - 1
    doAssert original.count == n

for n in [0, 1, 7, 8, 9, 63, 64, 65, 511, 512, 513, 4095, 4096, 4097]:
    let original = initPersistentUnionFind(n)
    doAssert original.count == n
    if n > 0:
        let same = original.unite(n - 1, n - 1)
        doAssert same.root(n - 1) == n - 1
        doAssert same.siz(n - 1) == 1
        doAssert same.count == n
    if n > 1:
        let endpoints = original.unite(0, n - 1)
        doAssert endpoints.count == n - 1
        doAssert endpoints.root(n - 1) == 0
        doAssert endpoints.siz(n - 1) == 2
        for x in 0..<n:
            doAssert original.root(x) == x
            doAssert original.siz(x) == 1
            doAssert endpoints.root(x) == (if x == n - 1: 0 else: x)
            doAssert endpoints.siz(x) == (if x == 0 or x == n - 1: 2 else: 1)
        for boundary in [8, 64, 512, 4096]:
            if boundary + 1 < n:
                checkBoundary(n, boundary)

for boundary in [8, 64, 512, 4096, 32768, 262144, 2097152, 16777216, 134217728, 1073741824]:
    checkBoundary(int32.high.int, boundary)
let sparse = initPersistentUnionFind(int32.high.int)
let endpoints = sparse.unite(0, int32.high.int - 1)
doAssert endpoints.count == int32.high.int - 1
doAssert endpoints.root(int32.high.int - 1) == 0
doAssert endpoints.siz(0) == 2
doAssert sparse.root(int32.high.int - 1) == int32.high.int - 1
doAssert sparse.siz(0) == 1

echo "Hello World"
