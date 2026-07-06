# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/avltreenode

proc newNode(x: int): AvlTreeNode[int] =
  AvlTreeNode[int](h: 1, len: 1, key: x)

var root: AvlTreeNode[int] = nil
let n2 = newNode(2)
let n1 = newNode(1)
let n3 = newNode(3)
root = root.insert(n2)
root = root.insert(n1)
root = root.insert(n3)

assert root.rootOf == root
assert root.len == 3
assert root.get(0).key == 1
assert root.get(1).key == 2
assert root.get(2).key == 3
assert root.get(3).isNil
assert root.get(1).index == 1
assert root.get(1).prev.key == 1
assert root.get(1).next.key == 3

let (lbLeft, lbRight) = root.lower_bound_node(2)
assert lbLeft.key == 1
assert lbRight.key == 2
let (ubLeft, ubRight) = root.upper_bound_node(2)
assert ubLeft.key == 2
assert ubRight.key == 3

let erased = root.get(1)
root = root.erase(erased, erased.next)
assert root.len == 2
assert root.get(0).key == 1
assert root.get(1).key == 3
assert erased.l.isNil and erased.r.isNil and erased.p.isNil
