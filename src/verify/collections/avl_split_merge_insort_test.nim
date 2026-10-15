# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/collections/[avl_monoid, avl_lazysegtree, avl_dualsegtree]

proc concat(a, b: string): string = a & b
proc maximum(a, b: int): int = max(a, b)
proc add(f, x: int): int = f + x
proc compose(f, g: int): int = f + g
proc descending(a, b: int): bool = a > b

block:
    let original = initAvlMonoid(@["a", "b", "c", "d"], concat, "")
    let (left, right) = original.split(2)
    doAssert original.len == 0
    doAssert left.toSeq == @["a", "b"]
    doAssert right.toSeq == @["c", "d"]
    doAssert left.fold == "ab"
    let joined = merge(left, right)
    doAssert left.len == 0 and right.len == 0
    doAssert joined.fold == "abcd"
    let (empty, all) = joined.split(0)
    doAssert empty.len == 0 and all.toSeq == @["a", "b", "c", "d"]
    let restored = merge(empty, all)
    let (allAgain, emptyAgain) = restored.split(restored.len)
    doAssert allAgain.fold == "abcd" and emptyAgain.len == 0
    doAssert merge(allAgain, emptyAgain).toSeq == @["a", "b", "c", "d"]

block:
    let emptyTree = initAvlMonoid(newSeq[int](), maximum, low(int))
    let (emptyLeft, emptyRight) = emptyTree.split(0)
    doAssert merge(emptyLeft, emptyRight).len == 0
    let tree = initAvlMonoid(@[1, 2, 2, 4], maximum, low(int))
    doAssert tree.insort(2) == 3
    doAssert tree.insort(0) == 0
    doAssert tree.insort(5) == 6
    doAssert tree.toSeq == @[0, 1, 2, 2, 2, 4, 5]
    let descendingTree = initAvlMonoid(@[5, 3, 3, 1], maximum, low(int))
    doAssert descendingTree.insort(3, descending) == 3
    doAssert descendingTree.toSeq == @[5, 3, 3, 3, 1]

block:
    let original = initAvlLazySegmentTree(@[1, 2, 3, 4], maximum, low(int), add, compose, 0)
    original.apply(0, 4, 10)
    let (left, right) = original.split(2)
    doAssert original.len == 0
    doAssert left.toSeq == @[11, 12] and right.toSeq == @[13, 14]
    doAssert left.fold == 12 and right.fold == 14
    let joined = merge(left, right)
    doAssert left.len == 0 and right.len == 0
    doAssert joined.insort(13) == 3
    doAssert joined.toSeq == @[11, 12, 13, 13, 14]
    joined.apply(1, 4, 1)
    doAssert joined.toSeq == @[11, 13, 14, 14, 14]
    let (empty, all) = joined.split(0)
    doAssert empty.len == 0 and all.toSeq == @[11, 13, 14, 14, 14]
    let restored = merge(empty, all)
    let (allAgain, emptyAgain) = restored.split(restored.len)
    doAssert merge(allAgain, emptyAgain).toSeq == @[11, 13, 14, 14, 14]
    let descendingTree = initAvlLazySegmentTree(@[5, 3, 3, 1], maximum, low(int), add, compose, 0)
    doAssert descendingTree.insort(3, descending) == 3
    doAssert descendingTree.toSeq == @[5, 3, 3, 3, 1]
    let pending = initAvlLazySegmentTree(@[1, 2, 3, 4], maximum, low(int), add, compose, 0)
    pending.apply(0, 4, 10)
    doAssert pending.insort(13) == 3
    doAssert pending.toSeq == @[11, 12, 13, 13, 14]

block:
    let original = initAvlDualSegmentTree(@[1, 2, 3, 4], add, compose, 0)
    original.apply(0, 4, 10)
    let (left, right) = original.split(2)
    doAssert original.len == 0
    doAssert left.toSeq == @[11, 12] and right.toSeq == @[13, 14]
    let joined = merge(left, right)
    doAssert left.len == 0 and right.len == 0
    doAssert joined.insort(13) == 3
    doAssert joined.toSeq == @[11, 12, 13, 13, 14]
    joined.apply(1, 4, 1)
    doAssert joined.toSeq == @[11, 13, 14, 14, 14]
    let (empty, all) = joined.split(0)
    doAssert empty.len == 0 and all.toSeq == @[11, 13, 14, 14, 14]
    let restored = merge(empty, all)
    let (allAgain, emptyAgain) = restored.split(restored.len)
    doAssert merge(allAgain, emptyAgain).toSeq == @[11, 13, 14, 14, 14]
    let descendingTree = initAvlDualSegmentTree(@[5, 3, 3, 1], add, compose, 0)
    doAssert descendingTree.insort(3, descending) == 3
    doAssert descendingTree.toSeq == @[5, 3, 3, 3, 1]
    let pending = initAvlDualSegmentTree(@[1, 2, 3, 4], add, compose, 0)
    pending.apply(0, 4, 10)
    doAssert pending.insort(13) == 3
    doAssert pending.toSeq == @[11, 12, 13, 13, 14]

block:
    var rng = initRand(20261015)
    var tree = initAvlMonoid(newSeq[int](), maximum, low(int))
    var values: seq[int]
    for step in 0..<1000:
        let value = rng.rand(0..100)
        var expected = 0
        while expected < values.len and values[expected] <= value: inc expected
        doAssert tree.insort(value) == expected
        values.insert(value, expected)
        if step mod 31 == 0:
            let k = rng.rand(values.len)
            let (left, right) = tree.split(k)
            doAssert left.toSeq == values[0..<k]
            doAssert right.toSeq == values[k..<values.len]
            let combined = merge(left, right)
            let (empty, all) = combined.split(0)
            let restored = merge(empty, all)
            let (a, b) = restored.split(restored.len)
            let finalTree = merge(a, b)
            doAssert finalTree.toSeq == values
            tree = finalTree
        doAssert tree.toSeq == values

template checkUpdatedSorted(treeExpr: untyped) =
    block:
        var tree = treeExpr
        var values: seq[int]
        var rng = initRand(20261016)
        for step in 0..<1000:
            case step mod 3
            of 0:
                let value = rng.rand(0..200)
                var expected = 0
                while expected < values.len and values[expected] <= value: inc expected
                doAssert tree.insort(value) == expected
                values.insert(value, expected)
            of 1:
                let delta = rng.rand(0..3)
                tree.apply(0, tree.len, delta)
                for i in 0..<values.len: values[i] += delta
            else:
                let k = rng.rand(values.len)
                let (left, right) = tree.split(k)
                doAssert left.toSeq == values[0..<k]
                doAssert right.toSeq == values[k..<values.len]
                tree = merge(left, right)
            doAssert tree.toSeq == values

checkUpdatedSorted(initAvlLazySegmentTree(newSeq[int](), maximum, low(int), add, compose, 0))
checkUpdatedSorted(initAvlDualSegmentTree(newSeq[int](), add, compose, 0))

echo "Hello World"
