# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import random, strutils
import cplib/str/edit_distance

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
    return dp[t.len]

proc check(s, t: string) =
    let distance = naive(s, t)
    for k in 0..max(s.len, t.len) + 1:
        let expected = if distance <= k: distance else: -1
        doAssert editDistance(s, t, k) == expected, $(@[s, t]) & " k=" & $k

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
doAssert editDistance("a", "b", high(int)) == 1

var rng = initRand(20260908)
for trial in 0..<600:
    var s = newString(rng.rand(100))
    var t = newString(rng.rand(100))
    let alphabet = if trial mod 2 == 0: 3 else: 255
    for c in s.mitems:
        c = char(rng.rand(alphabet))
    for c in t.mitems:
        c = char(rng.rand(alphabet))
    let distance = naive(s, t)
    for k in [0, max(0, distance - 1), distance, distance + 1]:
        doAssert editDistance(s, t, k) == (if distance <= k: distance else: -1)

let longString = repeat("ab\0\xff", 25000)
doAssert editDistance(longString, longString, 2) == 0
var changed = longString
changed[50000] = 'c'
changed[99999] = 'd'
doAssert editDistance(longString, changed, 1) == -1
doAssert editDistance(longString, changed, 2) == 2
doAssert editDistance(longString, "z" & longString, 1) == 1
doAssert editDistance("z" & longString, longString, 1) == 1

echo "Hello World"
