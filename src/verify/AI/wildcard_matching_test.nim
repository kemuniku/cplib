# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, strutils
import cplib/str/wildcard_matching

proc naive(s, t: string, wild: char): seq[bool] =
    if t.len > s.len:
        return @[]
    for i in 0..s.len - t.len:
        var matches = true
        for j in 0..<t.len:
            if s[i + j] != wild and t[j] != wild and s[i + j] != t[j]:
                matches = false
                break
        result.add(matches)

proc check(s, t: string, wild: char = '?') =
    doAssert wildcard_match(s, t, wild) == naive(s, t, wild)

doAssert wildcard_match("ab?abc", "a?c") == @[true, false, false, true]
doAssert wildcard_match("", "") == @[true]
doAssert wildcard_match("abc", "") == @[true, true, true, true]
doAssert wildcard_match("", "a") == @[]
check("ab", "abc")
check("????", "??")
check("abcd", "??")
check("****", "ab", '*')
check("a b\0\255", " b\0")
check("?a*b?", "?*", '*')

var bytes = ""
for i in 0..255:
    bytes.add(char(i))
check(bytes, bytes)
check(bytes & bytes, bytes, '\0')
check(bytes & bytes, bytes, '\255')
check(repeat("\255", 300), repeat("a", 150), '\255')
check(repeat("~", 300), repeat("~", 150))
check(repeat("\255", 300), repeat("\254", 150))

var rng = initRand(20260910)
for trial in 0..<300:
    let n = rng.rand(0..220)
    let m = rng.rand(0..240)
    let wild = if trial mod 2 == 0: '?' else: '\0'
    var s = newString(n)
    var t = newString(m)
    for c in s.mitems:
        c = if rng.rand(0..3) == 0: wild else: char(rng.rand(0..255))
    for c in t.mitems:
        c = if rng.rand(0..3) == 0: wild else: char(rng.rand(0..255))
    check(s, t, wild)
    if m <= n:
        let offset = rng.rand(0..n - m)
        for j in 0..<m:
            if t[j] != wild and s[offset + j] != wild:
                t[j] = s[offset + j]
        check(s, t, wild)

for n in [60, 61, 63, 64, 65, 127, 128, 129, 255, 256, 257, 511, 512, 513, 1023, 1024, 1025]:
    for m in [1, 59, 60, 61, n div 2, n - 1, n, n + 1]:
        check(repeat("a", n), repeat("b", m))
        check(repeat("a", n), repeat("a", m))
        check(repeat("?", n), repeat("\255", m))
        check(repeat("\0", n), repeat("?", m))
        var s = newString(n)
        var t = newString(m)
        for i in 0..<n: s[i] = char((i * 73) mod 256)
        for i in 0..<m: t[i] = char((i * 73 + 19) mod 256)
        check(s, t)
        if m <= n:
            for i in 0..<m: t[i] = s[n - m + i]
            check(s, t)

for trial in 0..<80:
    let n = rng.rand(7300..16000)
    let m = rng.rand(7230..n)
    var s = newString(n)
    var t = newString(m)
    for c in s.mitems: c = char(rng.rand(0..255))
    for c in t.mitems: c = char(rng.rand(0..255))
    check(s, t)
    let offset = rng.rand(0..n - m)
    for i in 0..<m: t[i] = s[offset + i]
    for i in countup(0, m - 1, 7): t[i] = '?'
    check(s, t)

# 469762049 = 7224*255^2 + 146^2 + 9^2 + 6^2 + 4^2。
var collisionS = repeat("\0", 7228)
var collisionT = repeat("\255", 7224)
for x in [146, 9, 6, 4]: collisionT.add(char(x))
check(collisionS, collisionT)

# 単一素数のweightedスコアで2*998244353となる586文字の反例。
check(repeat("a", 138) & repeat("a", 273) & repeat("k", 5) & repeat("a", 170),
    repeat("k", 138) & repeat("y", 273) & repeat("v", 5) & repeat("a", 170))
check(repeat("a", 81) & repeat("a", 413) & repeat("u", 3) & repeat("a", 89),
    repeat("k", 81) & repeat("u", 413) & repeat("x", 3) & repeat("a", 89))

var words = @[""]
for length in 1..6:
    let start = words.len
    for wi in 0..<start:
        let w = words[wi]
        if w.len == length - 1:
            for c in ['\0', '?', '\255']: words.add(w & c)
    doAssert words.len > start
for s in words:
    for t in words:
        if t.len <= 4: check(s, t)

var rejected = false
try:
    discard wildcard_match(repeat("a", 1 shl 24), "aa")
except AssertionDefect:
    rejected = true
doAssert rejected

echo "Hello World"
