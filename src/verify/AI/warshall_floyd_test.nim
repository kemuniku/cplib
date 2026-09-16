# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
proc hasNegativeCycle[T](a: seq[seq[T]]): bool =
    for i in 0..<a.len:
        if a[i][i] < T(0): return true

echo "Hello World"



import cplib/graph/graph
import cplib/graph/warshall_floyd

var g = initWeightedDirectedGraph(3)
g.add_edge(0, 1, 2)
g.add_edge(1, 2, 3)
g.add_edge(0, 2, 10)
let wf = g.warshall_floyd()
assert not wf.hasNegativeCycle()
assert wf[0][2] == 5

var ng = initWeightedDirectedGraph(2)
ng.add_edge(0, 1, -2)
ng.add_edge(1, 0, -2)
assert ng.warshall_floyd().hasNegativeCycle()


block:
    proc checkMatrix[T](zero, inf: T) =
        let a = @[@[inf, T(2), T(10)], @[inf, T(5), T(3)], @[inf, inf, zero]]
        let expected = @[@[zero, T(2), T(5)], @[inf, zero, T(3)], @[inf, inf, zero]]
        let actual = a.warshall_floyd(zero, inf)
        doAssert not actual.hasNegativeCycle()
        doAssert actual == expected
        doAssert a == @[@[inf, T(2), T(10)], @[inf, T(5), T(3)], @[inf, inf, zero]]
        doAssert not newSeq[seq[T]]().warshall_floyd(zero, inf).hasNegativeCycle()
        doAssert newSeq[seq[T]]().warshall_floyd(zero, inf).len == 0
        doAssert @[@[T(-1)]].warshall_floyd(zero, inf).hasNegativeCycle()
        doAssert @[@[zero, T(-2)], @[T(1), zero]].warshall_floyd(zero, inf).hasNegativeCycle()
        let unreachable = @[@[zero, inf, inf], @[inf, zero, T(-2)], @[inf, inf, zero]]
        doAssert unreachable.warshall_floyd(zero, inf) == unreachable

    checkMatrix[int](0, 1_000_000)
    checkMatrix[int32](0.int32, 1_000_000.int32)
    checkMatrix[float](0.0, 1e100)
    checkMatrix[float32](0.0'f32, 1e30'f32)
    checkMatrix[int16](0.int16, 10_000.int16)
    doAssert @[@[0, 2], @[3, 0]].warshall_floyd()[0][1] == 2
    doAssert @[@[0.int32]].warshall_floyd() == @[@[0.int32]]
    doAssert @[@[0.0]].warshall_floyd() == @[@[0.0]]
    doAssert @[@[0.0'f32]].warshall_floyd() == @[@[0.0'f32]]

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
        doAssert not actual.hasNegativeCycle()
        doAssert not actual32.hasNegativeCycle()
        for i in 0..<n:
            for j in 0..<n:
                let expected = if i <= j: j - i else: 1_000_000
                doAssert actual[i][j] == expected
                doAssert actual32[i][j] == expected.int32
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
        doAssert not expected.hasNegativeCycle()
        let fromMatrix: seq[seq[T]] = a.warshall_floyd_nonnegative(zero, inf)
        let fromGraph: seq[seq[T]] = graph.warshall_floyd_nonnegative(zero, inf)
        doAssert fromMatrix == expected
        doAssert fromGraph == expected
        var checkedInplace = a
        var uncheckedInplace = a
        let checkedRow = if n == 0: nil else: addr checkedInplace[0][0]
        let uncheckedRow = if n == 0: nil else: addr uncheckedInplace[0][0]
        checkedInplace.warshall_floyd_inplace(zero, inf)
        doAssert not checkedInplace.hasNegativeCycle()
        uncheckedInplace.warshall_floyd_nonnegative_inplace(zero, inf)
        doAssert checkedInplace == expected
        doAssert uncheckedInplace == expected
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
        d.warshall_floyd_inplace(zero, inf)
        doAssert not d.hasNegativeCycle()
        unchecked.warshall_floyd_nonnegative_inplace(zero, inf)
        doAssert d == expected
        doAssert unchecked == expected
        var negativeLoop = @[@[T(-1)]]
        negativeLoop.warshall_floyd_inplace(zero, inf)
        doAssert negativeLoop.hasNegativeCycle()
        doAssert negativeLoop[0][0] < zero
        var negativeCycle = @[@[zero, T(-2)], @[T(1), zero]]
        negativeCycle.warshall_floyd_inplace(zero, inf)
        doAssert negativeCycle.hasNegativeCycle()
        doAssert negativeCycle[0][0] < zero or negativeCycle[1][1] < zero

    checkInplace[int](0, 1_000_000)
    checkInplace[int32](0.int32, 1_000_000.int32)
    checkInplace[float](0.0, 1e100)
    checkInplace[float32](0.0'f32, 1e30'f32)
    checkInplace[int16](0.int16, 10_000.int16)
    var d = @[@[10, 2], @[100, 100]]
    d.warshall_floyd_inplace(inf = 100)
    doAssert not d.hasNegativeCycle()
    doAssert d == @[@[0, 2], @[100, 0]]
    d.warshall_floyd_nonnegative_inplace(inf = 100)
    doAssert d == @[@[0, 2], @[100, 0]]
    var d32 = @[@[0.int32]]
    var df = @[@[0.0]]
    var df32 = @[@[0.0'f32]]
    d32.warshall_floyd_inplace()
    doAssert not d32.hasNegativeCycle()
    df.warshall_floyd_inplace()
    doAssert not df.hasNegativeCycle()
    df32.warshall_floyd_inplace()
    doAssert not df32.hasNegativeCycle()
    d32.warshall_floyd_nonnegative_inplace()
    df.warshall_floyd_nonnegative_inplace()
    df32.warshall_floyd_nonnegative_inplace()
