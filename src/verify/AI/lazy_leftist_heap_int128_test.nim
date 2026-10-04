# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/math/int128
import cplib/collections/lazy_leftist_heap
import random

var pool = initLazyLeftistHeapPool[Int128, int](zero = to_Int128(0))
var roots: array[8, int]
var oracle: array[8, seq[tuple[key: int64, value: int]]]
for root in roots.mitems: root = -1
var rng = initRand(940128)
var next = 0
let offset = to_Int128(high(int64)) * to_Int128(4)

proc check() =
    for i in 0..<roots.len:
        doAssert (roots[i] == -1) == (oracle[i].len == 0)
        if roots[i] != -1:
            var at = 0
            for j in 1..<oracle[i].len:
                if oracle[i][j] < oracle[i][at]: at = j
            let actual = pool.top(roots[i])
            doAssert actual.key == offset + to_Int128(oracle[i][at].key)
            doAssert actual.value == oracle[i][at].value

for step in 0..<10000:
    let a = rng.rand(roots.len - 1)
    case rng.rand(0..3)
    of 0:
        let key = rng.rand(-30..30).int64
        roots[a] = pool.meld(roots[a], pool.singleton(offset + to_Int128(key), next))
        oracle[a].add((key, next))
        inc next
    of 1:
        let delta = rng.rand(-30..30).int64
        pool.addAll(roots[a], to_Int128(delta))
        for item in oracle[a].mitems: item.key += delta
    of 2:
        let b = (a + rng.rand(1..<roots.len)) mod roots.len
        roots[a] = pool.meld(roots[a], roots[b])
        roots[b] = -1
        oracle[a].add(oracle[b])
        oracle[b] = @[]
    else:
        if roots[a] != -1:
            var at = 0
            for j in 1..<oracle[a].len:
                if oracle[a][j] < oracle[a][at]: at = j
            roots[a] = pool.pop(roots[a])
            oracle[a].delete(at)
    check()
for i in 0..<roots.len:
    while roots[i] != -1:
        check()
        var at = 0
        for j in 1..<oracle[i].len:
            if oracle[i][j] < oracle[i][at]: at = j
        roots[i] = pool.pop(roots[i])
        oracle[i].delete(at)
check()
stderr.writeLine("Int128 lazy leftist heap regression: 10000 oracle operations passed")
echo "Hello World"
