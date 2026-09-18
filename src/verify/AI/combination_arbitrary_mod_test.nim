# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/math/combination_arbitrary_mod

for modulus in 1..160:
    let c = initCombinationArbitraryMod(160, modulus)
    var rows = newSeq[seq[int]](161)
    for n in 0..160:
        rows[n] = newSeq[int](n + 1)
        rows[n][0] = 1 mod modulus
        rows[n][n] = 1 mod modulus
        for r in 1..<n:
            rows[n][r] = (rows[n - 1][r - 1] + rows[n - 1][r]) mod modulus
        var permutation = 1 mod modulus
        for r in 0..n:
            doAssert c.ncr(n, r) == rows[n][r]
            doAssert c.npr(n, r) == permutation
            permutation = permutation * (n - r) mod modulus
    for n in 0..50:
        for r in 0..50:
            let expected = if r == 0: 1 mod modulus
                           elif n == 0: 0
                           else: rows[n + r - 1][r]
            doAssert c.nhr(n, r) == expected
    doAssert c.ncr(-1, 0) == 0
    doAssert c.ncr(3, -1) == 0
    doAssert c.ncr(3, 4) == 0
    doAssert c.npr(-1, 0) == 0
    doAssert c.npr(3, -1) == 0
    doAssert c.npr(3, 4) == 0
    doAssert c.nhr(-1, 0) == 0
    doAssert c.nhr(1, -1) == 0
    let n = high(int)
    doAssert c.ncr(n, 0) == 1 mod modulus
    doAssert c.ncr(n, 1) == n mod modulus
    doAssert c.ncr(n, 2) == (n mod modulus) * ((n div 2) mod modulus) mod modulus
    doAssert c.ncr(n, n - 2) == c.ncr(n, 2)
    doAssert c.npr(n, 2) == (n mod modulus) * ((n - 1) mod modulus) mod modulus
    doAssert c.nhr(n, 1) == n mod modulus

for modulus in [1, 2, 8, 9, 72, 998244353, (1 shl 30) - 1]:
    let c0 = initCombinationArbitraryMod(0, modulus)
    doAssert c0.ncr(0, 0) == 1 mod modulus
    doAssert c0.npr(0, 0) == 1 mod modulus
    doAssert c0.nhr(0, 0) == 1 mod modulus
    let c = initCombinationArbitraryMod(60, modulus)
    var row = @[1 mod modulus]
    for n in 1..60:
        var next = newSeq[int](n + 1)
        next[0] = 1 mod modulus
        next[n] = 1 mod modulus
        for r in 1..<n:
            next[r] = (row[r - 1] + row[r]) mod modulus
        row = next
        for r in 0..n:
            doAssert c.ncr(n, r) == row[r]

echo "Hello World"
