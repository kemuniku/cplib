# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import options, sequtils
import cplib/collections/avlset_old

var s = initAvlSortedSet[int](@[3, 1, 3])
assert s.toSeq == @[1, 3]
assert s.len == 2
assert s.incl(2)
assert not s.incl(2)
assert s.toSeq == @[1, 2, 3]
assert s.lowerBound(2) == 1
assert s.upperBound(2) == 2
assert s.index(3) == 2
assert s.index_right(3) == 3
assert s.count(2) == 1
assert s.lt(2).get == 1
assert s.le(2).get == 2
assert s.gt(2).get == 3
assert s.ge(2).get == 2
assert 2 in s
assert s[1] == 2
assert s[^1] == 3
assert s.pop(1) == 2
assert s.excl(3)
assert s.toSeq == @[1]

var ms = initAvlSortedMultiSet[int](@[2, 1, 2])
assert ms.toSeq == @[1, 2, 2]
assert ms.count(2) == 2
ms.incl(2)
assert ms.count(2) == 3
assert ms.pop() == 2
assert ms.excl(2)
assert ms.toSeq == @[1, 2]
