# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import random, strutils
import cplib/str/edit_distance_bitset

proc naive(s, t: string): int =
    var dp = newSeq[int](t.len + 1)
    for j in 0..t.len:
        dp[j] = j
    for i in 0..<s.len:
        var diagonal = dp[0]
        dp[0] = i + 1
        for j in 0..<t.len:
            let old = dp[j + 1]
            dp[j + 1] = min(min(dp[j] + 1, old + 1), diagonal + ord(s[i] != t[j]))
            diagonal = old
    dp[t.len]

proc check(s, t: string) =
    let expected = naive(s, t)
    doAssert editDistance_bitset(s, t) == expected
    doAssert editDistance_bitset(t, s) == expected

var words = @[""]
for length in 1..5:
    for bits in 0..<(1 shl length):
        var s = newString(length)
        for i in 0..<length:
            s[i] = char(ord('a') + ((bits shr i) and 1))
        words.add(s)
for s in words:
    for t in words:
        check(s, t)

check("kitten", "sitting")
check("ab", "ba")
check("\0\xff$\0", "\xff\0$\0")

var rng = initRand(20260917)
for n in [1, 2, 63, 64, 65, 127, 128, 129, 255, 256, 257, 511, 512, 513, 1023, 1024, 1025]:
    let repeated = repeat('a', n)
    check(repeated, repeated)
    check(repeated, repeat('b', n))
    check(repeated, "b" & repeated)
    check(repeated, repeated & "b")
    var changed = repeated
    for p in [0, n div 2, n - 1]:
        changed[p] = 'b'
    check(repeated, changed)
    let periodic = repeat("ab", n div 2) & (if n mod 2 == 0: "" else: "a")
    check(periodic, periodic[1..^1] & "b")
    for alphabet in [1, 25, 255]:
        var s = newString(n)
        var t = newString(n + rng.rand(3))
        for c in s.mitems:
            c = char(rng.rand(alphabet))
        for c in t.mitems:
            c = char(rng.rand(alphabet))
        check(s, t)

for trial in 0..<500:
    var s = newString(rng.rand(200))
    var t = newString(rng.rand(200))
    let alphabet = if trial mod 2 == 0: 3 else: 255
    for c in s.mitems:
        c = char(rng.rand(alphabet))
    for c in t.mitems:
        c = char(rng.rand(alphabet))
    check(s, t)

var allBytes = newString(256)
for i in 0..<256:
    allBytes[i] = char(i)
check(allBytes, allBytes[1..^1] & "\0")
check("a", repeat('b', 10000))
doAssert editDistance_bitset(repeat('a', 10000), repeat('a', 10000)) == 0

echo "Hello World"
