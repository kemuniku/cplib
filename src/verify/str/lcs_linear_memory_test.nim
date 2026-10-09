# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sequtils, strutils
import cplib/str/lcs

proc oracle[T](a, b: openArray[T]): int =
    var dp = newSeqWith(a.len + 1, newSeq[int](b.len + 1))
    for i in 0..<a.len:
        for j in 0..<b.len:
            dp[i+1][j+1] = max(dp[i][j+1], dp[i+1][j])
            if a[i] == b[j]:
                dp[i+1][j+1] = max(dp[i+1][j+1], dp[i][j] + 1)
    return dp[a.len][b.len]

var words = @[""]
for length in 1..6:
    for bits in 0..<(1 shl length):
        var word = newString(length)
        for i in 0..<length:
            word[i] = char(ord('a') + ((bits shr i) and 1))
        words.add(word)
for a in words:
    for b in words:
        doAssert LCS(a, b) == oracle(a, b)
var rng = initRand(20261005)
for trial in 0..<1000:
    var a = newSeq[int](rng.rand(50))
    var b = newSeq[int](rng.rand(50))
    for i in 0..<a.len:
        a[i] = rng.rand(-4..4)
    for i in 0..<b.len:
        b[i] = rng.rand(-4..4)
    doAssert LCS(a, b) == oracle(a, b)
let limits = [low(int), high(int), 0, low(int)]
doAssert LCS(limits, limits) == 4
doAssert LCS(limits.toOpenArray(1, 2), limits.toOpenArray(0, 2)) == 2
doAssert LCS([0'u64, high(uint64), 0'u64], [high(uint64), 0'u64]) == 2
doAssert LCS(["aaa", "bbb", "ccc"], ["bbb", "ccc"]) == 2
doAssert LCS([0.0, NaN, 1.0], [NaN, 0.0, 1.0]) == 2
let bytes = "\0\xff\0\x80"
doAssert LCS(bytes, bytes) == bytes.len
doAssert LCS("", bytes) == 0
doAssert LCS(bytes, "") == 0

type EqOnly = object
    value: int
proc `==`(a, b: EqOnly): bool = a.value == b.value
let eqA = [EqOnly(value: 1), EqOnly(value: 2), EqOnly(value: 1)]
let eqB = [EqOnly(value: 2), EqOnly(value: 1)]
doAssert LCS(eqA, eqB) == 2

type Asymmetric = object
    value: int
proc `==`(a, b: Asymmetric): bool = a.value < b.value
let asymA = [Asymmetric(value: 1), Asymmetric(value: 2)]
let asymB = [Asymmetric(value: 2), Asymmetric(value: 3)]
doAssert LCS(asymA, asymB) == oracle(asymA, asymB)
doAssert LCS(asymB, asymA) == oracle(asymB, asymA)
doAssert LCS(repeat("ab", 5000), "ba") == 2
doAssert LCS("ba", repeat("ab", 5000)) == 2
doAssert LCS(repeat("a", 1000), repeat("b", 1000)) == 0
echo "Hello World"
