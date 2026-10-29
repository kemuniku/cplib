# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/str/hamming_distance

proc naive(s, t: openArray[char]): int =
    for i in 0..<s.len:
        result += int(s[i] != t[i])

doAssert hammingDistance("", "") == 0
doAssert hammingDistance("kitten", "sitten") == 1
doAssert hammingDistance("\x00\xff", "\xff\x00") == 2
doAssert hammingDistance(@['a', 'b'], @['a', 'c']) == 1
for pair in [("", "a"), ("abc", "ab"), (newString(64), newString(65))]:
    var raised = false
    try:
        discard hammingDistance(pair[0], pair[1])
    except ValueError:
        raised = true
    doAssert raised

randomize(9127)
for n in 0..260:
    var s = newString(n)
    var t = newString(n)
    doAssert hammingDistance(s, t) == 0
    for i in 0..<n: t[i] = '\xff'
    doAssert hammingDistance(s, t) == n
    t = newString(n)
    for i in 0..<n:
        t[i] = '\x01'
        doAssert hammingDistance(s, t) == 1
        t[i] = '\x00'
    for trial in 0..<8:
        for i in 0..<n:
            s[i] = char(rand(255))
            t[i] = if rand(1) == 0: s[i] else: char(rand(255))
        doAssert hammingDistance(s, t) == naive(s, t)
        doAssert hammingDistance(t, s) == naive(s, t)

for n in [31, 32, 33, 63, 64, 65, 127, 128, 129, 1023, 1024, 1025, 65537]:
    var s = newString(n + 64)
    var t = newString(n + 64)
    for i in 0..<s.len:
        s[i] = char(rand(255))
        t[i] = if rand(3) == 0: char(rand(255)) else: s[i]
    for a in 0..<32:
        for b in 0..<32:
            doAssert hammingDistance(s.toOpenArray(a, a + n - 1), t.toOpenArray(b, b + n - 1)) ==
                naive(s.toOpenArray(a, a + n - 1), t.toOpenArray(b, b + n - 1))
echo "Hello World"
