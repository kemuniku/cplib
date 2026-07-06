# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import algorithm, sequtils
import cplib/graph/graph
import cplib/str/compressed_trie
import cplib/str/static_string

let words = toStaticStrings(@["a", "ab", "ab", "ac", "b"])
let root = initCompressedTrie(words)
let vr = root.get_virtualnode
assert vr.get_cnt == 0
assert vr.get_subtree_sum == 5
assert vr.has_child('a')
assert vr.has_child('b')

let va = vr.get_child('a')
assert va.get_cnt == 1
assert va.get_subtree_sum == 4
assert va.has_child('b')
assert va.has_child('c')
assert va.get_child('b').get_cnt == 2
assert va.get_child('c').get_cnt == 1
assert vr.get_child('b').get_cnt == 1

let g = root.toGraph()
assert g.len >= 3
assert toSeq(g[0]).mapIt($it[1]).sorted == @["a", "b"]
