# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import sequtils
include cplib/str/lcs
proc oracle(a, b: string): int =
    var dp = newSeqWith(a.len + 1, newSeq[int](b.len + 1))
    for i in 0..<a.len:
        for j in 0..<b.len:
            dp[i+1][j+1] = max(dp[i][j+1], dp[i+1][j])
            if a[i] == b[j]:
                dp[i+1][j+1] = max(dp[i+1][j+1], dp[i][j] + 1)
    return dp[a.len][b.len]
proc isSubsequence(part: seq[char], full: string): bool =
    var i = 0
    for value in full:
        if i < part.len and part[i] == value:
            inc i
    return i == part.len
var words = @[""]
for length in 1..5:
    for bits in 0..<(1 shl length):
        var word = newString(length)
        for i in 0..<length:
            word[i] = char(ord('a') + ((bits shr i) and 1))
        words.add(word)
for a in words:
    for b in words:
        let native = restoreLCSImpl[char, int](a, b)
        let compact = restoreLCSImpl[char, int32](a, b)
        doAssert native == compact
        doAssert native.len == oracle(a, b)
        doAssert isSubsequence(native, a)
        doAssert isSubsequence(native, b)
echo "Hello World"
