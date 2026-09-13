# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import random, strutils, algorithm
import cplib/str/aho_corasick

let orderedWords = @["bc", "b", "abc", "aa", "", "abc"]
let ordered = initAhoCorasick(orderedWords, 'a'..'c')
let expectedNodes = @["", "b", "bc", "a", "ab", "abc", "aa"]
assert ordered.nodeCount == expectedNodes.len
for id, word in expectedNodes:
    assert ordered.restoreString(id) == word
    assert ordered.findNode(word) == id
assert ordered.findNode("ac") == -1
assert ordered.findNode("aabc") == -1
assert ordered.findNode("c") == -1
assert ordered.findNode("#abc") == -1
for i, word in orderedWords:
    assert ordered.patternNode(i) == expectedNodes.find(word)
assert ordered.failure(ordered.patternNode(2)) == ordered.patternNode(0)
assert ordered.getParent(ordered.root) == -1

var ac = initAhoCorasick(@["he", "she", "hers", "his", "he", ""], 'a'..'z')
var p = ac.initAhoCorasickPointer()
assert p.nodeId == ac.root
assert p.matchCount == 1
p.add("ush")
assert $p == "sh"
assert p.terminal == 0
let q = p & 'e'
assert $p == "sh"
assert $q == "she"
assert ac.findNode("she") == q.nodeId
assert ac.findNode("sh") == p.nodeId
assert ac.findNode("ushe") == -1
assert ac.findNode("shers") == -1
assert ac.initAhoCorasickPointer(ac.findNode("she")).nodeId == q.nodeId
assert $q.getParent == "sh"
assert q.getParent.nodeId == p.nodeId
assert $q == "she"
assert q.matchCount == 4
var found: seq[string]
for node in q.matches:
    found.add(ac.restoreString(node))
assert found == @["she", "he", ""]
p &= "ers"
assert $p == "hers"
assert p.matchCount == 2
p &= '#'
assert $p == ""
assert ac.patternNode(0) == ac.patternNode(4)
assert ac.terminal(ac.patternNode(0)) == 2
assert ac.restoreString(ac.failure(ac.patternNode(1))) == "he"
assert ac.failure(ac.root) == ac.root
assert $q.failure == "he"
assert q.failure.nodeId == ac.patternNode(0)
assert q.failure.matchCount == 3
assert $q == "she"
var failurePointer = q
failurePointer = failurePointer.failure
assert $failurePointer == "he"
assert $(failurePointer & "rs") == "hers"
failurePointer = failurePointer.failure
assert failurePointer.nodeId == ac.root
assert failurePointer.failure.nodeId == ac.root
assert $(ac.initAhoCorasickPointer(ac.patternNode(1)) & "rs") == "hers"
assert ac.next(ac.root, "ushers") == ac.patternNode(2)
var parentPointer = q
parentPointer = parentPointer.getParent
assert $parentPointer == "sh"
parentPointer = parentPointer.getParent
assert $parentPointer == "s"
parentPointer = parentPointer.getParent
assert parentPointer.nodeId == ac.root
try:
    discard parentPointer.getParent
    assert false
except AssertionDefect:
    discard

var empty = initAhoCorasick(newSeq[string](), 'a'..'z')
assert empty.nodeCount == 1
assert empty.findNode("") == empty.root
assert empty.findNode("a") == -1
var uninitialized: AhoCorasick['a'..'z']
assert uninitialized.findNode("") == -1
var ep = empty.initAhoCorasickPointer()
ep.add("anything#")
assert ep.nodeId == 0
assert ep.matchCount == 0
for node in ep.matches:
    assert false
var blanks = initAhoCorasick(@["", ""], 'x'..'x')
assert blanks.matchCount(blanks.root) == 2
assert blanks.next(0, "xxx!") == 0
var bytes = initAhoCorasick(@["\0\255", "\255", "\0"], '\0'..'\255')
var bp = bytes.initAhoCorasickPointer()
assert bytes.findNode("\0\255") == bytes.patternNode(0)
assert bytes.findNode("\255\255") == -1
bp &= "\0\255"
assert $bp == "\0\255"
assert bp.matchCount == 2
bp.add('\255')
assert $bp == "\255"
assert bp.matchCount == 1

var rng = initRand(981723)
for trial in 0..<300:
    var words: seq[string]
    for i in 0..<rng.rand(0..25):
        var word = ""
        for j in 0..<rng.rand(0..8):
            word.add(char(ord('a') + rng.rand(0..2)))
        words.add(word)
    var automaton = initAhoCorasick(words, 'a'..'c')
    var prefixes = @[""]
    for word in words:
        for length in 1..word.len:
            let prefix = word[0..<length]
            if prefix notin prefixes:
                prefixes.add(prefix)
    assert automaton.nodeCount == prefixes.len
    for id, prefix in prefixes:
        assert automaton.restoreString(id) == prefix
        assert automaton.findNode(prefix) == id
        for c in 'a'..'d':
            let query = prefix & c
            assert automaton.findNode(query) == prefixes.find(query)
    var pointer = automaton.initAhoCorasickPointer()
    for i, word in words:
        assert automaton.restoreString(automaton.patternNode(i)) == word
    for node in 0..<automaton.nodeCount:
        let s = automaton.restoreString(node)
        if node != automaton.root:
            let parent = automaton.getParent(node)
            assert parent < node
            assert automaton.restoreString(parent) == s[0..<s.high]
            assert automaton.initAhoCorasickPointer(node).getParent.nodeId == parent
        var expectedFailure = ""
        for other in 0..<automaton.nodeCount:
            let suffix = automaton.restoreString(other)
            if suffix.len < s.len and s.endsWith(suffix) and suffix.len > expectedFailure.len:
                expectedFailure = suffix
        assert automaton.restoreString(automaton.failure(node)) == expectedFailure
        let nodePointer = automaton.initAhoCorasickPointer(node)
        assert nodePointer.failure.nodeId == automaton.failure(node)
        assert $nodePointer.failure == expectedFailure
    var text = ""
    for step in 0..<70:
        var longest = ""
        for word in words:
            for length in 0..word.len:
                let prefix = word[0..<length]
                if text.endsWith(prefix) and prefix.len > longest.len:
                    longest = prefix
        assert $pointer == longest
        var expectedCount, terminalCount: int
        var expectedMatches: seq[string]
        for word in words:
            if text.endsWith(word):
                inc expectedCount
                if word notin expectedMatches:
                    expectedMatches.add(word)
            if word == longest:
                inc terminalCount
        assert pointer.matchCount == expectedCount
        assert pointer.terminal == terminalCount
        var actualMatches: seq[string]
        var previousLength = high(int)
        for node in pointer.matches:
            let word = automaton.restoreString(node)
            assert word.len < previousLength
            previousLength = word.len
            actualMatches.add(word)
        actualMatches.sort()
        expectedMatches.sort()
        assert actualMatches == expectedMatches
        var chunk = ""
        for j in 0..<rng.rand(0..5):
            chunk.add(char(ord('a') + rng.rand(0..3)))
        let saved = pointer
        pointer.add(chunk)
        assert $saved == longest
        assert (saved & chunk).nodeId == pointer.nodeId
        var byChar = saved
        for c in chunk:
            byChar &= c
        assert byChar.nodeId == pointer.nodeId
        text.add(chunk)

let longWord = repeat("a", 100000)
var longAc = initAhoCorasick(@[longWord, "a"], 'a'..'a')
var lp = longAc.initAhoCorasickPointer()
lp.add(longWord)
assert lp.matchCount == 2
lp.add('a')
assert lp.nodeId == longAc.patternNode(0)
assert lp.restoreString == longWord

echo "Hello World"
