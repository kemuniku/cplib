# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import std/[random, unittest]
import cplib/str/lyndon_factorization

proc less[T](s: openArray[T], a, b: (int, int)): bool =
    var i = a[0]
    var j = b[0]
    while i < a[1] and j < b[1] and s[i] == s[j]:
        i += 1
        j += 1
    if i == a[1]:
        return j < b[1]
    if j == b[1]:
        return false
    s[i] < s[j]

proc isLyndon[T](s: openArray[T], factor: (int, int)): bool =
    for split in factor[0] + 1..<factor[1]:
        if not less(s, factor, (split, factor[1])):
            return false
    true

suite "Lyndon factorization":
    test "known examples":
        check lyndon_factorization("") == newSeq[(int, int)]()
        check lyndon_factorization("a") == @[(0, 1)]
        check lyndon_factorization("aaaa") == @[(0, 1), (1, 2), (2, 3), (3, 4)]
        check lyndon_factorization("ababbab") == @[(0, 5), (5, 7)]
        check lyndon_factorization(@[1, 2, 1, 2, 0]) == @[(0, 2), (2, 4), (4, 5)]

    test "random small strings satisfy the factorization properties":
        var rng = initRand(20260713)
        for n in 0..30:
            for _ in 0..<100:
                var s = newString(n)
                for c in s.mitems:
                    c = char(ord('a') + rng.rand(3))

                let factors = lyndon_factorization(s)
                var position = 0
                for i, factor in factors:
                    check factor[0] == position
                    check factor[0] < factor[1]
                    check isLyndon(s, factor)
                    if i > 0:
                        check not less(s, factors[i - 1], factor)
                    position = factor[1]
                check position == s.len
