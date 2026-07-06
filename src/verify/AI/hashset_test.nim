# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import algorithm, sequtils
import cplib/collections/hashset

var hs = initHashSet[int]()
hs.incl(1)
hs.incl(2)
hs.incl(2)
assert hs.contains(1)
assert hs.contains(2)
hs.excl(1)
assert not hs.contains(1)
for i in 3..20:
  hs.incl(i)
assert not hs.contains(1)
assert hs.contains(20)

var items = toSeq(hs.items)
items.sort()
assert items[0] == 2
assert items[^1] == 20

var hs2 = toHashSet([5, 5, 6])
assert hs2.contains(5)
assert hs2.contains(6)
hs2.excl(5)
assert not hs2.contains(5)
