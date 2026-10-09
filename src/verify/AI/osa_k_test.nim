# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import tables
import cplib/math/osa_k

let table = initPrimeFactorTable(100)
assert table.primefactor(1) == @[]
assert table.primefactor(84) == @[2, 2, 3, 7]
let pf = table.primefactor_table(84)
assert pf[2] == 2
assert pf[3] == 1
assert pf[7] == 1
assert table.primefactor_tuple(84) == @[(2, 2), (3, 1), (7, 1)]

let factorCallback: proc(t: typeof(table), x: int): seq[int] {.nimcall.} = primefactor
doAssert factorCallback(table, 84) == @[2, 2, 3, 7]

proc trialFactor(x: int): seq[int] =
    var x = x
    var p = 2
    while p <= x div p:
        while x mod p == 0:
            result.add(p)
            x = x div p
        inc p
    if x > 1:
        result.add(x)

proc check(table: typeof(table), x: int) =
    let expected = trialFactor(x)
    doAssert table.primefactor(x) == expected
    var counts = initTable[int, int]()
    var pairs: seq[(int, int)]
    for p in expected:
        counts[p] = counts.getOrDefault(p) + 1
        if pairs.len > 0 and pairs[^1][0] == p:
            inc pairs[^1][1]
        else:
            pairs.add((p, 1))
    doAssert table.primefactor_table(x) == counts
    doAssert table.primefactor_tuple(x) == pairs

discard initPrimeFactorTable(0)
for limit in [1, 2, 3, 4, 8, 9, 16, 25, 27, 32, 49, 64, 81,
              97, 100, 121, 127, 128, 256, 1024, 4096, 20000]:
    let small = initPrimeFactorTable(limit)
    for x in 1..limit:
        check(small, x)

let large = initPrimeFactorTable(300000)
for x in [1, 2, 262144, 298598, 299993, 299999, 300000]:
    check(large, x)
var state = 314159265'u64
for i in 0..<10000:
    state = (state * 1664525'u64 + 1013904223'u64) and 0xffffffff'u64
    check(large, int(state mod 300000'u64) + 1)

for limit in [2999999, 3000000, 3000001, 4000000]:
    let linear = initPrimeFactorTable(limit)
    for x in 1..20000:
        check(linear, x)
    for x in [2097152, 2985984, limit-1, limit]:
        check(linear, x)
    for i in 0..<10000:
        state = (state * 1664525'u64 + 1013904223'u64) and 0xffffffff'u64
        check(linear, int(state mod uint64(limit)) + 1)

when compileOption("assertions"):
    for x in [0, -1, 101]:
        var rejected = false
        try:
            discard table.primefactor(x)
        except AssertionDefect:
            rejected = true
        doAssert rejected
