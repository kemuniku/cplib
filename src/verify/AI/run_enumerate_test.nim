# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import algorithm, random, sequtils, strutils
import cplib/str/run_enumerate

proc brute[T](s: openArray[T]): seq[(int, int, int)] =
    for l in 0..<s.len:
        for r in l + 2..s.len:
            var period = 1
            while period <= (r - l) div 2:
                var valid = true
                for i in l + period..<r:
                    if s[i] != s[i - period]:
                        valid = false
                        break
                if valid:
                    if (l == 0 or s[l - 1] != s[l + period - 1]) and
                            (r == s.len or s[r] != s[r - period]):
                        result.add((period, l, r))
                    break
                inc period
    result.sort()

proc check(s: string) =
    let expected = brute(s.toSeq)
    let actual = run_enumerate(s)
    assert actual == expected, repr(s) & " actual=" & $actual & " expected=" & $expected
    assert RunEnumerate(s) == actual
    assert run_enumerate(s.toSeq) == actual
    assert RunEnumerate(s.toSeq) == actual
    assert actual.sorted() == actual
    assert actual.deduplicate().len == actual.len

proc exhaustive(alphabet: string, maxLen: int) =
    for n in 0..maxLen:
        var count = 1
        for i in 0..<n: count *= alphabet.len
        for mask in 0..<count:
            var x = mask
            var s = newString(n)
            for i in 0..<n:
                s[i] = alphabet[x mod alphabet.len]
                x = x div alphabet.len
            check(s)

exhaustive("ab", 12)
exhaustive("abc", 8)
exhaustive("\0\1\xff", 6)
randomize(20261002)
for trial in 0..<5000:
    let n = rand(80)
    var s = newString(n)
    let alphabet = ["ab", "abc", "abcdefghijklmnopqrstuvwxyz", "\0\1\xff"][trial mod 4]
    for i in 0..<n: s[i] = sample(alphabet)
    check(s)
for n in 0..129:
    check(repeat('a', n))
    check(repeat("ab", n)[0..<n])
    check(repeat("abcde", n)[0..<n])
    var tm = newString(n)
    for i in 0..<n:
        var x = i
        var parity = 0
        while x > 0:
            parity = parity xor (x and 1)
            x = x shr 1
        tm[i] = "ab"[parity]
    check(tm)
    var a = "a"
    var b = "ab"
    while b.len < n:
        (a, b) = (b, a & b)
    check(b[0..<n])
    for pos in [0, n div 2, n - 1]:
        if pos >= 0 and pos < n:
            var s = repeat('a', n)
            s[pos] = 'b'
            check(s)

type Token = object
    x: int
proc `==`(a, b: Token): bool = a.x == b.x
let tokens = @[Token(x: 8), Token(x: -3), Token(x: 8), Token(x: -3), Token(x: 8)]
assert run_enumerate(tokens) == brute(tokens)
assert run_enumerate([7, -2, 7, -2, 7, -2]) == @[(2, 0, 6)]
assert run_enumerate(newSeq[int]()) == @[]
assert run_enumerate(@["a", "b", "a", "b"]) == @[(2, 0, 4)]
assert run_enumerate(@[1, 2, 1, 2, 9, 1, 2].toOpenArray(0, 3)) == @[(2, 0, 4)]
