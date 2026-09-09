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

echo "Hello World"
