# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/graph/graph
import cplib/graph/warshall_floyd_avx
import cplib/utils/constants

var g = initWeightedDirectedGraph(3)
g.add_edge(0, 1, 2)
g.add_edge(1, 2, 3)
g.add_edge(0, 2, 10)
let wf = g.warshall_floyd()
assert not wf.negative_cycle
assert wf.d[0][2] == 5

var parallel = initWeightedDirectedGraph(2)
parallel.add_edge(0, 1, 3)
parallel.add_edge(0, 1, 7)
parallel.add_edge(0, 0, 5)
let parallelWf = parallel.warshall_floyd()
assert not parallelWf.negative_cycle
assert parallelWf.d[0][0] == 0
assert parallelWf.d[0][1] == 3

# Exercise both the four-lane AVX2 loop and its scalar tail with costs which
# cannot be represented by int32.
var wide = initWeightedDirectedGraph(10)
wide.add_edge(0, 1, int(3_000_000_000))
wide.add_edge(1, 2, int(4_000_000_000))
wide.add_edge(2, 9, int(5_000_000_000))
wide.add_edge(0, 9, int(20_000_000_000))
let wideWf = wide.warshall_floyd()
assert not wideWf.negative_cycle
assert wideWf.d[0][2] == int(7_000_000_000)
assert wideWf.d[0][9] == int(12_000_000_000)
assert wideWf.d[9][0] == INF64

# A complete graph selects the branch-free dense int64 kernel.  Potentials
# make some edges negative while every cycle remains positive.
var dense64 = initWeightedDirectedGraph(9)
for i in 0..<9:
    for j in 0..<9:
        if i != j:
            dense64.add_edge(i, j, 10 + 3 * j - 3 * i)
let denseWf64 = dense64.warshall_floyd()
assert not denseWf64.negative_cycle
for i in 0..<9:
    for j in 0..<9:
        let expected = if i == j: 0 else: 10 + 3 * j - 3 * i
        assert denseWf64.d[i][j] == expected

# Cross the dense 256-vertex tile boundary.  Reduced costs are either one on
# the directed ring or 100 otherwise; vertex potentials also create negative
# edges without creating a negative cycle.
const denseBlockedN = 257
var denseBlocked = initWeightedDirectedGraph(denseBlockedN)
for i in 0..<denseBlockedN:
    let pi = 3 * (i mod 17)
    for j in 0..<denseBlockedN:
        if i != j:
            let pj = 3 * (j mod 17)
            let reduced = if j == (i + 1) mod denseBlockedN: 1 else: 100
            denseBlocked.add_edge(i, j, reduced + pj - pi)
let denseBlockedWf = denseBlocked.warshall_floyd()
assert not denseBlockedWf.negative_cycle
for i in 0..<denseBlockedN:
    for j in 0..<denseBlockedN:
        let ringDistance = (j - i + denseBlockedN) mod denseBlockedN
        let reduced = if i == j: 0 else: min(ringDistance, 100)
        let expected = reduced + 3 * (j mod 17) - 3 * (i mod 17)
        assert denseBlockedWf.d[i][j] == expected

let empty = initWeightedDirectedGraph(0).warshall_floyd()
assert not empty.negative_cycle
assert empty.d.len == 0

# Cross a cache-block boundary in every phase of the blocked algorithm.
var blocked = initWeightedDirectedGraph(217)
for i in 0..<216:
    blocked.add_edge(i, i + 1, 1)
let blockedWf = blocked.warshall_floyd()
assert not blockedWf.negative_cycle
assert blockedWf.d[0][216] == 216
assert blockedWf.d[216][0] == INF64

# int32 uses eight AVX2 lanes and a separately tuned cache block.
var g32 = initWeightedDirectedGraph(11, int32)
g32.add_edge(0, 1, 300_000_000.int32)
g32.add_edge(1, 2, 400_000_000.int32)
g32.add_edge(2, 10, 50_000_000.int32)
g32.add_edge(0, 10, 900_000_000.int32)
let wf32 = g32.warshall_floyd()
assert not wf32.negative_cycle
assert wf32.d[0][2] == 700_000_000.int32
assert wf32.d[0][10] == 750_000_000.int32
assert wf32.d[10][0] == INF32

var parallel32 = initWeightedDirectedGraph(2, int32)
parallel32.add_edge(0, 1, 3.int32)
parallel32.add_edge(0, 1, 7.int32)
parallel32.add_edge(0, 0, 5.int32)
let parallelWf32 = parallel32.warshall_floyd()
assert not parallelWf32.negative_cycle
assert parallelWf32.d[0][0] == 0.int32
assert parallelWf32.d[0][1] == 3.int32

let empty32 = initWeightedDirectedGraph(0, int32).warshall_floyd()
assert not empty32.negative_cycle
assert empty32.d.len == 0

var blocked32 = initWeightedDirectedGraph(257, int32)
for i in 0..<256:
    blocked32.add_edge(i, i + 1, 1.int32)
let blockedWf32 = blocked32.warshall_floyd()
assert not blockedWf32.negative_cycle
assert blockedWf32.d[0][256] == 256.int32
assert blockedWf32.d[256][0] == INF32

var static32 = initWeightedDirectedStaticGraph(4, int32)
static32.add_edge(0, 1, 2.int32)
static32.add_edge(1, 2, 3.int32)
static32.add_edge(2, 3, 4.int32)
static32.add_edge(0, 3, 20.int32)
static32.build()
let staticWf32 = static32.warshall_floyd()
assert not staticWf32.negative_cycle
assert staticWf32.d[0][3] == 9.int32

var ng = initWeightedDirectedGraph(2)
ng.add_edge(0, 1, -2)
ng.add_edge(1, 0, -2)
assert ng.warshall_floyd().negative_cycle

import random, sequtils

proc checkRandom[T](n: int, dense: bool, inf: T) =
    var graph = initWeightedDirectedGraph(n, T)
    var expected = newSeqWith(n, newSeqWith(n, inf))
    for i in 0..<n:
        expected[i][i] = T(0)
        for j in 0..<n:
            if i != j and (dense or rand(9) == 0):
                let cost = T(rand(1..100) + 3 * (j mod 17) - 3 * (i mod 17))
                graph.add_edge(i, j, cost)
                expected[i][j] = cost
    for k in 0..<n:
        for i in 0..<n:
            for j in 0..<n:
                if expected[i][k] != inf and expected[k][j] != inf:
                    expected[i][j] = min(expected[i][j], expected[i][k] + expected[k][j])
    let actual = graph.warshall_floyd(T(0), inf)
    doAssert not actual.negative_cycle
    doAssert actual.d == expected

randomize(512)
for n in [1, 7, 8, 9, 15, 16, 17, 215, 216, 217, 255, 256, 257]:
    for dense in [false, true]:
        checkRandom[int](n, dense, INF64)
        checkRandom[int32](n, dense, INF32)

for n in [17, 257]:
    var negative32 = initWeightedDirectedGraph(n, int32)
    var negative64 = initWeightedDirectedGraph(n)
    for i in 0..<n:
        let cost = if i == n - 1: -n else: 1
        negative32.add_edge(i, (i + 1) mod n, cost.int32)
        negative64.add_edge(i, (i + 1) mod n, cost)
    doAssert negative32.warshall_floyd().negative_cycle
    doAssert negative64.warshall_floyd().negative_cycle


block:
    proc checkMatrix[T](zero, inf: T) =
        let a = @[@[inf, T(2), T(10)], @[inf, T(5), T(3)], @[inf, inf, zero]]
        let expected = @[@[zero, T(2), T(5)], @[inf, zero, T(3)], @[inf, inf, zero]]
        let actual = a.warshall_floyd(zero, inf)
        doAssert not actual.negative_cycle
        doAssert actual.d == expected
        doAssert a == @[@[inf, T(2), T(10)], @[inf, T(5), T(3)], @[inf, inf, zero]]
        doAssert not newSeq[seq[T]]().warshall_floyd(zero, inf).negative_cycle
        doAssert newSeq[seq[T]]().warshall_floyd(zero, inf).d.len == 0
        doAssert @[@[T(-1)]].warshall_floyd(zero, inf).negative_cycle
        doAssert @[@[zero, T(-2)], @[T(1), zero]].warshall_floyd(zero, inf).negative_cycle
        let unreachable = @[@[zero, inf, inf], @[inf, zero, T(-2)], @[inf, inf, zero]]
        doAssert unreachable.warshall_floyd(zero, inf).d == unreachable

    checkMatrix[int](0, 1_000_000)
    checkMatrix[int32](0.int32, 1_000_000.int32)
    checkMatrix[float](0.0, 1e100)
    checkMatrix[float32](0.0'f32, 1e30'f32)
    checkMatrix[int16](0.int16, 10_000.int16)
    doAssert @[@[0, 2], @[3, 0]].warshall_floyd().d[0][1] == 2
    doAssert @[@[0.int32]].warshall_floyd().d == @[@[0.int32]]
    doAssert @[@[0.0]].warshall_floyd().d == @[@[0.0]]
    doAssert @[@[0.0'f32]].warshall_floyd().d == @[@[0.0'f32]]

    for n in [17, 217, 257]:
        var a = newSeq[seq[int]](n)
        var a32 = newSeq[seq[int32]](n)
        for i in 0..<n:
            a[i] = newSeq[int](n)
            a32[i] = newSeq[int32](n)
            for j in 0..<n:
                a[i][j] = 1_000_000
                a32[i][j] = 1_000_000.int32
            if i + 1 < n:
                a[i][i + 1] = 1
                a32[i][i + 1] = 1.int32
        let actual = a.warshall_floyd(0, 1_000_000)
        let actual32 = a32.warshall_floyd(0.int32, 1_000_000.int32)
        doAssert not actual.negative_cycle
        doAssert not actual32.negative_cycle
        for i in 0..<n:
            for j in 0..<n:
                let expected = if i <= j: j - i else: 1_000_000
                doAssert actual.d[i][j] == expected
                doAssert actual32.d[i][j] == expected.int32
        doAssert a[0][n - 1] == 1_000_000
        doAssert a32[0][n - 1] == 1_000_000.int32


block:
    proc checkNonnegative[T](n: int, dense: bool, zero, inf, unit: T) =
        var a = newSeq[seq[T]](n)
        var graph = initWeightedDirectedGraph(n, T)
        for i in 0..<n:
            a[i] = newSeq[T](n)
            for j in 0..<n:
                a[i][j] = inf
            a[i][i] = zero
            for j in 0..<n:
                if i != j and (dense or j == i + 1 or (i * 17 + j * 31) mod 29 == 0):
                    let cost = T((i * 7 + j * 11) mod 13) * unit
                    a[i][j] = cost
                    graph.add_edge(i, j, cost)
        let expected = a.warshall_floyd(zero, inf)
        doAssert not expected.negative_cycle
        let fromMatrix: seq[seq[T]] = a.warshall_floyd_nonnegative(zero, inf)
        let fromGraph: seq[seq[T]] = graph.warshall_floyd_nonnegative(zero, inf)
        doAssert fromMatrix == expected.d
        doAssert fromGraph == expected.d
        var checkedInplace = a
        var uncheckedInplace = a
        let checkedRow = if n == 0: nil else: addr checkedInplace[0][0]
        let uncheckedRow = if n == 0: nil else: addr uncheckedInplace[0][0]
        doAssert not checkedInplace.warshall_floyd_inplace(zero, inf)
        uncheckedInplace.warshall_floyd_nonnegative_inplace(zero, inf)
        doAssert checkedInplace == expected.d
        doAssert uncheckedInplace == expected.d
        if n > 0:
            doAssert addr(checkedInplace[0][0]) == checkedRow
            doAssert addr(uncheckedInplace[0][0]) == uncheckedRow
        for i in 0..<n:
            for j in 0..<n:
                let original = if i == j: zero
                    elif dense or j == i + 1 or (i * 17 + j * 31) mod 29 == 0:
                        T((i * 7 + j * 11) mod 13) * unit
                    else: inf
                doAssert a[i][j] == original

    for n in [0, 1, 7, 8, 9, 15, 16, 17, 217, 257]:
        for dense in [false, true]:
            checkNonnegative[int](n, dense, 0, int.high div 4, int(3_000_000_000))
            checkNonnegative[int32](n, dense, 0.int32, 1_000_000.int32, 1.int32)
    checkNonnegative[float](17, false, 0.0, 1e100, 0.5)
    checkNonnegative[float32](17, true, 0.0'f32, 1e30'f32, 0.5'f32)
    checkNonnegative[int16](17, false, 0.int16, 10_000.int16, 1.int16)

    doAssert @[@[5, 2], @[100, 100]].warshall_floyd_nonnegative(inf = 100) == @[@[0, 2], @[100, 0]]
    doAssert @[@[0.int32]].warshall_floyd_nonnegative() == @[@[0.int32]]
    doAssert @[@[0.0]].warshall_floyd_nonnegative() == @[@[0.0]]
    doAssert @[@[0.0'f32]].warshall_floyd_nonnegative() == @[@[0.0'f32]]
    var parallel = initWeightedDirectedGraph(2)
    parallel.add_edge(0, 1, 0)
    parallel.add_edge(0, 1, 5)
    parallel.add_edge(0, 0, 3)
    doAssert parallel.warshall_floyd_nonnegative(inf = 100) == @[@[0, 0], @[100, 0]]
    var unweighted = initUnWeightedDirectedGraph(3)
    unweighted.add_edge(0, 1)
    unweighted.add_edge(1, 2)
    doAssert unweighted.warshall_floyd_nonnegative()[0][2] == 2
    var staticGraph = initWeightedDirectedStaticGraph(3, int32)
    staticGraph.add_edge(0, 1, 2.int32)
    staticGraph.add_edge(1, 2, 3.int32)
    staticGraph.build()
    doAssert staticGraph.warshall_floyd_nonnegative()[0][2] == 5.int32


block:
    proc checkInplace[T](zero, inf: T) =
        var d = @[@[inf, T(-2), T(10)], @[inf, T(5), T(3)], @[inf, inf, zero]]
        let expected = @[@[zero, T(-2), T(1)], @[inf, zero, T(3)], @[inf, inf, zero]]
        var unchecked = d
        doAssert not d.warshall_floyd_inplace(zero, inf)
        unchecked.warshall_floyd_nonnegative_inplace(zero, inf)
        doAssert d == expected
        doAssert unchecked == expected
        var negativeLoop = @[@[T(-1)]]
        doAssert negativeLoop.warshall_floyd_inplace(zero, inf)
        doAssert negativeLoop[0][0] < zero
        var negativeCycle = @[@[zero, T(-2)], @[T(1), zero]]
        doAssert negativeCycle.warshall_floyd_inplace(zero, inf)
        doAssert negativeCycle[0][0] < zero or negativeCycle[1][1] < zero

    checkInplace[int](0, 1_000_000)
    checkInplace[int32](0.int32, 1_000_000.int32)
    checkInplace[float](0.0, 1e100)
    checkInplace[float32](0.0'f32, 1e30'f32)
    checkInplace[int16](0.int16, 10_000.int16)
    var d = @[@[10, 2], @[100, 100]]
    doAssert not d.warshall_floyd_inplace(inf = 100)
    doAssert d == @[@[0, 2], @[100, 0]]
    d.warshall_floyd_nonnegative_inplace(inf = 100)
    doAssert d == @[@[0, 2], @[100, 0]]
    var d32 = @[@[0.int32]]
    var df = @[@[0.0]]
    var df32 = @[@[0.0'f32]]
    doAssert not d32.warshall_floyd_inplace()
    doAssert not df.warshall_floyd_inplace()
    doAssert not df32.warshall_floyd_inplace()
    d32.warshall_floyd_nonnegative_inplace()
    df.warshall_floyd_nonnegative_inplace()
    df32.warshall_floyd_nonnegative_inplace()
