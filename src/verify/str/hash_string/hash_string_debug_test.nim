# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
{.define: cplibHashStringDebug.}
include cplib/str/hash_string
import random, strutils

proc expected(s: string, limit: int): string =
    result = "\""
    const digits = "0123456789ABCDEF"
    for i in 0..<min(s.len, limit):
        let c = s[i]
        if ord(c) < 32 or ord(c) >= 127:
            result.add("\\x")
            result.add(digits[ord(c) div 16])
            result.add(digits[ord(c) mod 16])
        elif c in {'\\', '\'', '"'}:
            result.add('\\')
            result.add(c)
        else: result.add(c)
    result.add('"')
    if s.len > limit: result.add("...")
    result.add(" (len=" & $s.len & ")")

proc check(h: HashString, s: string) =
    doAssert h.len == s.len
    doAssert h == s.tohash
    for limit in [0, 1, 2, 5, 79, 80, 81, s.len, s.len + 1]:
        doAssert h.debugString(limit) == expected(s, limit)
    doAssert $h == expected(s, 80)

check(get_emptystring_hash(), "")
check(newSeq[char]().tohash, "")
check('a'.tohash, "a")
check("abc".tohash & "def".tohash, "abcdef")
check("abc".tohash * 0, "")
check("abc".tohash * 1, "abc")
check("abc".tohash * 5, "abcabcabcabcabc")
check("abc".tohash.removePrefix(get_emptystring_hash()), "abc")
check(get_emptystring_hash() & "abc".tohash, "abc")
check("abc".tohash & get_emptystring_hash(), "abc")
check(get_emptystring_hash() * int.high, "")
check("abc".tohash.removePrefix("abc".tohash), "")
doAssert 65.tohash.debugString() == "<integers:1> (len=1)"
doAssert [65, 66].tohash.debugString() == "<integers:2> (len=2)"
doAssert newSeq[int]().tohash.debugString() == "<integers:0> (len=0)"
doAssert HashString(hash: 7).debugString() == "<unavailable:0> (len=0)"
doAssert ("x".tohash & 65.tohash).debugString() == "\"x\"<integers:1> (len=2)"
let missing = HashString(hash: 7, bpow: 1, size: 3)
doAssert missing.debugString() == "<unavailable:3> (len=3)"
doAssert missing.debugString(2) == "<unavailable:2>... (len=3)"
doAssert (missing & "abc".tohash).debugString() == "<unavailable:3>\"abc\" (len=6)"
doAssert (missing * 2).debugString() == "<unavailable:3><unavailable:3> (len=6)"
doAssert missing.removePrefix('a'.tohash).debugString() == "<unavailable:2> (len=2)"
try:
    discard "abc".tohash.debugString(-1)
    doAssert false
except ValueError: discard

var allBytes = ""
for value in 0..255: allBytes.add(char(value))
check(allBytes.tohash, allBytes)
check(allBytes.tohash * 3, allBytes & allBytes & allBytes)
for first in 0..<allBytes.len:
    let rolling = initRollingHash(allBytes)
    let last = min(allBytes.high, first + 7)
    check(toHashString(rolling[first..last]), allBytes[first..last])
    check(toHashString(rolling[first..last][0..<0]), "")
var original = "abc"
let saved = original.tohash
let rolling = initRollingHash(original)
original[0] = 'z'
check(saved, "abc")
check(toHashString(rolling), "abc")
var chars = @['a', 'b', 'c']
let savedChars = chars.tohash
chars[0] = 'z'
check(savedChars, "abc")

var rng = initRand(357)
var hashes = @[get_emptystring_hash()]
var strings = @[""]
for iteration in 0..<3000:
    let a = rng.rand(hashes.high)
    let b = rng.rand(hashes.high)
    var h: HashString
    var s: string
    case rng.rand(3)
    of 0:
        s = strings[a] & strings[b]
        if s.len > 1000: continue
        h = hashes[a] & hashes[b]
    of 1:
        let count = rng.rand(5)
        for i in 0..<count: s.add(strings[a])
        if s.len > 1000: continue
        h = hashes[a] * count
    of 2:
        let first = rng.rand(strings[a].len)
        s = strings[a][first..<strings[a].len]
        h = hashes[a].removePrefix(strings[a][0..<first].tohash)
    else:
        for i in 0..<rng.rand(30): s.add(char(rng.rand(255)))
        h = s.tohash
    check(h, s)
    hashes.add(h)
    strings.add(s)

let hugeCount = int.high div 3
let huge = "abc".tohash * hugeCount
for limit in [0, 1, 2, 5, 80, 123]:
    var preview = ""
    for i in 0..<limit: preview.add("abc"[i mod 3])
    let wanted = expected(preview, limit).split(" (len=")[0] & "... (len=" & $(hugeCount * 3) & ")"
    doAssert huge.debugString(limit) == wanted
let tail = huge.removePrefix("abc".tohash * (hugeCount - 1))
check(tail, "abc")
check(huge.removePrefix(("abc".tohash * (hugeCount - 1)) & 'a'.tohash), "bc")
check(huge.removePrefix(("abc".tohash * (hugeCount - 1)) & "ab".tohash), "c")
var trillion = "abc".tohash * int(1000000000000)
trillion = trillion * 1000000
doAssert trillion.debugString(5) == "\"abcab\"... (len=3000000000000000000)"
doAssert huge.removePrefix(get_emptystring_hash()).debugString(5) == huge.debugString(5)

var doubled = "ab".tohash
for i in 0..<40: doubled = doubled & doubled
let endOfDoubled = doubled.removePrefix("ab".tohash * ((1 shl 40) - 1))
check(endOfDoubled, "ab")
var deep = get_emptystring_hash()
var flat = ""
for i in 0..<3000:
    deep = deep & 'a'.tohash
    flat.add('a')
check(deep, flat)
check(deep.removePrefix("a".tohash * 2999), "a")
echo "Hello World"
