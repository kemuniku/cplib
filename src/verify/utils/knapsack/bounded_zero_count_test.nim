# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import random
import cplib/utils/knapsack

assert solve_BoundedKnapsack(@[(v: 5, w: 2, m: 0)], 5) == 0
assert solve_BoundedKnapsack(@[(v: 5, w: 2, m: 0), (v: 7, w: 3, m: 2)], 6) == 14
assert solve_BoundedKnapsack(@[(v: 5, w: 0, m: 0)], 0) == 0
assert solve_BoundedKnapsack(@[(v: 5, w: 0, m: 2), (v: 7, w: 3, m: 0)], 0) == 10
assert solve_BoundedKnapsack(@[(v: 5, w: 1, m: 0)], 0) == 0
assert solve_BoundedKnapsack(@[(v: 5, w: 20, m: 0)], 5) == 0

proc naive(items: seq[tuple[v, w, m: int]], capacity: int): int =
    var dp = newSeq[int](capacity + 1)
    for (value, weight, count) in items:
        var next = newSeq[int](capacity + 1)
        for c in 0..capacity:
            for k in 0..count:
                if k * weight <= c:
                    next[c] = max(next[c], dp[c-k*weight] + k*value)
        dp = next
    dp[capacity]

var rng = initRand(1200)
for trial in 0..<300:
    var items: seq[tuple[v, w, m: int]]
    for i in 0..<rng.rand(0..7):
        items.add((rng.rand(0..20), rng.rand(0..8), rng.rand(0..5)))
    let capacity = rng.rand(0..25)
    assert solve_BoundedKnapsack(items, capacity) == naive(items, capacity)
