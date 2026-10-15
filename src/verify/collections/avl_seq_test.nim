# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
include cplib/collections/avl_seq
import random

proc check(node: AvlSeqNode[int]): (int, int) =
    if node.isNil: return (0, 0)
    let (leftHeight, leftSize) = check(node.left)
    let (rightHeight, rightSize) = check(node.right)
    doAssert abs(leftHeight - rightHeight) <= 1
    doAssert node.height == max(leftHeight, rightHeight) + 1
    doAssert node.size == leftSize + rightSize + 1
    (node.height, node.size)

block:
    let empty = initAvlSeq(newSeq[int]())
    let (left, right) = empty.split(0)
    doAssert empty.len == 0
    doAssert merge(left, right).len == 0
    empty.insert(0, 42)
    doAssert empty[^1] == 42
    empty.erase(0)
    doAssert empty.toSeq.len == 0

block:
    var tree = @[1, 2, 3].toAvlSeq
    doAssert tree.len == 3
    doAssert tree[^1] == 3
    tree[^2] = 5
    doAssert tree.toSeq == @[1, 5, 3]
    tree.insert(1, 4)
    doAssert tree.toSeq == @[1, 4, 5, 3]
    tree.erase(1..2)
    doAssert tree.toSeq == @[1, 3]
    doAssert $tree == "1 3"

block:
    var rng = initRand(20261017)
    var tree = initAvlSeq(newSeq[int]())
    var values: seq[int]
    for step in 0..<5000:
        let n = values.len
        let index = rng.rand(n)
        case rng.rand(0..5)
        of 0, 1:
            let value = rng.rand(0..1000)
            tree.insert(index, value)
            values.insert(value, index)
        of 2:
            if n > 0:
                tree.erase(index mod n)
                values.delete(index mod n)
        of 3:
            let right = rng.rand(index..n)
            tree.erase(index, right)
            values = values[0..<index] & values[right..<n]
        of 4:
            if n > 0:
                let value = rng.rand(0..1000)
                tree[index mod n] = value
                values[index mod n] = value
        else:
            let (left, right) = tree.split(index)
            doAssert tree.len == 0
            doAssert left.toSeq == values[0..<index]
            doAssert right.toSeq == values[index..<n]
            tree = merge(left, right)
            doAssert left.len == 0 and right.len == 0
        doAssert tree.len == values.len
        doAssert tree.toSeq == values
        if step mod 43 == 0:
            doAssert check(tree.root)[1] == values.len

block:
    var tree = initAvlSeq(newSeq[int]())
    var values: seq[int]
    var rng = initRand(20261018)
    for step in 0..<2000:
        let value = rng.rand(0..100)
        var expected = 0
        while expected < values.len and values[expected] <= value: inc expected
        doAssert tree.insort(value) == expected
        values.insert(value, expected)
        if step mod 37 == 0:
            let k = rng.rand(values.len)
            let (left, right) = tree.split(k)
            doAssert left.toSeq == values[0..<k]
            doAssert right.toSeq == values[k..<values.len]
            tree = merge(left, right)
            doAssert check(tree.root)[1] == values.len
        doAssert tree.toSeq == values
    let descending = initAvlSeq(@[5, 3, 3, 1])
    doAssert descending.insort(3, proc(a, b: int): bool = a > b) == 3
    doAssert descending.toSeq == @[5, 3, 3, 3, 1]

echo "Hello World"
