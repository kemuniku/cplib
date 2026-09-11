# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/hopcroft_karp
import random

proc brute(edges: seq[seq[bool]], right: int): int =
    var dp = newSeq[int](1 shl right)
    for row in edges:
        var next = dp
        for mask in 0..<dp.len:
            for u in 0..<right:
                if row[u] and (mask and (1 shl u)) == 0:
                    let target = mask or (1 shl u)
                    next[target] = max(next[target], dp[mask] + 1)
        dp = next
    for count in dp:
        result = max(result, count)

proc check(g: var HopcroftKarp, edges: seq[seq[bool]], right: int) =
    let expected = brute(edges, right)
    var plain = g
    doAssert plain.matching(useRelabel = false) == expected
    doAssert g.matching() == expected
    doAssert g.matching() == expected
    for pairs in [g.get_matching(), plain.get_matching()]:
        doAssert pairs.len == expected
        var usedLeft = newSeq[bool](edges.len)
        var usedRight = newSeq[bool](right)
        for (v, u) in pairs:
            doAssert edges[v][u]
            doAssert not usedLeft[v] and not usedRight[u]
            usedLeft[v] = true
            usedRight[u] = true

for left in 0..3:
    for right in 0..4:
        for mask in 0..<(1 shl (left * right)):
            var g = initHopcroftKarp(left, right)
            var edges = newSeq[seq[bool]](left)
            for v in 0..<left:
                edges[v] = newSeq[bool](right)
                for u in 0..<right:
                    if (mask and (1 shl (v * right + u))) != 0:
                        edges[v][u] = true
                        g.add_edge(v, u)
            g.check(edges, right)

var rng = initRand(712367)
for trial in 0..<500:
    let left = rng.rand(1..10)
    let right = rng.rand(1..8)
    var g = initHopcroftKarp(left, right)
    var edges = newSeq[seq[bool]](left)
    for v in 0..<left:
        edges[v] = newSeq[bool](right)
    for step in 0..<40:
        let v = rng.rand(left - 1)
        let u = rng.rand(right - 1)
        g.add_edge(v, u)
        edges[v][u] = true
        if step mod 5 == 0:
            g.check(edges, right)
    g.check(edges, right)

for trial in 0..<400:
    let left = rng.rand(1..12)
    let right = rng.rand(1..8)
    var g = initHopcroftKarp(left, right)
    var edges = newSeq[seq[bool]](left)
    for v in 0..<left:
        edges[v] = newSeq[bool](right)
    for step in 0..<rng.rand(0..left * right):
        let v = rng.rand(left - 1)
        let u = rng.rand(right - 1)
        g.add_edge(v, u)
        edges[v][u] = true
    g.check(edges, right)

block:
    const n = 128 * 129 div 2
    var g = initHopcroftKarp(n, n)
    var offset = 0
    for length in 1..128:
        for v in offset..<offset + length - 1:
            g.add_edge(v, v)
            g.add_edge(v, v + 1)
        g.add_edge(offset + length - 1, offset)
        offset += length
    doAssert g.matching() == n
    let pairs = g.get_matching()
    offset = 0
    for length in 1..128:
        for v in offset..<offset + length - 1:
            doAssert pairs[v] == (v, v + 1)
        doAssert pairs[offset + length - 1] == (offset + length - 1, offset)
        offset += length

block:
    const n = 200000
    var g = initHopcroftKarp(n, n)
    for v in 0..<n - 1:
        g.add_edge(v, v)
        g.add_edge(v, v + 1)
    g.add_edge(n - 1, 0)
    doAssert g.matching() == n
    let pairs = g.get_matching()
    for v in 0..<n - 1:
        doAssert pairs[v] == (v, v + 1)
    doAssert pairs[n - 1] == (n - 1, 0)

echo "Hello World"
