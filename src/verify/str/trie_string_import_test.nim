# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/str/trie_string
import hashes

type Symbol = distinct int
proc hash(x: Symbol): Hash = hash(int(x))
proc `==`(a, b: Symbol): bool = int(a) == int(b)
proc `<`(a, b: Symbol): bool = int(a) < int(b)

let arrayTrie = initTrieStringArray('a'..'z')
let a = arrayTrie.root.add('a')
let ab = a.add('b')
doAssert a.compare(ab) == -1
doAssert a.lcp(ab) == 1 and ab.lcp(ab) == 2
doAssert ab.toString() == "ab" and ab.toSeq() == @['a', 'b']
doAssert ab[1] == 'b' and ab.prefix(1) == a
doAssert a.lcpNode(ab) == a and ab.pop() == a
doAssert a.add('b') == ab and a.length == 1
let tableTrie = initTrieStringTable(Symbol)
let x = tableTrie.root.add(Symbol(-1))
let y = tableTrie.root.add(Symbol(2))
doAssert x.compare(y) == -1 and x.lcp(y) == 0
doAssert x.lcp(x) == 1 and x.toSeq() == @[Symbol(-1)]
doAssert x[0] == Symbol(-1) and x.prefix(0) == tableTrie.root
doAssert x.lcpNode(y) == tableTrie.root and x.pop() == tableTrie.root
doAssert tableTrie.root.add(Symbol(-1)) == x
doAssert y.length == 1 and tableTrie.nodeCount == 3

proc escapedTable(): TrieStringTableNode[int] =
    let arena = initTrieStringTable(int)
    return arena.root.add(-1).add(2)

proc escapedArray(): TrieStringArrayNode['a'..'z'] =
    let arena = initTrieStringArray('a'..'z')
    return arena.root.add('a').add('b')

let ints = escapedTable()
let chars = escapedArray()
doAssert ints.toSeq() == @[-1, 2]
doAssert chars.toString() == "ab"
doAssert ints.pop().add(2) == ints
doAssert chars.pop().add('b') == chars
static:
    doAssert not compiles(a.owner)
    doAssert not compiles(a.id)
    doAssert not compiles(arrayTrie.add(0, 'a'))
    doAssert not compiles(arrayTrie.compare(0, 0))
    doAssert not compiles(a.compare(x))
    doAssert not compiles(a.compare(initTrieStringArray('a'..'b').root))
echo "Hello World"
