# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import random, strutils, algorithm
import cplib/str/lcs as original
import cplib/str/lcs_bitset as packed

proc naive[T](a, b: openArray[T]): int =
    var dp = newSeq[int](b.len + 1)
    for x in a:
        var diagonal = 0
        for j, y in b:
            let old = dp[j + 1]
            dp[j + 1] = if x == y: diagonal + 1 else: max(dp[j], old)
            diagonal = old
    dp[^1]

proc isSubsequence[T](sub, values: openArray[T]): bool =
    var i = 0
    for value in values:
        if i < sub.len and sub[i] == value:
            inc i
    i == sub.len

proc checkRestored[T](a, b: openArray[T], expected: int) =
    let restored = packed.restoreLCS(a, b)
    doAssert restored.len == expected
    doAssert isSubsequence(restored, a)
    doAssert isSubsequence(restored, b)

proc check[T](a, b: openArray[T]) =
    let expected = naive(a, b)
    doAssert packed.LCS(a, b) == expected
    doAssert packed.LCS(b, a) == expected
    checkRestored(a, b, expected)
    checkRestored(b, a, expected)
    if a.len <= 20 and b.len <= 20:
        doAssert original.LCS(a, b) == expected

check(@[1, 3, 4, 1], @[3, 4, 1, 2])
check("abcbdab", "bdcaba")
check("", "")
check("", "abc")
check("\0\xff$\0", "\xff\0$\0")
check([true, false, true], [false, true])
check([low(int), 0, high(int)], [high(int), low(int)])
check([0'u64, high(uint64)], [high(uint64), 0'u64])
check(["hello", "world", "hello"], ["world", "hello"])
check(@[1, 2, 3, 4].toOpenArray(1, 3), [2, 4])
check(newSeq[int](), @[1, 2])

type Color = enum red, green, blue
check([red, green, blue, green], [green, blue])
type EqualOnly = object
    key: int
    ignored: string
proc `==`(a, b: EqualOnly): bool = a.key == b.key
check([EqualOnly(key: 1, ignored: "a"), EqualOnly(key: 2)],
    [EqualOnly(key: 1, ignored: "b")])
check(@[@[1, 2], @[3], @[1, 2]], @[@[3], @[1, 2]])
check([1.5, -0.0, 3.0], [0.0, 3.0])

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

var rng = initRand(20260918)
for n in [1, 2, 63, 64, 65, 127, 128, 129, 255, 256, 257, 511, 512, 513, 1023, 1024, 1025]:
    check(repeat('a', n), repeat('a', n))
    check(repeat('a', n), repeat('b', n))
    check(repeat('a', n), "b" & repeat('a', n))
    check(repeat("ab", n div 2), repeat("ba", n div 2))
    for alphabet in [1, 25, 255]:
        var s = newString(n)
        var t = newString(n + rng.rand(3))
        for c in s.mitems:
            c = char(rng.rand(alphabet))
        for c in t.mitems:
            c = char(rng.rand(alphabet))
        check(s, t)
    let wordCount = (n + 63) div 64
    for count in [wordCount, wordCount + 1]:
        var a = newSeq[int](n)
        for i in 0..<n:
            a[i] = if i < count: -1 else: i
        check(a, a.reversed())

for trial in 0..<300:
    var a = newSeq[int](rng.rand(200))
    var b = newSeq[int](rng.rand(200))
    let alphabet = if trial mod 2 == 0: 3 else: 1000
    for x in a.mitems:
        x = rng.rand(alphabet) - alphabet div 2
    for x in b.mitems:
        x = rng.rand(alphabet) - alphabet div 2
    check(a, b)

var allBytes = newString(256)
for i in 0..<256:
    allBytes[i] = char(i)
check(allBytes, allBytes[1..^1] & "\0")
var uniqueValues = newSeq[int](10000)
for i in 0..<uniqueValues.len:
    uniqueValues[i] = i
doAssert packed.LCS(uniqueValues, uniqueValues) == uniqueValues.len
doAssert packed.LCS(uniqueValues, uniqueValues.reversed()) == 1
doAssert packed.LCS(repeat('a', 10000), repeat('a', 10000)) == 10000
checkRestored(uniqueValues, uniqueValues, uniqueValues.len)
checkRestored(uniqueValues, uniqueValues.reversed(), 1)
checkRestored(repeat('a', 10000), repeat('a', 10000), 10000)
checkRestored("a", repeat('b', 10000), 0)
checkRestored(repeat('b', 10000) & "a", "a", 1)

for n in [65, 513, 2049]:
    for m in [2, 63, 65]:
        var a = newSeq[int](n)
        var b = newSeq[int](m)
        for x in a.mitems:
            x = rng.rand(3)
        for x in b.mitems:
            x = rng.rand(3)
        check(a, b)
        check(repeat('a', m) & repeat('b', n), repeat('a', m))
        check(repeat('b', n) & repeat('a', m), repeat('a', m))

echo "Hello World"
