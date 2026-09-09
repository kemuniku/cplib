# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/persistent_unionfind
import std/[random, sequtils]

randomize(20260906)
doAssert initPersistentUnionFind(0).count == 0
for n in [1, 2, 15, 16, 17, 63, 64, 65, 255, 256, 257, 4095, 4096, 4097]:
    var versions = @[initPersistentUnionFind(n)]
    var labels = @[toSeq(0..<n)]
    for step in 0..<600:
        let k = if step mod 3 == 0: rand(versions.high) else: versions.high
        let u = rand(n - 1)
        let v = if step mod 7 == 0: u else: rand(n - 1)
        var expected = labels[k]
        let oldLabel = expected[v]
        let newLabel = expected[u]
        for x in expected.mitems:
            if x == oldLabel: x = newLabel
        versions.add(versions[k].unite(u, v))
        labels.add(expected)
        for ver in [k, versions.high, rand(versions.high)]:
            var sizes = newSeq[int](n)
            for x in labels[ver]: inc sizes[x]
            doAssert versions[ver].count == sizes.countIt(it > 0)
            for _ in 0..<20:
                let x = rand(n - 1)
                let y = rand(n - 1)
                let root = versions[ver].root(x)
                doAssert labels[ver][root] == labels[ver][x]
                doAssert versions[ver].root(root) == root
                doAssert versions[ver].siz(x) == sizes[labels[ver][x]]
                doAssert versions[ver].issame(x, y) == (labels[ver][x] == labels[ver][y])
    # 公開されている count を変更しても他バージョンには影響しない。
    let same = versions[0].unite(0, 0)
    same.count = -123
    doAssert versions[0].count == n
    var balanced = initPersistentUnionFind(n)
    var stride = 1
    while stride < n:
        var x = 0
        while x + stride < n:
            balanced = balanced.unite(x, x + stride)
            x += 2 * stride
        stride *= 2
    doAssert balanced.count == 1
    for x in 0..<n:
        doAssert balanced.root(x) == 0
        doAssert balanced.siz(x) == n
        doAssert balanced.issame(0, x)
echo "Hello World"
