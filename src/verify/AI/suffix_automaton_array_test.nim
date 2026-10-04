# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import tables, sets, random
import cplib/str/suffix_automaton_array
import cplib/str/suffix_automaton_table
import cplib/str/suffix_array

var checkedPrefixes = 0
var sawClone = false

proc check[chars](sam: SuffixAutomatonArray[chars], s: seq[char]) =
    inc checkedPrefixes
    doAssert sam.root == 0
    doAssert sam.nodes[0].len == 0 and sam.nodes[0].link == -1
    doAssert sam.nodeCount <= max(1, 2 * s.len)
    doAssert sam.nodes[sam.last].len == s.len
    doAssert sam.findNode(s) == sam.last
    doAssert sam.contains(newSeq[char]())
    var oracle = initTable[seq[char], seq[int]]()
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
        let suffix = if suffixLen == 0: newSeq[char]() else: word[word.len - suffixLen..word.high]
        doAssert sam.findNode(suffix) == link
    for v in 1..<sam.nodeCount:
        let parent = sam.nodes[v].link
        doAssert parent >= 0 and parent < sam.nodeCount
        doAssert sam.nodes[parent].len < sam.nodes[v].len
        doAssert lengths[v].len == sam.nodes[v].len - sam.nodes[parent].len
        for length in sam.nodes[parent].len + 1..sam.nodes[v].len:
            doAssert length in lengths[v]
    var accepted = initHashSet[seq[char]]()
    proc walk(v: int, word: seq[char]) =
        for c in chars.a..chars.b:
            let dest = sam.nodes[v].next[c]
            if dest == -1:
                continue
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
        let suffix = if l == s.len: newSeq[char]() else: s[l..s.high]
        doAssert sam.findNode(suffix) in suffixStates
    for word, positions in oracle:
        doAssert (sam.findNode(word) in suffixStates) == (positions[^1] == s.high)

proc compare[chars](sam: SuffixAutomatonArray[chars], tableSam: SuffixAutomatonTable[char]) =
    doAssert sam.nodeCount == tableSam.nodeCount and sam.last == tableSam.last
    for v in 0..<sam.nodeCount:
        doAssert sam.nodes[v].len == tableSam.nodes[v].len
        doAssert sam.nodes[v].link == tableSam.nodes[v].link
        for i in 0..255:
            let c = char(i)
            doAssert sam.next(v, c) == tableSam.next(v, c)

proc checkPrefixes(s: string, chars: static[HSlice[char, char]]) =
    var sam = initSuffixAutomatonArray(chars)
    var tableSam = initSuffixAutomatonTable(char)
    check(sam, @[])
    compare(sam, tableSam)
    for i, c in s:
        let before = sam.nodeCount
        doAssert sam.extend(c) == before
        discard tableSam.extend(c)
        if sam.nodeCount > before + 1:
            sawClone = true
        check(sam, @(s[0..i]))
        compare(sam, tableSam)
    let built = initSuffixAutomatonArray(s, chars)
    let builtChars = initSuffixAutomatonArray(@s, chars)
    doAssert sam.nodes == built.nodes and sam.last == built.last
    doAssert sam.nodes == builtChars.nodes and sam.last == builtChars.last

proc exhaustive(s: var string, i: int, chars: static[HSlice[char, char]]) =
    if i == s.len:
        checkPrefixes(s, chars)
    else:
        for c in chars.a..chars.b:
            s[i] = c
            exhaustive(s, i + 1, chars)

for n in 0..8:
    var s = newString(n)
    exhaustive(s, 0, 'x'..'y')
for n in 0..6:
    var s = newString(n)
    exhaustive(s, 0, '3'..'5')
for text in ["", "a", "aaaaaaaaaaaa", "abababababab", "banana", "mississippi", "abcbc", "abbbab"]:
    checkPrefixes(text, 'a'..'z')
checkPrefixes("000000000000", '0'..'0')
checkPrefixes("", '0'..'0')
checkPrefixes("XYZXXYZZYX", 'X'..'Z')
checkPrefixes("\x80\xff\x80\x81\xff", '\x80'..'\xff')
checkPrefixes("\0\xff\x80\0\x7f\xff", '\0'..'\xff')

var rng = initRand(20261004)
for trial in 0..<300:
    var text = newString(rng.rand(20))
    for c in text.mitems:
        c = char(rng.rand([1, 2, 25, 255][trial mod 4]))
    checkPrefixes(text, '\0'..'\xff')

var allBytes = newString(256)
for i in 0..255:
    allBytes[i] = char(i)
let bytesSam = initSuffixAutomatonArray(allBytes & allBytes, '\0'..'\xff')
compare(bytesSam, initSuffixAutomatonTable(allBytes & allBytes))
for i in 0..255:
    doAssert bytesSam.contains($char(i))
    doAssert bytesSam.contains($char(i) & $char((i + 1) mod 256))

proc checkLarge(text: string, chars: static[HSlice[char, char]]) =
    let sam = initSuffixAutomatonArray(text, chars)
    let tableSam = initSuffixAutomatonTable(text)
    compare(sam, tableSam)
    var expected = int64(text.len) * int64(text.len + 1) div 2
    for lcp in lcp_array(text, suffix_array(text)):
        expected -= int64(lcp)
    doAssert sam.countDistinctSubstrings == expected

for n in [1, 2, 31, 32, 33, 255, 256, 257, 4096, 10000]:
    for alphabet in [1, 2, 26, 256]:
        var text = newString(n)
        for c in text.mitems:
            c = char(rng.rand(alphabet - 1))
        checkLarge(text, '\0'..'\xff')
for kind in 0..2:
    var text = newString(10000)
    for i in 0..<text.len:
        text[i] = (if kind == 0: 'a' else: char(ord('a') + i mod 2))
    if kind == 2:
        text[0] = 'a'
        for i in 1..<text.len:
            text[i] = 'b'
    checkLarge(text, 'a'..'b')

var sam = initSuffixAutomatonArray("banana", 'a'..'z')
let saved = sam
for trial in 0..<100:
    doAssert sam.next(sam.root, '\0') == -1
    doAssert sam.findNode("bananaz") == -1
    doAssert not sam.contains("zzz")
    doAssert not sam.contains("banana{")
doAssert sam.nodes == saved.nodes and sam.last == saved.last
for c in ['`', '{', '\0', '\xff']:
    var rejected = false
    try:
        discard sam.extend(c)
    except ValueError:
        rejected = true
    doAssert rejected
    doAssert sam.nodes == saved.nodes and sam.last == saved.last
    rejected = false
    try:
        discard initSuffixAutomatonArray("banana" & c, 'a'..'z')
    except ValueError:
        rejected = true
    doAssert rejected

var other = sam
discard other.extend('z')
doAssert not sam.contains("z") and sam.nodes == saved.nodes
check(other, @"bananaz")
sam = initSuffixAutomatonArray('a'..'z')
discard sam.extend('x')
check(sam, @"x")
var defaultSam: SuffixAutomatonArray['m'..'o']
doAssert defaultSam.nodeCount == 0 and defaultSam.findNode("") == -1
doAssert defaultSam.countDistinctSubstrings == 0
var rejected = false
try:
    discard defaultSam.extend('a')
except ValueError:
    rejected = true
doAssert rejected and defaultSam.nodeCount == 0
discard defaultSam.extend('n')
check(defaultSam, @"n")

# qとcloneが同じ配列値を持つ瞬間から、双方への後続更新を検査する。
var clones = initSuffixAutomatonArray('a'..'c')
for c in "abcbc":
    let before = clones.nodeCount
    discard clones.extend(c)
    if clones.nodeCount == before + 2:
        let clone = before + 1
        var found = false
        for q in 1..<before:
            if clones.nodes[q].link == clone and clones.nodes[q].next == clones.nodes[clone].next:
                found = true
                var copy = clones
                let original = copy.nodes[q].next
                copy.nodes[clone].next['a'] = int32(clone)
                doAssert copy.nodes[q].next == original
                doAssert copy.nodes != clones.nodes
        doAssert found
for c in "cabcbac":
    discard clones.extend(c)
check(clones, @"abcbccabcbac")
doAssert sawClone and checkedPrefixes > 10000
echo "Hello World"
