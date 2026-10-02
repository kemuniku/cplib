# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import tables, sets, random, hashes
import cplib/str/suffix_automaton
import cplib/str/suffix_array

var checkedPrefixes = 0
var sawClone = false

proc check[T](sam: SuffixAutomaton[T], s: seq[T]) =
    inc checkedPrefixes
    doAssert sam.root == 0
    doAssert sam.nodes[0].len == 0 and sam.nodes[0].link == -1
    doAssert sam.nodeCount <= max(1, 2 * s.len)
    doAssert sam.nodes[sam.last].len == s.len
    doAssert sam.findNode(s) == sam.last
    doAssert sam.contains(newSeq[T]())
    var oracle = initTable[seq[T], seq[int]]()
    for l in 0..<s.len:
        for r in l..<s.len:
            oracle.mgetOrPut(s[l..r], @[]).add(r)
    doAssert sam.countDistinctSubstrings == int64(oracle.len)
    var endings = newSeq[seq[int]](sam.nodeCount)
    var lengths = newSeq[HashSet[int]](sam.nodeCount)
    for word, positions in oracle:
        let v = sam.findNode(word)
        doAssert v > 0 and v < sam.nodeCount
        doAssert sam.contains(word)
        if endings[v].len == 0:
            endings[v] = positions
        doAssert endings[v] == positions
        lengths[v].incl(word.len)
        let link = sam.nodes[v].link
        let suffixLen = sam.nodes[link].len
        let suffix = if suffixLen == 0: newSeq[T]() else: word[word.len - suffixLen..word.high]
        doAssert sam.findNode(suffix) == link
    for v in 1..<sam.nodeCount:
        let parent = sam.nodes[v].link
        doAssert parent >= 0 and parent < sam.nodeCount
        doAssert sam.nodes[parent].len < sam.nodes[v].len
        doAssert lengths[v].len == sam.nodes[v].len - sam.nodes[parent].len
        for length in sam.nodes[parent].len + 1..sam.nodes[v].len:
            doAssert length in lengths[v]
    var accepted = initHashSet[seq[T]]()
    proc walk(v: int, word: seq[T]) =
        for c, dest in sam.nodes[v].next:
            doAssert dest > 0 and dest < sam.nodeCount
            doAssert sam.nodes[dest].len > sam.nodes[v].len
            let nextWord = word & @[c]
            doAssert oracle.hasKey(nextWord)
            doAssert nextWord notin accepted
            accepted.incl(nextWord)
            walk(dest, nextWord)
    walk(0, @[])
    doAssert accepted.len == oracle.len
    var suffixStates = initHashSet[int]()
    var v = sam.last
    while v != -1:
        suffixStates.incl(v)
        v = sam.nodes[v].link
    for l in 0..s.len:
        let suffix = if l == s.len: newSeq[T]() else: s[l..s.high]
        doAssert sam.findNode(suffix) in suffixStates
    for word, positions in oracle:
        doAssert (sam.findNode(word) in suffixStates) == (positions[^1] == s.high)

proc checkPrefixes[T](s: seq[T]) =
    var sam = initSuffixAutomaton(T)
    check(sam, newSeq[T]())
    for i, c in s:
        let before = sam.nodeCount
        let last = sam.extend(c)
        doAssert last == sam.last and last == before
        if sam.nodeCount > before + 1:
            sawClone = true
        check(sam, s[0..i])
    let built = initSuffixAutomaton(s)
    doAssert sam.nodes == built.nodes and sam.last == built.last

proc exhaustive(s: var seq[int], i, alphabet: int) =
    if i == s.len:
        checkPrefixes(s)
    else:
        for c in 0..<alphabet:
            s[i] = c
            exhaustive(s, i + 1, alphabet)

for n in 0..8:
    var s = newSeq[int](n)
    exhaustive(s, 0, 2)
for n in 0..6:
    var s = newSeq[int](n)
    exhaustive(s, 0, 3)

for text in ["", "a", "aaaaaaaaaaaa", "abababababab", "banana", "mississippi", "abcbc", "abbbab"]:
    checkPrefixes(@text)
for values in [@[0, 255, 128, 0, 127, 255], @[int.low, int.high, 0, int.low, -1]]:
    checkPrefixes(values)
checkPrefixes(@["red", "blue", "red", "blue", "green"])

type Colliding = object
    value: int
proc hash(x: Colliding): Hash = 0
checkPrefixes(@[Colliding(value: 1), Colliding(value: 2), Colliding(value: 1), Colliding(value: 3)])

var rng = initRand(20261002)
for trial in 0..<300:
    var text = newString(rng.rand(20))
    for c in text.mitems:
        c = char(rng.rand([1, 2, 25, 255][trial mod 4]))
    checkPrefixes(@text)

var allBytes = newString(256)
for i in 0..255:
    allBytes[i] = char(i)
let bytesSam = initSuffixAutomaton(allBytes & allBytes)
for i in 0..255:
    doAssert bytesSam.contains($char(i))
    doAssert bytesSam.contains($char(i) & $char((i + 1) mod 256))

for n in [1, 2, 31, 32, 33, 255, 256, 257, 4096, 10000]:
    for alphabet in [1, 2, 26, 256]:
        var text = newString(n)
        for c in text.mitems:
            c = char(rng.rand(alphabet - 1))
        let sam = initSuffixAutomaton(text)
        var expected = int64(n) * int64(n + 1) div 2
        for lcp in lcp_array(text, suffix_array(text)):
            expected -= int64(lcp)
        doAssert sam.countDistinctSubstrings == expected

var sam = initSuffixAutomaton("banana")
let saved = sam
let savedNodeCount = sam.nodeCount
for trial in 0..<100:
    doAssert sam.next(sam.root, '\0') == -1
    doAssert sam.findNode("bananaz") == -1
    doAssert not sam.contains("zzz")
doAssert sam.nodeCount == savedNodeCount and sam.nodes == saved.nodes
var other = sam
discard other.extend('z')
doAssert not sam.contains("z") and sam.nodes == saved.nodes
check(other, @"bananaz")
sam = initSuffixAutomaton(char)
discard sam.extend('x')
check(sam, @"x")
var defaultSam: SuffixAutomaton[int]
discard defaultSam.extend(5)
check(defaultSam, @[5])
doAssert sawClone and checkedPrefixes > 10000
echo "Hello World"
