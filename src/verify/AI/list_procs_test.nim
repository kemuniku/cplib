# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import lists, sequtils
import cplib/utils/list_procs

var l = initDoublyLinkedList[int]()
let n1 = newDoublyLinkedNode(1)
let n3 = newDoublyLinkedNode(3)
let n0 = newDoublyLinkedNode(0)
let n2 = newDoublyLinkedNode(2)
l.append(n1)
l.append(n3)
l.insertPrev(n1, n0)
l.insert(n1, n2)
assert l.toSeq == @[0, 1, 2, 3]
assert l.head == n0
assert l.tail == n3
assert n2.prev == n1
assert n2.next == n3
