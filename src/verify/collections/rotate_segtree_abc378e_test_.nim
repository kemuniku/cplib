# verification-helper: PROBLEM https://atcoder.jp/contests/abc378/tasks/abc378_e
import cplib/collections/rotate_segtree
import sequtils

proc solve(a: openArray[int], m: int): int =
    var counts = newSeq[int](m)
    var prefix = 0
    var sum = 0
    for x in a:
        prefix = (prefix + x) mod m
        inc counts[prefix]
        sum += prefix
    let tree = newRotateSegWith(counts, l + r, 0)
    for i, value in a:
        result += sum
        let x = value mod m
        tree[x] = tree[x] - 1
        sum -= x
        let below = tree.get(0, x)
        sum += below * m - (a.len - i - 1) * x
        tree.rotate(x)

when defined(testRotateModSigma):
    import random
    proc oracle(a: openArray[int], m: int): int =
        for l in 0..<a.len:
            var sum = 0
            for r in l..<a.len:
                sum += a[r]
                result += sum mod m
    doAssert solve([2, 5, 0], 4) == 10
    doAssert solve([320, 578, 244, 604, 145, 839, 156, 857, 556, 400], 100) == 2736
    for n in 1..6:
        var cases = 1
        for i in 0..<n: cases *= 3
        for code in 0..<cases:
            var a = newSeq[int](n)
            var code = code
            for i in 0..<n:
                a[i] = code mod 3
                code = code div 3
            for m in 1..7: doAssert solve(a, m) == oracle(a, m)
    var rng = initRand(378)
    for i in 0..<1000:
        let n = rng.rand(1..40)
        let a = newSeqWith(n, rng.rand(0..1_000_000_000))
        let m = rng.rand(1..50)
        doAssert solve(a, m) == oracle(a, m)
    let a = newSeqWith(200000, 1_000_000_000)
    doAssert solve(a, 1) == 0
    doAssert solve(a, 200000) == 0
    let b = newSeqWith(200000, 1)
    let total = 200000 * 200001 * 200002 div 6
    doAssert solve(b, 200000) == total - 200000
    echo "Hello World"
else:
    proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
    proc ii(): int = scanf("%lld", addr result)
    let n = ii()
    let m = ii()
    let a = newSeqWith(n, ii())
    echo solve(a, m)
