# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/str/trie_string
import hashes

type Symbol = distinct int
proc hash(x: Symbol): Hash = hash(int(x))
proc `==`(a, b: Symbol): bool = int(a) == int(b)
proc `<`(a, b: Symbol): bool = int(a) < int(b)

var arrayTrie = initTrieStringArray('a'..'z')
let a = arrayTrie.add(arrayTrie.root, 'a')
let ab = arrayTrie.add(a, 'b')
doAssert arrayTrie.compare(a, ab) == -1
doAssert arrayTrie.lcp(a, ab) == 1
doAssert arrayTrie.lcp(ab, ab) == 2
doAssert arrayTrie.toString(ab) == "ab"
doAssert arrayTrie.toSeq(ab) == @['a', 'b']
doAssert arrayTrie[ab, 1] == 'b'
doAssert arrayTrie.prefix(ab, 1) == a
doAssert arrayTrie.lcpNode(a, ab) == a
doAssert arrayTrie.pop(ab) == a
doAssert arrayTrie.add(a, 'b') == ab
var tableTrie = initTrieStringTable(Symbol)
let x = tableTrie.add(tableTrie.root, Symbol(-1))
let y = tableTrie.add(tableTrie.root, Symbol(2))
doAssert tableTrie.compare(x, y) == -1
doAssert tableTrie.lcp(x, y) == 0
doAssert tableTrie.lcp(x, x) == 1
doAssert tableTrie.toSeq(x) == @[Symbol(-1)]
doAssert tableTrie[x, 0] == Symbol(-1)
doAssert tableTrie.prefix(x, 0) == tableTrie.root
doAssert tableTrie.lcpNode(x, y) == tableTrie.root
doAssert tableTrie.pop(x) == tableTrie.root
doAssert tableTrie.add(0, Symbol(-1)) == x
doAssert tableTrie.length(y) == 1 and tableTrie.nodeCount == 3
stderr.writeLine "PASS: public import API and caller-defined symbol operators"

echo "Hello World"
