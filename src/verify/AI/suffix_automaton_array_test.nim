# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import tables, sets, random
import cplib/str/suffix_automaton_array
import cplib/str/suffix_automaton_table
import cplib/str/suffix_array

var checkedPrefixes = 0
var sawClone = false

proc emptySeq[T](): seq[T] = discard

proc cut[T](s: openArray[T], a, b: int): seq[T] =
    for i in a..b:
        result.add(s[i])

proc appended[T](s: seq[T], c: T): seq[T] =
    for value in s:
        result.add(value)
    result.add(c)

proc encoded[T](word, symbols: seq[T]): seq[int] =
    for value in word:
        var found = false
        for i, symbol in symbols:
            if value == symbol:
                result.add(i)
                found = true
                break
        doAssert found

proc decoded[T](key: seq[int], symbols: seq[T]): seq[T] =
    for index in key:
        result.add(symbols[index])

proc check[T; size](sam: SuffixAutomatonArray[T, size], s: seq[T], symbols: seq[T]) =
    inc checkedPrefixes
    doAssert size == symbols.len
    doAssert sam.root == 0
    doAssert sam.nodes[0].len == 0 and sam.nodes[0].link == -1
    doAssert sam.nodeCount <= max(1, 2 * s.len)
    doAssert sam.nodes[sam.last].len == s.len
    doAssert sam.findNode(s) == sam.last
    doAssert sam.contains(emptySeq[T]())
    var oracle = initTable[seq[int], seq[int]]()
    for l in 0..<s.len:
        for r in l..<s.len:
            oracle.mgetOrPut(encoded(cut(s, l, r), symbols), @[]).add(r)
    doAssert sam.countDistinctSubstrings == int64(oracle.len)
    var endings = newSeq[seq[int]](sam.nodeCount)
    var lengths = newSeq[HashSet[int]](sam.nodeCount)
    for key, positions in oracle:
        let word = decoded(key, symbols)
        let v = sam.findNode(word)
        doAssert v > 0 and v < sam.nodeCount
        doAssert sam.contains(word)
        if endings[v].len == 0:
            endings[v] = positions
        doAssert endings[v] == positions
        lengths[v].incl(word.len)
        let link = sam.nodes[v].link
        let suffixLen = sam.nodes[link].len
        let suffix = if suffixLen == 0: emptySeq[T]() else: cut(word, word.len - suffixLen, word.high)
        doAssert sam.findNode(suffix) == link
    for v in 1..<sam.nodeCount:
        let parent = sam.nodes[v].link
        doAssert parent >= 0 and parent < sam.nodeCount
        doAssert sam.nodes[parent].len < sam.nodes[v].len
        doAssert lengths[v].len == sam.nodes[v].len - sam.nodes[parent].len
        for length in sam.nodes[parent].len + 1..sam.nodes[v].len:
            doAssert length in lengths[v]
    var accepted = initHashSet[seq[int]]()
    proc walk(v: int, word: seq[T]) =
        for c in symbols:
            let dest = sam.nodes[v].next[sam.alphabetIndex(c)]
            if dest == -1:
                continue
            doAssert dest > 0 and dest < sam.nodeCount
            doAssert sam.nodes[dest].len > sam.nodes[v].len
            let nextWord = appended(word, c)
            let key = encoded(nextWord, symbols)
            doAssert oracle.hasKey(key)
            doAssert key notin accepted
            accepted.incl(key)
            walk(dest, nextWord)
    walk(0, emptySeq[T]())
    doAssert accepted.len == oracle.len
    var suffixStates = initHashSet[int]()
    var v = sam.last
    while v != -1:
        suffixStates.incl(v)
        v = sam.nodes[v].link
    for l in 0..s.len:
        let suffix = if l == s.len: emptySeq[T]() else: cut(s, l, s.high)
        doAssert sam.findNode(suffix) in suffixStates
    for key, positions in oracle:
        let word = decoded(key, symbols)
        doAssert (sam.findNode(word) in suffixStates) == (positions[^1] == s.high)

proc check[size](sam: SuffixAutomatonArray[char, size], s: seq[char]) =
    var symbols: seq[char]
    for c in sam.alphabet.a..sam.alphabet.b:
        symbols.add(c)
    check(sam, s, symbols)

proc compare[size](sam: SuffixAutomatonArray[char, size], tableSam: SuffixAutomatonTable[char]) =
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
        check(sam, @(cut(s, 0, i)))
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
var defaultSam: SuffixAutomatonArray[char, 3]
doAssert defaultSam.nodeCount == 0 and defaultSam.findNode("") == -1
doAssert defaultSam.countDistinctSubstrings == 0
var rejected = false
try:
    discard defaultSam.extend('a')
except ValueError:
    rejected = true
doAssert rejected and defaultSam.nodeCount == 0
rejected = false
try:
    discard defaultSam.extend('n')
except ValueError:
    rejected = true
doAssert rejected and defaultSam.nodeCount == 0
defaultSam = initSuffixAutomatonArray('m'..'o')
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
                copy.nodes[clone].next[copy.alphabetIndex('a')] = int32(clone)
                doAssert copy.nodes[q].next == original
                doAssert copy.nodes != clones.nodes
        doAssert found
for c in "cabcbac":
    discard clones.extend(c)
check(clones, @"abcbccabcbac")
proc compareGeneric[T; size](sam: SuffixAutomatonArray[T, size], tableSam: SuffixAutomatonTable[T], queries: seq[T]) =
    doAssert sam.nodeCount == tableSam.nodeCount and sam.last == tableSam.last
    doAssert sam.countDistinctSubstrings == tableSam.countDistinctSubstrings
    for v in 0..<sam.nodeCount:
        doAssert sam.nodes[v].len == tableSam.nodes[v].len
        doAssert sam.nodes[v].link == tableSam.nodes[v].link
        for c in queries:
            doAssert sam.next(v, c) == tableSam.next(v, c)

proc checkGeneric[T: Ordinal](s: seq[T], bounds: static[HSlice[T, T]], symbols, queries: seq[T]) =
    var arraySam = initSuffixAutomatonArray(bounds)
    var tableSam = initSuffixAutomatonTable(T)
    doAssert arraySam.alphabet == bounds
    for i, symbol in symbols:
        doAssert arraySam.alphabetIndex(symbol) == i
    check(arraySam, emptySeq[T](), symbols)
    compareGeneric(arraySam, tableSam, queries)
    for i, c in s:
        let before = arraySam.nodeCount
        doAssert arraySam.extend(c) == before
        discard tableSam.extend(c)
        if arraySam.nodeCount > before + 1:
            sawClone = true
        check(arraySam, cut(s, 0, i), symbols)
        compareGeneric(arraySam, tableSam, queries)
    let built = initSuffixAutomatonArray(s, bounds)
    doAssert arraySam.nodes == built.nodes and arraySam.last == built.last
    let saved = arraySam
    for c in queries:
        if c < bounds.a or c > bounds.b:
            doAssert arraySam.alphabetIndex(c) == -1
            doAssert arraySam.next(arraySam.root, c) == -1
            doAssert arraySam.findNode(@[c]) == -1
            doAssert not arraySam.contains(@[c])
            var rejected = false
            try:
                discard arraySam.extend(c)
            except ValueError:
                rejected = true
            doAssert rejected and arraySam.nodes == saved.nodes and arraySam.last == saved.last
            rejected = false
            try:
                discard initSuffixAutomatonArray(appended(s, c), bounds)
            except ValueError:
                rejected = true
            doAssert rejected
    var copy = arraySam
    discard copy.extend(symbols[0])
    doAssert arraySam.nodes == saved.nodes and arraySam.last == saved.last
    check(copy, appended(s, symbols[0]), symbols)

proc exhaustiveGeneric[T: Ordinal](s: var seq[T], position: int, bounds: static[HSlice[T, T]], symbols, queries: seq[T]) =
    if position == s.len:
        checkGeneric(s, bounds, symbols, queries)
    else:
        for symbol in symbols:
            s[position] = symbol
            exhaustiveGeneric(s, position + 1, bounds, symbols, queries)

for n in 0..7:
    var values = newSeq[int](n)
    exhaustiveGeneric(values, 0, -2.. -1, @[-2, -1], @[int.low, -3, -2, -1, 0, int.high])
for n in 0..5:
    var values = newSeq[int](n)
    exhaustiveGeneric(values, 0, 7..9, @[7, 8, 9], @[int.low, 6, 7, 8, 9, 10, int.high])
for values in [newSeq[int](), @[-7], @[-7, -7, -7, -7], @[-2, 0, -1, -2, 0, 2, -1]]:
    if values.len == 0 or values[0] == -7:
        checkGeneric(values, -7.. -7, @[-7], @[-8, -7, -6])
    else:
        checkGeneric(values, -2..2, @[-2, -1, 0, 1, 2], @[int.low, -3, -2, -1, 0, 1, 2, 3, int.high])

proc checkSigned(T: typedesc[SomeSignedInt]) =
    const a = low(T)
    const b = high(T)
    checkGeneric(@[a, a+1, a, a+2, a+1, a+2], a..T(a+2), @[a, T(a+1), T(a+2)], @[a, T(a+1), T(a+2), T(a+3), b])
    checkGeneric(@[b, b-1, b, b-2, b-1, b-2], T(b-2)..b, @[T(b-2), T(b-1), b], @[a, T(b-3), T(b-2), T(b-1), b])
    checkGeneric(@[a, a, a], a..a, @[a], @[a, T(a+1), b])
    checkGeneric(@[b, b, b], b..b, @[b], @[a, T(b-1), b])
proc checkUnsigned(T: typedesc[SomeUnsignedInt]) =
    const b = high(T)
    checkGeneric(@[b, b-1, b, b-2, b-1, b-2], T(b-2)..b, @[T(b-2), T(b-1), b], @[T(0), T(b-3), T(b-2), T(b-1), b])
    checkGeneric(@[b, b, b], b..b, @[b], @[T(0), T(b-1), b])
checkSigned(int)
checkSigned(int8)
checkSigned(int16)
checkSigned(int32)
checkSigned(int64)
checkUnsigned(uint)
checkUnsigned(uint8)
checkUnsigned(uint16)
checkUnsigned(uint32)
checkUnsigned(uint64)

type
    Color = enum red = 3, green, blue, white
    NegativeEnum = enum leftn = -2, middlen, zeron, rightn
    Small = range[-3..2]
    SmallUnsigned = range[high(uint64)-2..high(uint64)]
    Holey = enum hole0 = 0, hole2 = 2
    DistinctUnsigned = distinct uint64
checkGeneric(@[leftn, zeron, middlen, leftn, rightn], leftn..rightn, @[leftn, middlen, zeron, rightn], @[leftn, middlen, zeron, rightn])
checkGeneric(@[red, green, blue, red, green, white], red..white, @[red, green, blue, white], @[red, green, blue, white])
checkGeneric(@[green, blue, green, blue, blue], green..blue, @[green, blue], @[red, green, blue, white])
checkGeneric(@[blue, blue, blue], blue..blue, @[blue], @[red, green, blue, white])
checkGeneric(@[false, true, false, true, true], false..true, @[false, true], @[false, true])
checkGeneric(@[true, true], true..true, @[true], @[false, true])
checkGeneric(@[Small(-3), Small(-2), Small(-3), Small(-1)], Small(-3)..Small(-1), @[Small(-3), Small(-2), Small(-1)], @[Small(-3), Small(-2), Small(-1), Small(0), Small(2)])
checkGeneric(@[SmallUnsigned(high(uint64)), SmallUnsigned(high(uint64)-1), SmallUnsigned(high(uint64))], low(SmallUnsigned)..high(SmallUnsigned), @[SmallUnsigned(high(uint64)-2), SmallUnsigned(high(uint64)-1), SmallUnsigned(high(uint64))], @[SmallUnsigned(high(uint64)-2), SmallUnsigned(high(uint64)-1), SmallUnsigned(high(uint64))])

var explicit: SuffixAutomatonArray[int, 5] = initSuffixAutomatonArray(@[-3, -1, -3], -3..1)
let distant = initSuffixAutomatonArray(@[7, 9, 7], 7..11)
doAssert explicit.alphabetIndex(-3) == 0 and distant.alphabetIndex(7) == 0
doAssert explicit.alphabetIndex(7) == -1 and distant.alphabetIndex(-3) == -1
explicit = distant
doAssert explicit.alphabet == 7..11 and explicit.contains(@[7, 9, 7])
checkGeneric(@[-1, 0, -1], -1..1, @[-1, 0, 1], @[-2, -1, 0, 1, 2])

for trial in 0..<200:
    var values = newSeq[int](rng.rand(20))
    for c in values.mitems:
        c = rng.rand(4)-2
    checkGeneric(values, -2..2, @[-2, -1, 0, 1, 2], @[-3, -2, -1, 0, 1, 2, 3])

var atLimit = initSuffixAutomatonArray(low(uint16)..high(uint16))
doAssert atLimit.alphabetIndex(low(uint16)) == 0
doAssert atLimit.alphabetIndex(high(uint16)) == 65535
discard atLimit.extend(low(uint16))
discard atLimit.extend(high(uint16))
doAssert atLimit.countDistinctSubstrings == 3
static:
    doAssert not compiles(initSuffixAutomatonArray(3..2))
    doAssert not compiles(initSuffixAutomatonArray(-32768..32768))
    doAssert not compiles(initSuffixAutomatonArray(low(int64)..high(int64)))
    doAssert not compiles(initSuffixAutomatonArray(0'u64..high(uint64)))
    doAssert not compiles(initSuffixAutomatonArray(high(uint64)..0'u64))
    doAssert not compiles(initSuffixAutomatonArray(hole0..hole2))
    doAssert not compiles(initSuffixAutomatonArray(hole0..hole0))
    doAssert not compiles(initSuffixAutomatonArray(DistinctUnsigned(0)..DistinctUnsigned(1)))
    doAssert not compiles(initSuffixAutomatonArray(0.0..1.0))

doAssert sawClone and checkedPrefixes > 10000
echo "Hello World"
