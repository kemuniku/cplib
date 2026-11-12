# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sequtils, algorithm, strutils
import cplib/str/lcs

proc legacyRestore[T](A,B:openArray[T]):seq[T]=
    if len(A) == 0 or len(B) == 0:
        return newSeq[T](0)
    var DP = newseqwith(len(B)+1,newSeqWith(len(A),0))
    for i in 0..<(len(B)):
        var t = B[i]
        var now = 0
        for j in 0..<(len(A)):
            if A[j] == t:
                var tmp = DP[i][j]
                DP[i+1][j] = now+1
                if tmp > now:
                    now = tmp
            else:
                DP[i+1][j] = DP[i][j]
                if DP[i][j] > now:
                    now = DP[i][j]
    var ans : seq[T]
    var now = DP[^1].maxindex()
    for i in countdown(len(B),1):
        if DP[i-1][now] == DP[i][now]:
            continue
        else:
            for j in countdown(now-1,0):
                if DP[i-1][j] == DP[i][now]-1:
                    now = j
                    break
            ans.add(B[i-1])
    return ans.reversed()

proc oracleLength[T](a, b: openArray[T]): int =
    var dp = newSeqWith(a.len + 1, newSeq[int](b.len + 1))
    for i in 0..<a.len:
        for j in 0..<b.len:
            dp[i+1][j+1] = max(dp[i][j+1], dp[i+1][j])
            if a[i] == b[j]:
                dp[i+1][j+1] = max(dp[i+1][j+1], dp[i][j] + 1)
    return dp[a.len][b.len]

proc isSubsequence[T](part, full: openArray[T]): bool =
    var i = 0
    for value in full:
        if i < part.len and part[i] == value:
            inc i
    return i == part.len

proc check[T](a, b: openArray[T]) =
    let got = restoreLCS(a, b)
    doAssert got.len == oracleLength(a, b)
    doAssert isSubsequence(got, a)
    doAssert isSubsequence(got, b)
    doAssert got == legacyRestore(a, b)

var words = @[""]
for length in 1..5:
    for bits in 0..<(1 shl length):
        var word = newString(length)
        for i in 0..<length:
            word[i] = char(ord('a') + ((bits shr i) and 1))
        words.add(word)
for a in words:
    for b in words:
        check(a, b)
var rng = initRand(20261005)
for trial in 0..<1000:
    var a = newSeq[int](rng.rand(50))
    var b = newSeq[int](rng.rand(50))
    for i in 0..<a.len:
        a[i] = rng.rand(-4..4)
    for i in 0..<b.len:
        b[i] = rng.rand(-4..4)
    check(a, b)
let limits = [low(int), high(int), 0, low(int)]
check(limits, limits)
check(limits.toOpenArray(1, 2), limits.toOpenArray(0, 2))
check([0'u64, high(uint64), 0'u64], [high(uint64), 0'u64])
check(["aaa", "bbb", "ccc"], ["bbb", "ccc"])
check([0.0, NaN, 1.0], [NaN, 0.0, 1.0])
check("\0\xff\0\x80", "\xff\0\x80")
type EqOnly = object
    value: int
proc `==`(a, b: EqOnly): bool = a.value == b.value
check([EqOnly(value: 1), EqOnly(value: 2), EqOnly(value: 1)], [EqOnly(value: 2), EqOnly(value: 1)])
type Modulo = object
    value: int
proc `==`(a, b: Modulo): bool = (a.value mod 2) == (b.value mod 2)
let modA = [Modulo(value: 1), Modulo(value: 2), Modulo(value: 3)]
let modB = [Modulo(value: 5), Modulo(value: 4), Modulo(value: 7)]
check(modA, modB)
doAssert restoreLCS(modA, modB).mapIt(it.value) == legacyRestore(modA, modB).mapIt(it.value)
doAssert restoreLCS(modA, modB).len == 3
type Asymmetric = object
    value: int
proc `==`(a, b: Asymmetric): bool = a.value < b.value
let asymA = [Asymmetric(value: 1), Asymmetric(value: 2)]
let asymB = [Asymmetric(value: 2), Asymmetric(value: 3)]
doAssert restoreLCS(asymA, asymB).mapIt(it.value) == legacyRestore(asymA, asymB).mapIt(it.value)
doAssert restoreLCS(asymB, asymA).mapIt(it.value) == legacyRestore(asymB, asymA).mapIt(it.value)
check(repeat("ab", 5000), "ba")
check("ba", repeat("ab", 5000))
check(repeat("a", 1000), repeat("b", 1000))
doAssert restoreLCS("abcbdab", "bdcaba") == @['b', 'c', 'b', 'a']
echo "Hello World"
