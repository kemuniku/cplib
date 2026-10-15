# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
include cplib/collections/avl_monoid
import random, sequtils

proc add(a, b: int): int = a + b

proc check(node: AvlMonoidNode[int]): (int, int, int) =
    if node.isNil: return (0, 0, 0)
    let (leftHeight, leftSize, leftProd) = check(node.left)
    let (rightHeight, rightSize, rightProd) = check(node.right)
    doAssert abs(leftHeight - rightHeight) <= 1
    doAssert node.height == max(leftHeight, rightHeight) + 1
    doAssert node.size == leftSize + rightSize + 1
    doAssert node.prod == leftProd + node.value + rightProd
    (node.height, node.size, node.prod)

var rng = initRand(20261015)
var tree = initAvlMonoid(newSeqWith(20000, 1), add, 0)
var length = tree.len
for step in 0..<20000:
    let index = rng.rand(0..<length)
    case step mod 5
    of 0, 1:
        tree.insert(index, rng.rand(1..100))
        inc length
    of 2:
        tree.erase(index)
        dec length
    of 3:
        tree.erase(index, min(length, index + 2))
        length -= min(2, length - index)
    else:
        tree[index] = rng.rand(1..100)
    if step mod 100 == 0:
        let k = rng.rand(length)
        let (left, right) = tree.split(k)
        doAssert check(left.root)[1] == k
        doAssert check(right.root)[1] == length - k
        tree = merge(left, right)
        let (_, size, product) = check(tree.root)
        doAssert size == length
        doAssert tree.get_all == product

echo "Hello World"
