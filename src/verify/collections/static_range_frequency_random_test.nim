# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/static_range_frequency
import random

proc naive(a: openArray[int], l, r, x: int): int =
    for i in l..<r:
        if a[i] == x:
            inc result

proc checkAll(a: seq[int]) =
    let index = initStaticRangeFrequency(a)
    let probes = a & @[int.low, int.high, -1, 0, 1, 123456789]
    for l in 0..a.len:
        for r in l..a.len:
            for x in probes:
                doAssert index.count(l, r, x) == naive(a, l, r, x)

checkAll(@[])
checkAll(@[0])
checkAll(@[int.low, int.high, 0, -1, int.low, int.high])
checkAll(@[-3, -1, -3, 0, 1, 0])
checkAll(@[int.low, int.low+1, int.low+3, int.low])
checkAll(@[int.high, int.high-1, int.high-3, int.high])

var rng = initRand(20260930)
for n in [8, 9, 63, 64, 65, 127, 128, 129, 511, 512, 513, 4097]:
    for mode in 0..<7:
        var a = newSeq[int](n)
        for i in 0..<n:
            a[i] = case mode
                of 0: int.high
                of 1: rng.rand(15)-8
                of 2: (rng.rand(255)-128)*1000000007
                of 3: i*1000000007
                of 4: (if i mod 17 == 0: rng.rand(1000000000) else: -7)
                of 5: i div 8
                else: i div 9
        let index = initStaticRangeFrequency(a)
        for trial in 0..<1000:
            let l = rng.rand(n)
            let r = l+rng.rand(n-l)
            let x = if trial mod 4 != 0: a[rng.rand(n-1)] else: rng.rand(1000000000)
            doAssert index.count(l, r, x) == naive(a, l, r, x)
        for x in a:
            doAssert index.count(0, n, x) == naive(a, 0, n, x)
            doAssert index.count(n, n, x) == 0
        doAssert index.count(0, n, int.low) == 0

for trial in 0..<100:
    var a = newSeq[int](rng.rand(12))
    for x in a.mitems:
        x = rng.rand(10)-5
    checkAll(a)

var source = @[4, 2, 4, 3]
let independent = initStaticRangeFrequency(source)
source[0] = 2
doAssert independent.count(0, 4, 4) == 2

echo "Hello World"
