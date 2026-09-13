# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import random, strutils
import cplib/str/trie

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

for s in expected:
    actual.excl(s)
assert actual.len == 0
assert actual.countPrefix("") == 0
assert actual.upperBound("d") == 0

echo "Hello World"
