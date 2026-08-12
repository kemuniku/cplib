# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/math/bmbm
import cplib/modint/modint

type Mint = modint998244353_barrett

block fibonacci:
    let a = @[Mint(0), Mint(1), Mint(1), Mint(2), Mint(3), Mint(5), Mint(8), Mint(13)]
    assert berlekamp_massey(a) == @[Mint(1), Mint(1)]
    assert linear_recurrence_kth(a, @[Mint(1), Mint(1)], 50) == Mint(607336789)
    assert bmbm(a, 50) == Mint(607336789)

block rational_series:
    # (1 + x) / (1 - x - x^2) = 1 + 2x + 3x^2 + 5x^3 + ...
    assert bostan_mori(@[Mint(1), Mint(1)], @[Mint(1), Mint(-1), Mint(-1)], 10) == Mint(144)

block geometric_and_zero:
    let geometric = @[Mint(3), Mint(6), Mint(12), Mint(24)]
    assert berlekamp_massey(geometric) == @[Mint(2)]
    assert bmbm(geometric, 20) == Mint(3) * Mint(2).pow(20)
    assert bmbm(newSeq[Mint](8), 100) == Mint(0)

block various_recurrences:
    for d in 1..8:
        var recurrence = newSeq[Mint](d)
        var a = newSeq[Mint](80)
        for i in 0..<d:
            recurrence[i] = Mint(i * i + d + 1)
            a[i] = Mint(i * 3 + 1)
        for i in d..<a.len:
            for j in 0..<d:
                a[i] += recurrence[j] * a[i-j-1]
        let known = a[0..<(2*d + 5)]
        assert bmbm(known, 79) == a[79]
        assert linear_recurrence_kth(known, recurrence, 79) == a[79]
