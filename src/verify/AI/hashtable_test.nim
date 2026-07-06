# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import algorithm
import cplib/collections/hashtable

var ht = initHashTable[string, int]()
assert ht.len == 0
ht["a"] = 1
ht["b"] = 2
ht["a"] = 3
assert ht.len == 2
assert ht["a"] == 3
ht["a"] += 4
assert ht["a"] == 7
assert ht.contains("b")
assert ht.hasKey("a")
ht.del("b")
assert not ht.contains("b")
for i in 0..20:
  ht[$i] = i
assert not ht.contains("b")
assert ht["20"] == 20

var keys: seq[string]
for k in ht.keys:
  keys.add(k)
keys.sort()
assert "a" in keys
assert "20" in keys

var valList: seq[int]
for v in values(ht):
  valList.add(v)
valList.sort()
assert 7 in valList
assert 20 in valList

var pairs: seq[(string, int)]
for p in ht.pairs:
  pairs.add(p)
assert ("a", 7) in pairs

let oldHash = hash(ht)
assert oldHash == hash(ht)
ht.clear()
assert ht.len == 0

var ht2 = initHashTable[int, int](10)
ht2.incl((1, 2))
ht2.incl((1, 5))
assert ht2.len == 1
assert ht2[1] == 5
ht2.excl(1)
assert not ht2.hasKey(1)
