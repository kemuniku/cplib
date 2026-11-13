# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sequtils
import cplib/graph/graph
import cplib/graph/count_topologicalsort
import cplib/math/combination
import cplib/modint/modint

type Mint = modint998244353_barrett
type Montgomery = modint998244353_montgomery
var rng = initRand(13579)

template expectAssertion(body: untyped) =
    block:
        var raised = false
        try:
            body
        except AssertionDefect:
            raised = true
        doAssert raised

proc rankDP[T](forward: openArray[bool]): T =
    var dp = @[T.init(1)]
    for direction in forward:
        var prefix = newSeq[T](dp.len + 1)
        for i in 0..<dp.len: prefix[i + 1] = prefix[i] + dp[i]
        var next = newSeq[T](dp.len + 1)
        for i in 0..dp.len:
            next[i] = if direction: prefix[i] else: prefix[^1] - prefix[i]
        dp = move(next)
    for value in dp: result += value

for n in 1..10:
    for mask in 0..<(1 shl (n - 1)):
        var forward = newSeq[bool](n - 1)
        var permutation = toSeq(0..<n)
        rng.shuffle(permutation)
        var g = initUnWeightedDirectedGraph(n)
        for i in 0..<n - 1:
            forward[i] = (mask and (1 shl i)) == 0
            let u = if forward[i]: permutation[i] else: permutation[i + 1]
            let v = if forward[i]: permutation[i + 1] else: permutation[i]
            g.add_edge(u, v)
            if i mod 3 == 0: g.add_edge(u, v)
        let expected = Mint.init(g.count_topologicalsort())
        doAssert count_topologicalsort_path_directions[Mint](forward) == expected
        doAssert count_topologicalsort_path[Mint](g) == expected
        doAssert count_topologicalsort_path_directions[Montgomery](forward).val == expected.val

for n in [17, 32, 33, 63, 64, 65, 100, 127, 128, 129, 256, 333, 511]:
    for trial in 0..<4:
        var forward = newSeq[bool](n - 1)
        for i in 0..<forward.len: forward[i] = rng.rand(1) == 0
        let expected = rankDP[Mint](forward)
        doAssert count_topologicalsort_path_directions[Mint](forward) == expected
        doAssert count_topologicalsort_path_directions[Montgomery](forward).val == expected.val
        if trial == 0:
            var g = initUnWeightedDirectedGraph(n)
            for i, direction in forward:
                if direction: g.add_edge(i, i + 1)
                else: g.add_edge(i + 1, i)
            doAssert count_topologicalsort_forest[Mint](g) == expected

block:
    doAssert count_topologicalsort_path[Mint](initUnWeightedDirectedGraph(0)) == Mint.init(1)
    doAssert count_topologicalsort_path_directions[Mint](newSeq[bool]()) == Mint.init(1)
    var sg = initUnWeightedDirectedStaticGraph(4)
    var wg = initWeightedDirectedGraph(4, float)
    var swg = initWeightedDirectedStaticGraph(4, int64)
    for (u, v) in [(0, 1), (0, 1), (2, 1), (2, 3)]:
        sg.add_edge(u, v)
        wg.add_edge(u, v, -1.5)
        swg.add_edge(u, v, -7)
    sg.build()
    swg.build()
    doAssert count_topologicalsort_path[Mint](sg) == Mint.init(5)
    doAssert count_topologicalsort_path[Mint](wg) == Mint.init(5)
    doAssert count_topologicalsort_path[Mint](swg) == Mint.init(5)

for edges in [@[(0, 0)], @[(0, 1), (1, 0)], @[(0, 1), (1, 2), (2, 0)]]:
    var g = initUnWeightedDirectedGraph(3)
    for (u, v) in edges: g.add_edge(u, v)
    doAssert count_topologicalsort_path[Mint](g) == Mint.init(0)

block:
    expectAssertion:
        discard count_topologicalsort_path[Mint](initUnWeightedDirectedGraph(2))
    var star = initUnWeightedDirectedGraph(4)
    for v in 1..3: star.add_edge(0, v)
    expectAssertion:
        discard count_topologicalsort_path[Mint](star)
    var disconnected = initUnWeightedDirectedGraph(5)
    for (u, v) in [(0, 1), (1, 2), (0, 2), (3, 4)]: disconnected.add_edge(u, v)
    expectAssertion:
        discard count_topologicalsort_path[Mint](disconnected)

block:
    type Dynamic = modint_barrett
    type DynamicMontgomery = modint_montgomery
    for modulus in [17, 1000000007, 998244353, 101, 998244353]:
        Dynamic.setMod(modulus)
        DynamicMontgomery.setMod(modulus)
        let n = min(350, modulus - 1)
        var forward = newSeq[bool](n - 1)
        for i in 0..<forward.len: forward[i] = rng.rand(1) == 0
        let expected = rankDP[Dynamic](forward)
        doAssert count_topologicalsort_path_directions[Dynamic](forward) == expected
        doAssert count_topologicalsort_path_directions[DynamicMontgomery](forward).val == expected.val
    Dynamic.setMod(7)
    expectAssertion:
        discard count_topologicalsort_path_directions[Dynamic](newSeq[bool](6))

block:
    let n = 100000
    var forward = newSeqWith(n - 1, true)
    doAssert count_topologicalsort_path_directions[Mint](forward) == Mint.init(1)
    for i in 0..<forward.len: forward[i] = false
    doAssert count_topologicalsort_path_directions[Mint](forward) == Mint.init(1)
    for i in 0..<forward.len: forward[i] = true
    let cut = 54321
    forward[cut - 1] = false
    let comb = initCombination[Mint](n)
    doAssert count_topologicalsort_path_directions[Mint](forward) == comb.ncr(n, cut) - 1

echo "Hello World"
