# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
include cplib/graph/internal/weighted_matching_engine

const n = 1500
var s = MatchingMachine[true](n: n, leaves: newSeq[MatchingLeaf](n + 1))
var order = newSeq[int](n)
var expected = newSeq[int64](n + 1)
var root = 0
for v in 1..n:
    s.leaves[v] = MatchingLeaf(height: 1, count: 1, potential: int64(v), edge: -1, minimum: MatchingInfinity)
    expected[v] = int64(v)
    order[v - 1] = v
    root = s.concatenate(root, v)

proc inspect(v, parent: int): tuple[height, count: int] =
    if v == 0: return
    doAssert s.leaves[v].parent == parent
    let a = inspect(s.leaves[v].left, v)
    let b = inspect(s.leaves[v].right, v)
    doAssert abs(a.height - b.height) <= 1
    result = (1 + max(a.height, b.height), 1 + a.count + b.count)
    doAssert result == (s.leaves[v].height, s.leaves[v].count)

var rng = initRand(6132701)
for trial in 0..<3000:
    let cut = rng.rand(0..n)
    let delta = int64(rng.rand(-1000..1000))
    let parts = s.split(root, cut)
    s.apply(parts.left, delta)
    for i in 0..<cut: expected[order[i]] += delta
    root = s.concatenate(parts.right, parts.left)
    order = order[cut..<n] & order[0..<cut]
    if trial mod 10 == 0:
        doAssert inspect(root, 0).count == n
        for i, v in order:
            doAssert s.rank(v) == i
            doAssert s.potential(v) == expected[v]
echo "Hello World"
