# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"
import sequtils, random
import cplib/graph/graph
when defined(testAvx512):
    import cplib/graph/warshall_floyd_avx512
elif defined(testAvx):
    import cplib/graph/warshall_floyd_avx
else:
    import cplib/graph/warshall_floyd

proc reference(a: seq[seq[int]], inf: int): seq[seq[int]] =
    let n = a.len
    result = newSeqWith(n, newSeqWith(n, inf))
    for source in 0..<n:
        var dist = newSeqWith(n, inf)
        dist[source] = 0
        var affected = newSeq[bool](n)
        for step in 0..<n:
            var next = dist
            for i in 0..<n:
                if dist[i] == inf: continue
                for j in 0..<n:
                    if a[i][j] != inf and dist[i] + a[i][j] < next[j]:
                        next[j] = dist[i] + a[i][j]
                        if step == n - 1: affected[j] = true
            dist = next
        for step in 0..<n:
            for i in 0..<n:
                if affected[i]:
                    for j in 0..<n:
                        if a[i][j] != inf: affected[j] = true
        for j in 0..<n:
            result[source][j] = if affected[j]: -inf else: dist[j]

proc check[T](a: seq[seq[int]], expected: seq[seq[int]]) =
    let inf = T(1000000)
    var matrix = newSeqWith(a.len, newSeq[T](a.len))
    var answer = newSeqWith(a.len, newSeq[T](a.len))
    var graph = initWeightedDirectedGraph(a.len, T)
    var staticGraph = initWeightedDirectedStaticGraph(a.len, T)
    for i in 0..<a.len:
        for j in 0..<a.len:
            matrix[i][j] = T(a[i][j])
            answer[i][j] = T(expected[i][j])
            if a[i][j] != 1000000:
                graph.add_edge(i, j, T(a[i][j]))
                staticGraph.add_edge(i, j, T(a[i][j]))
    let saved = matrix
    let actual: seq[seq[T]] = matrix.warshall_floyd(T(0), inf)
    doAssert actual == answer
    doAssert matrix == saved
    doAssert graph.warshall_floyd(T(0), inf) == answer
    staticGraph.build()
    doAssert staticGraph.warshall_floyd(T(0), inf) == answer
    matrix.warshall_floyd_inplace(T(0), inf)
    doAssert matrix == answer

let inf = 1000000
var rng = initRand(719)
for n in 0..12:
    for trial in 0..<20:
        var a = newSeqWith(n, newSeqWith(n, inf))
        for i in 0..<n:
            a[i][i] = 0
            for j in 0..<n:
                if rng.rand(99) < 25: a[i][j] = rng.rand(-8..12)
        let expected = reference(a, inf)
        check[int](a, expected)
        check[int32](a, expected)
        check[float](a, expected)
        check[float32](a, expected)

for n in [65, 257, 513]:
    var a = newSeqWith(n, newSeqWith(n, inf))
    for i in 0..<n: a[i][i] = 0
    a[0][1] = 2
    a[1][2] = -3
    a[2][1] = 1
    a[2][3] = 5
    a[0][4] = 7
    a[5][4] = -2
    a[4][6] = 3
    a[n-2][n-1] = -4
    a[n-1][n-2] = 1
    var expected = a
    expected[0][6] = 10
    expected[5][6] = 1
    for i in [0, 1, 2]:
        for j in [1, 2, 3]: expected[i][j] = -inf
    for i in [n-2, n-1]:
        for j in [n-2, n-1]: expected[i][j] = -inf
    check[int](a, expected)
    check[int32](a, expected)
