# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/min_cost_b_flow
import cplib/math/int128
import random

proc checkCertificate(g: MinCostBFlow, supply: seq[Int128], cost: Int128) =
    let potential = g.get_potential()
    doAssert potential.len == supply.len
    var balance = newSeq[Int128](supply.len)
    var reconstructed: Int128 = 0
    for i, e in g.get_edges():
        doAssert e == g.get_edge(i)
        doAssert e.lower <= e.flow and e.flow <= e.upper
        balance[e.src] += to_Int128(e.flow)
        balance[e.dst] -= to_Int128(e.flow)
        reconstructed += to_Int128(e.flow) * to_Int128(e.cost)
        let reduced = to_Int128(e.cost) + potential[e.src] - potential[e.dst]
        if e.flow > e.lower:
            doAssert reduced <= 0
        if e.flow < e.upper:
            doAssert reduced >= 0
    doAssert reconstructed == cost
    doAssert balance == supply

proc check(g: var MinCostBFlow, supply: seq[Int128], expected: Int128) =
    for repeat in 0..1:
        let answer = g.solve()
        doAssert answer.feasible
        doAssert answer.cost == expected
        checkCertificate(g, supply, answer.cost)

block:
    var g = initMinCostBFlow(0)
    g.check(@[], to_Int128(0))
    g = initMinCostBFlow(3)
    g.check(@[to_Int128(0), to_Int128(0), to_Int128(0)], to_Int128(0))
    g.add_supply(0, 1)
    doAssert not g.solve().feasible
    g.add_supply(1, -1)
    doAssert not g.solve().feasible
    g.add_edge(0, 1, 0, 1, 2)
    g.check(@[to_Int128(1), to_Int128(-1), to_Int128(0)], to_Int128(2))
    g.add_edge(0, 1, 0, 1, -3)
    g.check(@[to_Int128(1), to_Int128(-1), to_Int128(0)], to_Int128(-3))
    g.add_supply(0, -2)
    g.add_supply(1, 2)
    doAssert not g.solve().feasible
    g.add_edge(0, 1, -2, -1, 4)
    g.check(@[to_Int128(-1), to_Int128(1), to_Int128(0)], to_Int128(-11))

block:
    var g = initMinCostBFlow(4)
    g.add_edge(0, 1, 2, 2, -5)
    g.add_edge(1, 0, 0, 3, 1)
    g.add_edge(2, 3, -3, -1, 7)
    g.add_edge(3, 2, -3, -1, -2)
    g.add_edge(2, 2, -4, 5, -8)
    g.add_edge(3, 3, -2, 3, 9)
    g.add_edge(0, 0, 1, 1, 100)
    g.check(@[to_Int128(0), to_Int128(0), to_Int128(0), to_Int128(0)], to_Int128(19))

block:
    var g = initMinCostBFlow(1)
    for i in 0..<1000:
        g.add_edge(0, 0, -1_000_000_000, 1_000_000_000, -1_000_000_000)
    g.check(@[to_Int128(0)], -to_Int128(1000) * to_Int128(1_000_000_000) * to_Int128(1_000_000_000))

block:
    var g = initMinCostBFlow(1)
    for i in 0..<100:
        g.add_edge(0, 0, 1_000_000_000, 1_000_000_000, 1_000_000_000)
    for i in 0..<100:
        g.add_edge(0, 0, 1_000_000_000, 1_000_000_000, -1_000_000_000)
    g.check(@[to_Int128(0)], to_Int128(0))

block:
    var g = initMinCostBFlow(2)
    g.add_supply(0, high(int64))
    g.add_supply(0, 1)
    g.add_supply(1, low(int64))
    g.add_edge(1, 0, low(int64), high(int64), low(int64))
    let amount = to_Int128(low(int64))
    g.check(@[-amount, amount], amount * amount)

block:
    var g = initMinCostBFlow(1)
    g.add_edge(0, 0, low(int64), high(int64), low(int64))
    g.check(@[to_Int128(0)], to_Int128(high(int64)) * to_Int128(low(int64)))
    g = initMinCostBFlow(1)
    g.add_edge(0, 0, low(int64), high(int64), high(int64))
    g.check(@[to_Int128(0)], to_Int128(low(int64)) * to_Int128(high(int64)))

block:
    var g = initMinCostBFlow(3)
    g.add_supply(0, 1)
    g.add_supply(2, -1)
    g.add_edge(0, 1, 0, 2, low(int64))
    g.add_edge(1, 2, 0, 2, low(int64))
    g.check(@[to_Int128(1), to_Int128(0), to_Int128(-1)], to_Int128(2) * to_Int128(low(int64)))
    var snapshot = g.get_edges()
    snapshot[0].flow = 100
    doAssert g.get_edge(0).flow == 1
    var potentials = g.get_potential()
    potentials[0] = 100
    checkCertificate(g, @[to_Int128(1), to_Int128(0), to_Int128(-1)], to_Int128(2) * to_Int128(low(int64)))

when compileOption("assertions"):
    block:
        var g = initMinCostBFlow(1)
        discard g.solve()
        g.add_supply(0, 1)
        var caught = false
        try:
            discard g.get_potential()
        except AssertionDefect:
            caught = true
        doAssert caught
        g.add_supply(0, -1)
        discard g.solve()
        g.add_edge(0, 0, 0, 1, 0)
        caught = false
        try:
            discard g.get_edges()
        except AssertionDefect:
            caught = true
        doAssert caught

type Edge = tuple[src, dst, lower, upper, cost: int]

proc bruteForce(supply: seq[int], edges: seq[Edge]): tuple[feasible: bool, cost: int] =
    var balance = newSeq[int](supply.len)
    var best = high(int)
    proc dfs(i, cost: int) =
        if i == edges.len:
            if balance == supply:
                best = min(best, cost)
            return
        let e = edges[i]
        for amount in e.lower..e.upper:
            balance[e.src] += amount
            balance[e.dst] -= amount
            dfs(i + 1, cost + amount * e.cost)
            balance[e.src] -= amount
            balance[e.dst] += amount
    dfs(0, 0)
    (best != high(int), best)

proc compare(supply: seq[int], edges: seq[Edge]) =
    var g = initMinCostBFlow(supply.len)
    var wideSupply: seq[Int128]
    for v, b in supply:
        g.add_supply(v, int64(b))
        wideSupply.add(to_Int128(b))
    for i, e in edges:
        doAssert g.add_edge(e.src, e.dst, int64(e.lower), int64(e.upper), int64(e.cost)) == i
    let expected = bruteForce(supply, edges)
    let actual = g.solve()
    doAssert actual.feasible == expected.feasible
    if actual.feasible:
        doAssert actual.cost == to_Int128(expected.cost)
        checkCertificate(g, wideSupply, actual.cost)
        for i, e in g.get_edges():
            doAssert (e.src, e.dst, int(e.lower), int(e.upper), int(e.cost)) == edges[i]
    else:
        doAssert actual.cost == 0
    let again = g.solve()
    doAssert again.feasible == actual.feasible and again.cost == actual.cost

for src in 0..1:
    for dst in 0..1:
        for lower in -1..1:
            for upper in lower..1:
                for cost in -1..1:
                    for b0 in -2..2:
                        for b1 in -2..2:
                            compare(@[b0, b1], @[(src, dst, lower, upper, cost)])

var rng = initRand(20261003)
for trial in 0..<5000:
    let n = rng.rand(1..5)
    var supply = newSeq[int](n)
    var edges: seq[Edge]
    for i in 0..<rng.rand(0..7):
        let src = rng.rand(0..<n)
        let dst = rng.rand(0..<n)
        let lower = rng.rand(-3..3)
        let upper = lower + rng.rand(0..3)
        let cost = rng.rand(-5..5)
        edges.add((src, dst, lower, upper, cost))
        let f = rng.rand(lower..upper)
        supply[src] += f
        supply[dst] -= f
    if trial mod 3 == 0:
        for b in supply.mitems:
            b = rng.rand(-3..3)
    elif trial mod 3 == 1:
        supply[rng.rand(0..<n)] += 1
        supply[rng.rand(0..<n)] -= 1
    compare(supply, edges)

echo "Hello World"
