# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import strutils
import cplib/str/aho_corasick
import cplib/graph/graph

block empty:
    var ac = initAhoCorasick(newSeq[string](), 'a'..'z')
    doAssert ac.nodeCount == 1
    doAssert ac.root == 0 and ac.matchCount(0) == 0
    doAssert ac.next(0, "abc") == 0

block singleEmpty:
    var ac = initAhoCorasick([""], 'a'..'z')
    doAssert ac.nodeCount == 1 and ac.patternNode(0) == 0
    doAssert ac.terminal(0) == 1 and ac.matchCount(0) == 1
    doAssert ac.next(0, "abc#") == 0
    var pointer = ac.initAhoCorasickPointer()
    pointer &= "abc#"
    doAssert pointer.nodeId == 0 and pointer.matchCount == 1
    doAssert ac.toTrieGraph().edge_count == 0
    doAssert ac.toFailureGraph().edge_count == 0

block singleBytes:
    let word = "\0\255\0"
    var ac = initAhoCorasick([word], '\0'..'\255')
    doAssert ac.nodeCount == word.len + 1
    doAssert ac.patternNode(0) == word.len
    doAssert ac.restoreString(ac.patternNode(0)) == word
    doAssert ac.next(0, word) == ac.patternNode(0)
    doAssert ac.matchCount(ac.patternNode(0)) == 1

for length in [1, 7, 8, 63, 64, 65, 4096, 100000]:
    let word = repeat('a', length)
    var ac = initAhoCorasick([word], 'a'..'b')
    doAssert ac.nodeCount == length + 1
    doAssert ac.patternNode(0) == length
    doAssert ac.findNode(word) == length
    doAssert ac.restoreString(length) == word
    doAssert ac.getParent(length) == length - 1
    doAssert ac.failure(length) == length - 1
    var pointer = ac.initAhoCorasickPointer()
    pointer &= word
    doAssert pointer.nodeId == length and pointer.matchCount == 1
    pointer &= 'a'
    doAssert pointer.nodeId == length and pointer.matchCount == 1
    pointer &= 'b'
    doAssert pointer.nodeId == 0 and pointer.matchCount == 0
    doAssert ac.toTrieGraph().edge_count == length
    doAssert ac.toFailureGraph().edge_count == length

block duplicatePrefixes:
    let words = @["aaaa", "aaaa", "aa", "", "aaa", "", "a"]
    var ac = initAhoCorasick(words, 'a'..'b')
    doAssert ac.nodeCount == 5
    for i, word in words:
        doAssert ac.patternNode(i) == word.len
        doAssert ac.restoreString(ac.patternNode(i)) == word
    doAssert ac.terminal(4) == 2
    doAssert ac.terminal(0) == 2
    doAssert ac.matchCount(4) == words.len
    doAssert ac.next(0, "aaaaa") == 4
    doAssert ac.next(4, 'b') == 0

for length in [1, 7, 8, 63, 64, 65, 4096]:
    let longWord = repeat('a', length)
    let words = @[longWord, "", longWord, "b", "ba", "ab"]
    var ac = initAhoCorasick(words, 'a'..'b')
    doAssert ac.nodeCount == length + 4
    for i, word in words:
        doAssert ac.restoreString(ac.patternNode(i)) == word
        doAssert ac.findNode(word) == ac.patternNode(i)
    doAssert ac.patternNode(0) == ac.patternNode(2)
    doAssert ac.terminal(ac.patternNode(0)) == 2
    doAssert ac.matchCount(ac.patternNode(0)) == 3
    var pointer = ac.initAhoCorasickPointer()
    pointer &= longWord
    doAssert pointer.nodeId == ac.patternNode(0)
    doAssert pointer.matchCount == 3
    pointer &= 'b'
    doAssert $pointer == "ab"
    doAssert pointer.matchCount == 3
    doAssert ac.toTrieGraph().edge_count == ac.nodeCount - 1
    doAssert ac.toFailureGraph().edge_count == ac.nodeCount - 1

echo "Hello World"
