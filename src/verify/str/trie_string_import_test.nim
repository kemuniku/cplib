# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/str/trie_string
import hashes, heapqueue, algorithm

type Symbol = distinct int
proc hash(x: Symbol): Hash = hash(int(x))
proc `==`(a, b: Symbol): bool = int(a) == int(b)
proc `<`(a, b: Symbol): bool = int(a) < int(b)

let arrayTrie = initTrieStringArray('a'..'z')
let a = arrayTrie.root.add('a')
let ab = a.add('b')
doAssert a.cmp(ab) == -1
doAssert a.lcp(ab) == 1 and ab.lcp(ab) == 2
doAssert ($ab) == "ab" and ab.toSeq() == @['a', 'b']
doAssert ab[1] == 'b' and ab.prefix(1) == a
doAssert a.lcpNode(ab) == a and ab.pop() == a
doAssert a.add('b') == ab and a.length == 1
doAssert len(arrayTrie.root) == 0 and arrayTrie.root.len == 0
doAssert len(a) == 1 and ab.len == 2
doAssert ab.pop().len == 1 and ab.prefix(0).len == 0
let tableTrie = initTrieStringTable(Symbol)
let x = tableTrie.root.add(Symbol(-1))
let y = tableTrie.root.add(Symbol(2))
doAssert x.cmp(y) == -1 and x.lcp(y) == 0
doAssert x.lcp(x) == 1 and x.toSeq() == @[Symbol(-1)]
doAssert x[0] == Symbol(-1) and x.prefix(0) == tableTrie.root
doAssert x.lcpNode(y) == tableTrie.root and x.pop() == tableTrie.root
doAssert tableTrie.root.add(Symbol(-1)) == x
doAssert y.length == 1 and tableTrie.nodeCount == 3
doAssert len(tableTrie.root) == 0 and tableTrie.root.len == 0
doAssert len(x) == 1 and y.len == 1

template checkHeap(first, second: untyped) =
    block:
        doAssert cmp(first, second) == -1
        doAssert cmp(second, first) == 1
        doAssert cmp(first, first) == 0
        doAssert (first, 2) < (second, 0)
        doAssert (first, 1) < (first, 2)
        var queue = initHeapQueue[(typeof(first), int)]()
        queue.push((second, 0))
        queue.push((first, 2))
        queue.push((first, 1))
        doAssert queue.pop() == (first, 1)
        doAssert queue.pop() == (first, 2)
        doAssert queue.pop() == (second, 0)
        doAssert queue.len == 0

checkHeap(a, ab)
checkHeap(x, y)

template checkComparisons(ordered: untyped) =
    block:
        let nodes = ordered
        for i in 0..<nodes.len:
            for j in 0..<nodes.len:
                doAssert (nodes[i] < nodes[j]) == (i < j)
                doAssert (nodes[i] <= nodes[j]) == (i <= j)
                doAssert (nodes[i] > nodes[j]) == (i > j)
                doAssert (nodes[i] >= nodes[j]) == (i >= j)
                doAssert (nodes[i] != nodes[j]) == (i != j)
        var shuffled = nodes
        shuffled.reverse()
        shuffled.sort()
        doAssert shuffled == nodes
        var queue = initHeapQueue[typeof(nodes[0])]()
        for node in nodes:
            queue.push(node)
        for node in nodes:
            doAssert queue.pop() == node

checkComparisons(@[arrayTrie.root, a, ab, arrayTrie.root.add('b')])
checkComparisons(@[tableTrie.root, x, y])

template rejectComparisons(first, second: untyped) =
    static:
        doAssert not compiles(first < second)
        doAssert not compiles(first <= second)
        doAssert not compiles(first > second)
        doAssert not compiles(first >= second)

rejectComparisons(a, x)
rejectComparisons(a, initTrieStringArray('a'..'b').root)
rejectComparisons(x, initTrieStringTable(int).root)

proc escapedTable(): TrieStringTableNode[int] =
    let arena = initTrieStringTable(int)
    return arena.root.add(-1).add(2)

proc escapedArray(): TrieStringArrayNode['a'..'z'] =
    let arena = initTrieStringArray('a'..'z')
    return arena.root.add('a').add('b')

let ints = escapedTable()
let chars = escapedArray()
doAssert ints.toSeq() == @[-1, 2]
doAssert len(ints) == 2 and chars.len == 2
doAssert ($chars) == "ab"
doAssert ($arrayTrie.root) == ""
let text = initTrieString().root.add('a').add('b')
doAssert ($text) == "ab" and ($text.prefix(0)) == ""
doAssert ($text.pop()) == "a"
doAssert ints.pop().add(2) == ints
doAssert chars.pop().add('b') == chars

template checkIds(makeRoot: untyped) =
    block:
        let root = makeRoot
        let first = root.add('a')
        let firstId = first.id
        doAssert root.id == 0
        doAssert firstId == 1
        doAssert root.add('a').id == firstId
        doAssert root.add('b').id == 2
        doAssert first.pop().id == 0
        var chain = first
        for i in 0..<1024:
            chain = chain.add('a')
        doAssert first.id == firstId
        doAssert id(first) == firstId
        var bad: typeof(first)
        var caught = false
        try:
            discard bad.id
        except ValueError:
            caught = true
        doAssert caught
        static:
            doAssert not compiles(block:
                var node = first
                node.id = 1)
            doAssert not compiles(typeof(first)(id: 1))

checkIds(initTrieStringArray('a'..'b').root)
checkIds(initTrieStringTable(char).root)
doAssert ints.id == 2 and chars.id == 2

static:
    doAssert not compiles(a.owner)
    doAssert not compiles(arrayTrie.add(0, 'a'))
    doAssert not compiles(arrayTrie.cmp(0, 0))
    doAssert not compiles(a.cmp(x))
    doAssert not compiles(a.cmp(initTrieStringArray('a'..'b').root))
echo "Hello World"
