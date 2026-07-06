# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/deletable_heapqueue

var hq = initDeletableHeapQueue[int]()
assert hq.len == 0
hq.push(5)
hq.push(1)
hq.push(3)
assert hq[0] == 1
assert hq.len == 3
hq.delete(3)
assert hq.len == 2
assert hq.pop() == 1
assert hq[0] == 5
hq.push(2)
assert hq.pop() == 2
assert hq.pop() == 5

var hq2 = toDeletableHeapQueue(@[4, 2, 6])
assert hq2[0] == 2
hq2.delete(2)
assert hq2[0] == 4
