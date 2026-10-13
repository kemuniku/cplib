# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/math/static_gcd

proc euclid(a, b: int): int =
    var x = a
    var y = b
    while y != 0:
        let remainder = x mod y
        x = y
        y = remainder
    x

proc check(table: StaticGCD, a, b: int) =
    let expected = euclid(a, b)
    doAssert table.gcd(a, b) == expected, "a=" & $a & " b=" & $b
    doAssert table.gcd(b, a) == expected, "a=" & $b & " b=" & $a

for limit in 0..64:
    let table = initStaticGCD(limit)
    for a in 0..limit:
        for b in 0..a:
            check(table, a, b)

for limit in [120, 121, 122, 255, 256, 257, 999, 1000, 1023, 1024, 1025]:
    let table = initStaticGCD(limit)
    for a in 0..limit:
        for b in 0..a:
            check(table, a, b)

block:
    const limit = 1_000_000
    let table = initStaticGCD(limit)
    let special = [0, 1, 2, 3, 4, 8, 16, 27, 64, 81, 121, 128, 210,
                   243, 256, 512, 729, 997, 999, 1000, 1001, 1009,
                   1024, 1728, 2187, 4096, 15625, 30030, 65536,
                   117649, 510510, 524288, 531441, 823543, 994009,
                   998001, 999983, 999999, limit]
    for a in special:
        for b in special:
            check(table, a, b)
    for a in 0..limit:
        doAssert table.gcd(a, 0) == a
        doAssert table.gcd(0, a) == a
        doAssert table.gcd(a, 1) == 1
        doAssert table.gcd(a, a) == a
        check(table, a, limit)
    var rng = initRand(1380)
    for _ in 0..<200_000:
        check(table, rng.rand(limit), rng.rand(limit))
    for _ in 0..<10_000:
        let common = rng.rand(1..limit)
        let a = common * rng.rand(1..limit div common)
        let b = common * rng.rand(1..limit div common)
        check(table, a, b)

when compileOption("assertions"):
    var rejected = false
    try:
        discard initStaticGCD(-1)
    except AssertionDefect:
        rejected = true
    doAssert rejected
    let table = initStaticGCD(10)
    for (a, b) in [(-1, 0), (0, -1), (11, 0), (0, 11), (1, 11), (11, 1)]:
        rejected = false
        try:
            discard table.gcd(a, b)
        except AssertionDefect:
            rejected = true
        doAssert rejected

echo "Hello World"
