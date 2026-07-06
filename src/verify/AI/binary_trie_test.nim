# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/binary_trie

var trie = initBineryTrie(3)
trie.incl(1)
trie.incl(4)
trie.incl(7, 2)
assert trie.len == 4
assert trie.count(7) == 2
assert trie.contains(4)
assert not trie.contains(2)
assert trie.get_kth(0) == 1
assert trie.get_kth(1) == 4
assert trie.get_kth(2) == 7
assert trie[3] == 7
assert trie.get_kth(4) == -1
assert trie.get_kth(1, 2) == 7
assert trie.lowerBound(4) == 1
assert trie.upperBound(4) == 2
assert trie.lowerBound(5, 2) == 1
assert trie.upperBound(5, 2) == 3
trie.excl(7)
assert trie.count(7) == 1
assert $trie == "@[(1, 1), (4, 1), (7, 1)]"
