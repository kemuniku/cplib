# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/persistent_binary_trie

let t0 = initPersistentBineryTrie(3)
let t1 = t0.incl(1)
let t2 = t1.incl(4).incl(7, 2)
assert t0.count(1) == 0
assert t1.contains(1)
assert not t1.contains(4)
assert t2.count(7) == 2
assert t2.get_kth(0) == 1
assert t2.get_kth(1) == 4
assert t2.get_kth(2) == 7
assert t2.get_kth(1, 2) == 7
assert t2.lowerBound(4) == 1
assert t2.upperBound(4) == 2
let t3 = t2.excl(7)
assert t2.count(7) == 2
assert t3.count(7) == 1
let t4 = t3.set_value(4, 3)
assert t4.count(4) == 3
assert t4.RLE() == @[(1, 1), (4, 3), (7, 1)]
assert $t4 == "@[(1, 1), (4, 3), (7, 1)]"
