# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import options, sequtils
import cplib/collections/avlset

var ms = initAvlSortedMultiSet(@[3, 1, 2, 2])
assert ms.len == 4
assert ms.toSeq == @[1, 2, 2, 3]
assert ms.count(2) == 2
assert ms.lowerBound(2) == 1
assert ms.upperBound(2) == 3
assert ms.index(3) == 3
assert ms.index_right(2) == 3
assert ms.lt(2).get == 1
assert ms.le(2).get == 2
assert ms.gt(2).get == 3
assert ms.ge(2).get == 2
assert ms[0] == 1
assert ms[^1] == 3
assert ms.pop(1) == 2
assert ms.excl(2)
assert not ms.excl(4)
assert $ms == "1 3"

var st = initAvlSortedSet(@[2, 1, 2])
assert st.len == 2
assert st.toSeq == @[1, 2]
assert not st.incl(2)
assert st.incl(3)
assert st.contains(3)
assert st.pop() == 3
