# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import random, strutils
import cplib/str/trie
import cplib/graph/graph

const alphabet = 'a'..'c'
var tree = initTrie(@["", "a", "ab", "ab", "ac", "b"], alphabet)
assert tree.len == 6
assert "ab" in tree
assert "abc" notin tree
assert tree.count("ab") == 2
assert tree.count("") == 1
assert tree.countPrefix("a") == 4
assert tree.countPrefix("") == 6
assert tree.lowerBound("ab") == 2
assert tree.upperBound("ab") == 4
assert tree.lowerBound("`") == 1
assert tree.upperBound("d") == 6
assert tree.count("ad") == 0
assert tree.countPrefix("`") == 0
tree.excl("ab")
assert tree.count("ab") == 1
tree.excl("ab", 10)
tree.excl("missing")
assert tree.count("ab") == 0
assert tree.len == 4
tree.incl("ab", 3)
assert tree.count("ab") == 3
tree.excl("", 5)
assert tree.count("") == 0
tree.incl("", 2)
assert tree.lowerBound("") == 0
assert tree.upperBound("") == 2
let before = tree.len
try:
    tree.incl("acd")
    assert false
except AssertionDefect:
    discard
assert tree.len == before
assert tree.countPrefix("ac") == 1

var empty: Trie[alphabet]
assert empty.len == 0
assert empty.count("") == 0
assert empty.countPrefix("") == 0
assert empty.lowerBound("abc") == 0
assert empty.upperBound("") == 0
empty.excl("")
empty.incl("abc")
assert empty.count("abc") == 1
assert initTrie(newSeq[string](), alphabet).len == 0

var single = initTrie('x'..'x')
single.incl("xx", 2)
assert single.countPrefix("x") == 2
assert single.lowerBound("w") == 0
assert single.lowerBound("y") == 2
var bytes = initTrie('\0'..'\255')
bytes.incl("\0")
bytes.incl("\255")
assert bytes.lowerBound("\255") == 1
assert bytes.upperBound("\255") == 2

var rng = initRand(12345)
assert sizeof(TrieNode['a'..'z']) == 120
var navigation = initTrie(alphabet)
assert navigation.getParent(navigation.root) == -1
assert navigation.restoreString(navigation.root) == ""
let a = navigation.getChild(navigation.root, 'a')
let ab = navigation.getChild(a, 'b')
assert navigation.getChild(a, 'b') == ab
assert navigation.nodes.len == 3
assert navigation.nodes[ab].parent == a
assert navigation.getParent(ab) == a
assert navigation.restoreString(ab) == "ab"
assert navigation.findNode("ab") == ab
assert navigation.findNode("ac") == -1
assert navigation.len == 0
assert navigation.countPrefix("a") == 0
assert navigation.upperBound("c") == 0
navigation.incl("ab", 2)
assert navigation.nodes[ab].terminal == 2
assert navigation.nodes[a].subtree == 2
navigation.excl("ab", 2)
assert navigation.restoreString(ab) == "ab"
assert navigation.getChild(a, 'b') == ab
var defaultNavigation: Trie[alphabet]
let first = defaultNavigation.getChild(defaultNavigation.root, 'c')
assert defaultNavigation.restoreString(first) == "c"
assert defaultNavigation.getParent(0) == -1
let longWord = repeat("abc", 10000)
navigation.incl(longWord)
assert navigation.restoreString(navigation.findNode(longWord)) == longWord
assert navigation.restoreString(ab) == "ab"
assert bytes.restoreString(bytes.findNode("\0")) == "\0"
assert bytes.restoreString(bytes.findNode("\255")) == "\255"

var large = initTrie('a'..'z')
large.incl("a", int(high(int32)) - 1)
large.incl("ab")
assert large.len == int(high(int32))
assert large.count("a") == int(high(int32)) - 1
assert large.countPrefix("a") == int(high(int32))
assert large.upperBound("ab") == int(high(int32))
try:
    large.incl("b")
    assert false
except AssertionDefect:
    discard
assert large.len == int(high(int32))
assert large.count("b") == 0
large.excl("a", int(high(int32)))
assert large.len == 1

var actual = initTrie(alphabet)
var expected: seq[string]
proc randomWord(rng: var Rand, low, high: char): string =
    for i in 0..<rng.rand(0..6):
        result.add(char(rng.rand(ord(low)..ord(high))))

for step in 0..<3000:
    let word = rng.randomWord('a', 'c')
    let copies = rng.rand(0..3)
    if rng.rand(0..1) == 0:
        actual.incl(word, copies)
        for i in 0..<copies:
            expected.add(word)
    else:
        actual.excl(word, copies)
        for i in 0..<copies:
            let index = expected.find(word)
            if index >= 0:
                expected.delete(index)
    assert actual.len == expected.len
    for query in [word, rng.randomWord('`', 'd'), ""]:
        var equal, prefix, less, lessEqual: int
        for s in expected:
            equal += int(s == query)
            prefix += int(s.startsWith(query))
            less += int(s < query)
            lessEqual += int(s <= query)
        assert actual.count(query) == equal
        assert actual.contains(query) == (equal > 0)
        assert actual.countPrefix(query) == prefix
        assert actual.lowerBound(query) == less
        assert actual.upperBound(query) == lessEqual
        let node = actual.findNode(query)
        if node >= 0:
            assert actual.restoreString(node) == query
            if query.len > 0:
                assert actual.restoreString(actual.getParent(node)) == query[0..<query.high]

for s in expected:
    actual.excl(s)
assert actual.len == 0
assert actual.countPrefix("") == 0
assert actual.upperBound("d") == 0

var pointerTree = initTrie(alphabet)
var p = pointerTree.initTriePointer()
assert $p == ""
assert p.nodeId == pointerTree.root
p &= 'a'
let q = p & 'b'
assert $p == "a"
assert $q == "ab"
assert q.getParent.nodeId == p.nodeId
assert q.restoreString == "ab"
assert pointerTree.initTriePointer(q.nodeId).restoreString == "ab"
var copied = q
assert copied.pop() == 'b'
assert $copied == "a"
assert $q == "ab"
assert copied.pop() == 'a'
assert $copied == ""
try:
    discard copied.pop()
    assert false
except AssertionDefect:
    discard
try:
    p.add('z')
    assert false
except AssertionDefect:
    discard
assert $p == "a"
assert pointerTree.len == 0
assert q.terminal == 0
assert q.subtree == 0
pointerTree.incl("ab", 2)
assert pointerTree.nodes[q.nodeId].terminal == 2
assert q.terminal == 2
assert p.terminal == 0
assert p.subtree == 2
pointerTree.incl(longWord)
assert $q == "ab"
assert q.terminal == 2
assert q.subtree == 3
assert pointerTree.initTriePointer().subtree == pointerTree.len
pointerTree.excl("ab", 2)
assert $q == "ab"
assert q.terminal == 0
assert q.subtree == 1
var lazyTree: Trie[alphabet]
let lazyPointer = lazyTree.initTriePointer()
assert $(lazyPointer & 'c') == "c"
var bytePointer = bytes.initTriePointer()
bytePointer.add('\0')
bytePointer.add('\255')
assert $bytePointer == "\0\255"
assert bytePointer.pop() == '\255'

var graphTree = initTrie(@["", "ab", "ab", "ac", "b"], alphabet)
graphTree.excl("b")
discard graphTree.getChild(graphTree.root, 'c')
let g = graphTree.toGraph()
assert g.len == graphTree.nodes.len
assert g.edge_count == g.len - 1
var visited = newSeq[bool](g.len)
visited[0] = true
for u in 0..<g.len:
    for (v, c) in g[u]:
        assert not visited[v]
        visited[v] = true
        assert graphTree.getParent(v) == u
        assert graphTree.restoreString(v) == graphTree.restoreString(u) & c
for seen in visited:
    assert seen
assert g.edges[graphTree.findNode("b")].len == 0
let oldLen = g.len
graphTree.incl("aaa")
assert g.len == oldLen
let emptyGraph = initTrie(alphabet).toGraph()
assert emptyGraph.len == 1
assert emptyGraph.edge_count == 0
var defaultGraphTree: Trie[alphabet]
assert defaultGraphTree.toGraph().len == 1
let byteGraph = bytes.toGraph()
for edge in byteGraph.edge_info:
    assert bytes.nodes[edge.dst].character == edge.cost

echo "Hello World"
