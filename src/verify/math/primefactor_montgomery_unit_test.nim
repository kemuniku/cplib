# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/math/primefactor
import algorithm, random, tables

proc oracle(n: int): seq[int] =
    var n = n
    var p = 2
    while p <= n div p:
        while n mod p == 0:
            result.add(p)
            n = n div p
        inc p
    if n > 1: result.add(n)

proc check(n: int, expected: seq[int]) =
    doAssert primefactor(n) == expected
    doAssert primefactor(n, false).sorted == expected
    var counts = initTable[int, int]()
    var runs: seq[(int, int)]
    for p in expected:
        counts[p] = counts.getOrDefault(p) + 1
        if runs.len > 0 and runs[^1][0] == p: inc runs[^1][1]
        else: runs.add((p, 1))
    doAssert primefactor_table(n) == counts
    doAssert primefactor_tuple(n) == runs

randomize(20261005)
check(low(int), @[])
for n in -5..5000: check(n, oracle(n))
var rng = initRand(810322)
for _ in 0..<300:
    let n = rng.rand(1..1_000_000_000)
    check(n, oracle(n))
for seed in 0..<8:
    randomize(seed)
    check(high(int), @[7, 7, 73, 127, 337, 92737, 649657])
    check(9223372036854775783.int, @[9223372036854775783.int])
    check(9223371994482243049.int, @[3037000493.int, 3037000493.int])
    check(4611686014132420609.int, @[2147483647, 2147483647])
    check(1000000016000000063.int, @[1000000007, 1000000009])
    check(3215031751.int, @[151, 751, 28351])
    check(3825123056546413051.int, @[149491, 747451, 34233211])
    check(341550071728321.int, @[10670053, 32010157])
    check(1000009000027000027.int, @[1000003, 1000003, 1000003])
var power = 1
var expected: seq[int]
for _ in 0..<62:
    power *= 2
    expected.add(2)
    check(power, expected)
power = 1
expected.setLen(0)
for _ in 0..<39:
    power *= 3
    expected.add(3)
    check(power, expected)
power = 1
expected.setLen(0)
for _ in 0..<27:
    power *= 5
    expected.add(5)
    check(power, expected)
echo "Hello World"
