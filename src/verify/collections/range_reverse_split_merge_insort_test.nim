# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sequtils
import cplib/collections/[range_reverse_array, range_reverse_array_monoid, range_reverse_lazysegtree, range_reverse_dualsegtree]

proc maximum(a, b: int): int = max(a, b)
proc add(f, x: int): int = f + x
proc compose(f, g: int): int = f + g
proc descending(a, b: int): bool = a > b
proc concat(a, b: string): string = a & b

template checkBasic(treeExpr: untyped) =
    block:
        let original = treeExpr
        original.reverse(1, 4)
        let (left, right) = original.split(2)
        doAssert original.len == 0
        doAssert left.toSeq == @[1, 4]
        doAssert right.toSeq == @[3, 2, 5]
        let joined = merge(left, right)
        doAssert left.len == 0 and right.len == 0
        doAssert joined.toSeq == @[1, 4, 3, 2, 5]
        let (empty, all) = joined.split(0)
        doAssert empty.len == 0 and all.toSeq == @[1, 4, 3, 2, 5]
        let restored = merge(empty, all)
        let (allAgain, emptyAgain) = restored.split(restored.len)
        doAssert allAgain.toSeq == @[1, 4, 3, 2, 5] and emptyAgain.len == 0
        doAssert merge(allAgain, emptyAgain).toSeq == @[1, 4, 3, 2, 5]

checkBasic(initRangeReverseArray(@[1, 2, 3, 4, 5]))
checkBasic(initRangeReverseArrayMonoid(@[1, 2, 3, 4, 5], maximum, low(int)))
checkBasic(initRangeReverseLazySegmentTree(@[1, 2, 3, 4, 5], maximum, low(int), add, compose, 0))
checkBasic(initRangeReverseDualSegmentTree(@[1, 2, 3, 4, 5], add, compose, 0))

template checkInsort(treeExpr: untyped) =
    block:
        let tree = treeExpr
        tree.reverse(0, tree.len)
        doAssert tree.insort(2) == 3
        doAssert tree.insort(0) == 0
        doAssert tree.insort(5) == 6
        doAssert tree.toSeq == @[0, 1, 2, 2, 2, 4, 5]
        let descendingTree = treeExpr
        doAssert descendingTree.insort(3, descending) == 1

checkInsort(initRangeReverseArray(@[4, 2, 2, 1]))
checkInsort(initRangeReverseArrayMonoid(@[4, 2, 2, 1], maximum, low(int)))
checkInsort(initRangeReverseLazySegmentTree(@[4, 2, 2, 1], maximum, low(int), add, compose, 0))
checkInsort(initRangeReverseDualSegmentTree(@[4, 2, 2, 1], add, compose, 0))

block:
    let empty = initRangeReverseArray(newSeq[int]())
    let (left, right) = empty.split(0)
    doAssert merge(left, right).len == 0
    empty.insert(0, 10)
    doAssert empty.toSeq == @[10]

block:
    let tree = initRangeReverseArrayMonoid(@["a", "b", "c", "d"], concat, "")
    tree.reverse(0, 4)
    let (left, right) = tree.split(2)
    doAssert left.fold == "dc" and right.fold == "ba"
    let joined = merge(left, right)
    doAssert joined.fold == "dcba"
    joined.reverse(1, 4)
    doAssert joined.fold == "dabc"

block:
    let lazy = initRangeReverseLazySegmentTree(@[1, 2, 3, 4], maximum, low(int), add, compose, 0)
    lazy.apply(0, 4, 10)
    lazy.reverse(0, 4)
    let (left, right) = lazy.split(2)
    doAssert left.toSeq == @[14, 13] and right.toSeq == @[12, 11]
    let joined = merge(left, right)
    doAssert joined.toSeq == @[14, 13, 12, 11]
    doAssert joined.fold == 14
    joined.reverse(0, 4)
    doAssert joined.insort(13) == 3
    doAssert joined.toSeq == @[11, 12, 13, 13, 14]

block:
    let dual = initRangeReverseDualSegmentTree(@[1, 2, 3, 4], add, compose, 0)
    dual.apply(0, 4, 10)
    dual.reverse(0, 4)
    let (left, right) = dual.split(2)
    doAssert left.toSeq == @[14, 13] and right.toSeq == @[12, 11]
    let joined = merge(left, right)
    joined.reverse(0, 4)
    doAssert joined.insort(13) == 3
    doAssert joined.toSeq == @[11, 12, 13, 13, 14]

block:
    let lazy = initRangeReverseLazySegmentTree(@[1, 2, 3, 4], maximum, low(int), add, compose, 0)
    lazy.apply(0, 4, 10)
    doAssert lazy.insort(13) == 3
    doAssert lazy.toSeq == @[11, 12, 13, 13, 14]
    let dual = initRangeReverseDualSegmentTree(@[1, 2, 3, 4], add, compose, 0)
    dual.apply(0, 4, 10)
    doAssert dual.insort(13) == 3
    doAssert dual.toSeq == @[11, 12, 13, 13, 14]

template checkRandomReverse(treeExpr: untyped) =
    block:
        var tree = treeExpr
        var values = (0..<40).toSeq
        var rng = initRand(20261016)
        for step in 0..<1000:
            let l = rng.rand(values.len)
            let r = rng.rand(l..values.len)
            tree.reverse(l, r)
            var i = l
            var j = r - 1
            while i < j:
                swap(values[i], values[j])
                inc i
                dec j
            let k = rng.rand(values.len)
            let (left, right) = tree.split(k)
            doAssert left.toSeq == values[0..<k]
            doAssert right.toSeq == values[k..<values.len]
            tree = merge(left, right)
            doAssert tree.toSeq == values

let initial = (0..<40).toSeq
checkRandomReverse(initRangeReverseArray(initial))
checkRandomReverse(initRangeReverseArrayMonoid(initial, maximum, low(int)))
checkRandomReverse(initRangeReverseLazySegmentTree(initial, maximum, low(int), add, compose, 0))
checkRandomReverse(initRangeReverseDualSegmentTree(initial, add, compose, 0))

echo "Hello World"
