# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/math/powmod

assert powmod(2, 10, 1000) == 24
assert powmod(3, 0, 7) == 1
assert powmod(10, 2, 6) == 4
assert powmod(-2, 3, 5) == 2
assert powmod(-2, 2, 5) == 4
assert powmod(-5, 3, 5) == 0
assert powmod(-2, 0, 5) == 1
assert powmod(-2, 3, 1) == 0
assert powmod(low(int), 1, high(int)) == high(int) - 1

for m in 1..31:
    for a in -64..64:
        var expected = 1 mod m
        let base = ((a mod m) + m) mod m
        for n in 0..20:
            assert powmod(a, n, m) == expected
            expected = expected * base mod m

when compileOption("assertions"):
    for m in [-5, 0]:
        var rejected = false
        try:
            discard powmod(2, 3, m)
        except AssertionDefect:
            rejected = true
        assert rejected
