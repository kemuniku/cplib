# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import strutils
import cplib/str/aho_corasick
import cplib/graph/graph

block empty:
    var ac = initAhoCorasick(newSeq[string](), 'a'..'z')
    doAssert ac.nodeCount == 1
    doAssert ac.root == 0 and ac.matchCount(0) == 0
    doAssert ac.next(0, "abc") == 0

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
