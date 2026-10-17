# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/collections/persistent_array

type Box = ref object
    value: int

proc check(shift: static int) =
    var rng = initRand(82941 + shift)
    let base = 1 shl shift
    for n in [0, 1, 2, base-1, base, base+1, base*base-1, base*base, base*base+1]:
        var initial = newSeq[string](n)
        for i in 0..<n: initial[i] = $i
        var versions = @[initPersistentArray(initial, shift)]
        var oracle = @[initial]
        doAssert versions[0].toseq == initial
        if n == 0: continue
        for step in 0..<(if shift >= 8: 12 else: 80):
            let parent = rng.rand(versions.high)
            let index = if step mod 3 == 0: 0 elif step mod 3 == 1: n-1 else: rng.rand(n-1)
            var next = oracle[parent]
            next[index] = $step & "changed"
            versions.add versions[parent].change_value(index, next[index])
            oracle.add next
            for v in [0, parent, versions.high]:
                for sample in 0..<min(n, 300):
                    let i = if n <= 300: sample else: rng.rand(n-1)
                    doAssert versions[v][i] == oracle[v][i]
                doAssert versions[v][0] == oracle[v][0]
                doAssert versions[v][n-1] == oracle[v][n-1]
        for v in 0..<versions.len: doAssert versions[v].toseq == oracle[v]
    let a = Box(value: 3)
    let b = Box(value: 7)
    let pa = initPersistentArray([a, nil, b], shift)
    let pb = pa.change_value(1, a)
    doAssert pa[0] == a and pa[1] == nil and pa[2] == b
    doAssert pb[0] == a and pb[1] == a and pb[2] == b
    a.value = 11
    doAssert pa[0].value == 11 and pb[1].value == 11
    when compileOption("assertions"):
        var rejected = false
        try:
            discard pa[3]
        except AssertionDefect: rejected = true
        doAssert rejected
check(1)
check(2)
check(5)
check(8)
echo "Hello World"
