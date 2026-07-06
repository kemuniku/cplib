# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/topk_sum_heapq

let top = initTopKHeapq(@[5, 1, 3, 7], 2)
assert top.sm == 16
assert top.topk == 12
assert top.k == 2
top.incl(6)
assert top.sm == 22
assert top.topk == 13
top.excl(7)
assert top.sm == 15
assert top.topk == 11
top.addK()
assert top.k == 3
assert top.topk == 14
top.minusK()
assert top.k == 2
assert top.topk == 11
top.setK(1)
assert top.k == 1
assert top.topk == 6
