# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sequtils
import cplib/utils/cow_game

template rejects(body: untyped) =
    block:
        var rejected = false
        try: body
        except ValueError: rejected = true
        doAssert rejected

type Edge = tuple[src, dst, cost: int]
const unreachable = 1_000_000

proc same(a, b: CowResult): bool =
    a.status == b.status and (a.status != cowFinite or a.value == b.value)

proc floyd(n: int, edges: seq[Edge]): seq[seq[int]] =
    result = newSeqWith(n, newSeqWith(n, unreachable))
    for i in 0..<n: result[i][i] = 0
    for e in edges: result[e.src][e.dst] = min(result[e.src][e.dst], e.cost)
    for k in 0..<n:
        for i in 0..<n:
            for j in 0..<n:
                if result[i][k] != unreachable and result[k][j] != unreachable:
                    result[i][j] = min(result[i][j], result[i][k] + result[k][j])

proc checkAssignment(xs: seq[CowVariable], edges: seq[Edge]) =
    doAssert xs[0].getValue() == 0
    for e in edges:
        doAssert xs[e.dst].getValue() - xs[e.src].getValue() <= e.cost

proc checkGraph(n: int, edges: seq[Edge], algorithm: CowAlgorithm) =
    let p = initCowGame(algorithm)
    var xs = @[p.origin()]
    for i in 1..<n: xs.add(p.getVariable())
    for e in edges: p += xs[e.dst] - xs[e.src] <= e.cost
    let ds = floyd(n, edges)
    var feasible = true
    for i in 0..<n:
        if ds[i][i] < 0: feasible = false
    rejects: discard xs[0].getValue()
    doAssert p.solve() == feasible
    if feasible: checkAssignment(xs, edges)
    else:
        rejects: discard xs[0].getValue()
    for i in 0..<n:
        for j in 0..<n:
            let upper = p.maximize(xs[j] - xs[i])
            let lower = p.minimize(xs[j] - xs[i])
            if not feasible:
                doAssert upper.status == cowInfeasible and lower.status == cowInfeasible
            else:
                if ds[i][j] == unreachable: doAssert upper.status == cowUnbounded
                else:
                    doAssert upper.status == cowFinite
                    doAssert upper.value == ds[i][j]
                if ds[j][i] == unreachable: doAssert lower.status == cowUnbounded
                else:
                    doAssert lower.status == cowFinite
                    doAssert lower.value == -ds[j][i]
            if i == 0:
                doAssert same(p.maximize(xs[j]), upper)
                doAssert same(p.minimize(xs[j]), lower)
    var allUpper = feasible
    var allLower = feasible
    for i in 0..<n:
        if ds[0][i] == unreachable: allUpper = false
        if ds[i][0] == unreachable: allLower = false
    doAssert p.maximizeVariables() ==
        (if not feasible: cowInfeasible elif allUpper: cowFinite else: cowUnbounded)
    if allUpper:
        checkAssignment(xs, edges)
        for i in 0..<n: doAssert xs[i].get_value() == ds[0][i]
    else:
        rejects: discard xs[0].getValue()
    doAssert p.minimizeVariables() ==
        (if not feasible: cowInfeasible elif allLower: cowFinite else: cowUnbounded)
    if allLower:
        checkAssignment(xs, edges)
        for i in 0..<n: doAssert xs[i].getValue() == -ds[i][0]
    else:
        rejects: discard xs[0].getValue()
    doAssert p.solve() == feasible
    if feasible: checkAssignment(xs, edges)
    let extra = p.get_Variable()
    rejects: discard xs[0].getValue()
    rejects: discard extra.getValue()
    doAssert p.solve() == feasible
    doAssert p.maximize(extra).status == (if feasible: cowUnbounded else: cowInfeasible)

for encoding in 0..<256:
    var code = encoding
    var edges: seq[Edge]
    for src in 0..<2:
        for dst in 0..<2:
            let digit = code mod 4
            code = code div 4
            if digit != 0: edges.add((src, dst, digit - 2))
    checkGraph(2, edges, cowBellmanFord)

var rng = initRand(20261004)
for algorithm in [cowDijkstra, cowBellmanFord]:
    for trial in 0..<1200:
        let n = rng.rand(1..6)
        var edges: seq[Edge]
        for i in 0..<rng.rand(0..18):
            edges.add((rng.rand(n-1), rng.rand(n-1),
                if algorithm == cowDijkstra: rng.rand(0..4) else: rng.rand(-4..4)))
        checkGraph(n, edges, algorithm)

proc checkEnumeration(edges: seq[Edge]) =
    let p = initCowGameBellmanFord()
    let xs = @[p.origin(), p.getVariable(), p.getVariable(), p.getVariable()]
    for e in edges: p += xs[e.dst] - xs[e.src] <= e.cost
    let ds = floyd(4, edges)
    var exists = false
    var lows = newSeqWith(16, high(int))
    var highs = newSeqWith(16, low(int))
    for a in -12..12:
        for b in -12..12:
            for c in -12..12:
                let values = [0, a, b, c]
                var valid = true
                for e in edges:
                    if values[e.dst] - values[e.src] > e.cost: valid = false
                if valid:
                    exists = true
                    for i in 0..<4:
                        for j in 0..<4:
                            lows[i*4+j] = min(lows[i*4+j], values[j] - values[i])
                            highs[i*4+j] = max(highs[i*4+j], values[j] - values[i])
    doAssert p.solve() == exists
    if exists:
        for i in 0..<4:
            for j in 0..<4:
                if ds[i][j] != unreachable:
                    doAssert p.maximize(xs[j] - xs[i]).value == highs[i*4+j]
                if ds[j][i] != unreachable:
                    doAssert p.minimize(xs[j] - xs[i]).value == lows[i*4+j]

for trial in 0..<80:
    var edges: seq[Edge]
    for i in 0..<rng.rand(0..9): edges.add((rng.rand(3), rng.rand(3), rng.rand(-2..2)))
    checkEnumeration(edges)

block:
    let p = makeProblem()
    let x = p.get_Variable()
    let y = p.getVariable()
    p += x <= 3
    p += y <= 2 + x
    p += y >= x
    p += -4 <= x
    p += 9 >= y
    p += x >= -6
    p += y - x >= -2
    p += x <= y - 0
    p += y >= x + 0
    p.addEquality(p.origin(), 0)
    doAssert p.maximizeVariables() == cowFinite
    doAssert x.get_value() == 3 and y.getValue() == 5
    doAssert p.minimizeVariables() == cowFinite
    doAssert x.getValue() == -4 and y.getValue() == -4
    rejects: p += y <= x - 1
    rejects: p += x - y <= -1
    rejects: p += x <= -1
    rejects: p += x <= y + -1
    rejects: p += x >= 1
    rejects: p += 1 <= x
    rejects: p += x >= y + 1
    rejects: p += x - y >= 1
    rejects: p.addEquality(x, 2)
    rejects: p.addEquality(x, y + 2)
    doAssert x.getValue() == -4

block:
    let p = initCowGameBellmanFord()
    let x = p.getVariable()
    let y = p.getVariable()
    p.addEquality(x, -3)
    p.addEquality(y, x + 7)
    doAssert p.maximize(x).value == -3
    doAssert p.minimize(y).value == 4
    doAssert p.solve()
    doAssert x.getValue() == -3 and y.getValue() == 4
    p += y <= 3
    rejects: discard y.getValue()
    doAssert not p.solve()
    doAssert p.maximize(x).status == cowInfeasible

block:
    let p = initCowGameBellmanFord()
    let x = p.getVariable()
    let y = p.getVariable()
    p += x - y <= -3
    doAssert p.maximize(x - y).value == -3
    doAssert p.maximize(x).status == cowUnbounded
    doAssert p.minimize(y).status == cowUnbounded
    doAssert p.solve()
    doAssert x.getValue() - y.getValue() <= -3

block:
    let p = initCowGameBellmanFord()
    let x = p.getVariable()
    let y = p.getVariable()
    let z = p.getVariable()
    p += x <= 1
    p += y - z <= -2
    p += z - y <= 1
    doAssert p.maximize(x).status == cowInfeasible
    doAssert p.maximize(x - x).status == cowInfeasible
    doAssert not p.solve()

block:
    let p = initCowGame()
    let q = initCowGameBellmanFord()
    let x = p.getVariable()
    let y = q.getVariable()
    rejects: discard x - y
    rejects: discard x <= y + 1
    rejects: discard x >= y
    rejects: q += x <= 1
    rejects: discard q.maximize(x)
    rejects: discard q.minimize(x - x)
    rejects: q.addEquality(x, 0)
    let invalid = default(CowVariable)
    rejects: discard invalid.getValue()
    rejects: discard invalid + 1
    rejects: p += default(CowConstraint)
    rejects: discard p.maximize(default(CowDifference))
    let nilProblem = default(CowGame)
    rejects: discard nilProblem.solve()
    rejects: discard nilProblem.getVariable()

for algorithm in [cowDijkstra, cowBellmanFord]:
    block:
        let p = initCowGame(algorithm)
        doAssert p.solve()
        doAssert p.maximizeVariables() == cowFinite
        doAssert p.minimizeVariables() == cowFinite
        doAssert p.origin().getValue() == 0
        doAssert p.maximize(p.origin()).value == 0
    block:
        let p = initCowGame(algorithm)
        let x = p.getVariable()
        let y = p.getVariable()
        let limit = (high(int) - 1) div 3 div 2
        p += x <= limit
        p += y <= x + limit
        doAssert p.maximize(y).value == 2 * limit
        doAssert p.maximizeVariables() == cowFinite
        doAssert y.getValue() == 2 * limit
        p += x <= limit + 1
        rejects: discard p.solve()
        rejects: discard p.maximize(y)
        rejects: discard y.getValue()

    block:
        let p = initCowGame(algorithm)
        var xs = @[p.origin()]
        for i in 1..<13: xs.add(p.getVariable())
        let limit = (high(int) - 1) div 13 div 2
        for i in 1..<13: p += xs[i] <= xs[i-1] + limit
        doAssert p.maximize(xs[^1]).value == 12 * limit
        doAssert p.minimize(xs[0] - xs[^1]).value == -12 * limit
        doAssert p.maximizeVariables() == cowFinite
        doAssert xs[^1].getValue() == 12 * limit
    block:
        let p = initCowGame(algorithm)
        let x = p.getVariable()
        rejects: p += x <= low(int)
        rejects: discard x - low(int)
        rejects: discard x >= low(int)
        p += x <= high(int)
        rejects: discard p.solve()
    block:
        let p = initCowGame(algorithm)
        let x = p.getVariable()
        p += x <= (high(int) - 1) div 2 div 2
        doAssert p.solve()
        discard p.getVariable()
        rejects: discard p.solve()

block:
    let p = initCowGameBellmanFord()
    let x = p.getVariable()
    let y = p.getVariable()
    let limit = (high(int) - 1) div 3 div 2
    p += x <= -limit
    p += y <= x - limit
    doAssert p.maximize(y).value == -2 * limit
    doAssert p.solve()
    doAssert y.getValue() == -2 * limit
    p += p.origin() <= y + limit
    doAssert not p.solve()
    doAssert p.maximize(x).status == cowInfeasible

block:
    let p = initCowGameBellmanFord()
    let x = p.getVariable()
    let limit = (high(int) - 1) div 2 div 2
    p += p.origin() <= x - limit
    doAssert p.solve()
    doAssert x.getValue() == limit
    doAssert p.minimize(x).value == limit

echo "Hello World"
