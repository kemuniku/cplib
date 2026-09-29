# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/utils/parallel_binary_search
import cplib/collections/unionfind

block:
    var calls = 0
    proc reset() = inc calls
    proc apply(idx: int) = inc calls
    proc check(idx: int): bool =
        inc calls
        true
    doAssert parallelBinarySearch(0, 0, reset, apply, check).len == 0
    doAssert parallelBinarySearch(100, 0, reset, apply, check).len == 0
    doAssert calls == 0

for m in 0..65:
    var count = -1
    var resets, applications: int
    var checks = newSeq[int](m + 2)
    proc reset() =
        count = 0
        inc resets
    proc apply(idx: int) =
        doAssert idx == count and idx < m
        inc count
        inc applications
    proc check(q: int): bool =
        doAssert 0 <= count and count <= m
        inc checks[q]
        count >= q
    let answers = parallelBinarySearch(m, m + 2, reset, apply, check)
    for q, answer in answers: doAssert answer == q
    var rounds = 0
    var width = m + 1
    while width > 0:
        inc rounds
        width = width div 2
    doAssert resets <= rounds
    doAssert applications <= m * rounds
    for calls in checks: doAssert 1 <= calls and calls <= rounds

var rng = initRand(723491)
for trial in 0..<100:
    let m = rng.rand(80)
    let q = rng.rand(100) + 1
    let initial = rng.rand(20)
    var updates = newSeq[int](m)
    for value in updates.mitems: value = rng.rand(10)
    var targets = newSeq[int](q)
    for target in targets.mitems: target = rng.rand(500)
    var expected = newSeq[int](q)
    for idx, target in targets:
        expected[idx] = m + 1
        var total = initial
        for count in 0..m:
            if total >= target:
                expected[idx] = count
                break
            if count < m: total += updates[count]
    var total, position: int
    var fingerprint: int64
    var prefixes = newSeq[int64](m + 1)
    for i, value in updates:
        prefixes[i + 1] = (prefixes[i] * 31 + value) mod 1000000007
    proc reset() =
        total = initial
        position = 0
        fingerprint = 0
    proc apply(idx: int) =
        doAssert idx == position
        total += updates[idx]
        fingerprint = (fingerprint * 31 + updates[idx]) mod 1000000007
        inc position
    proc check(idx: int): bool =
        doAssert fingerprint == prefixes[position]
        total >= targets[idx]
    for repeat in 0..<2:
        doAssert parallelBinarySearch(m, q, reset, apply, check) == expected

for trial in 0..<40:
    let n = rng.rand(14) + 1
    let m = rng.rand(40)
    var edges = newSeq[(int, int)](m)
    for edge in edges.mitems: edge = (rng.rand(n - 1), rng.rand(n - 1))
    var labels = newSeq[int](n)
    for v in 0..<n: labels[v] = v
    var expected = newSeq[int](n * n)
    for answer in expected.mitems: answer = m + 1
    for count in 0..m:
        for u in 0..<n:
            for v in 0..<n:
                if labels[u] == labels[v] and expected[u * n + v] == m + 1:
                    expected[u * n + v] = count
        if count < m:
            let a = labels[edges[count][0]]
            let b = labels[edges[count][1]]
            for label in labels.mitems:
                if label == b: label = a
    var uf: UnionFind
    proc reset() = uf = initUnionFind(n)
    proc apply(idx: int) = uf.unite(edges[idx][0], edges[idx][1])
    proc check(idx: int): bool = uf.issame(idx div n, idx mod n)
    doAssert parallelBinarySearch(m, n * n, reset, apply, check) == expected

echo "Hello World"
