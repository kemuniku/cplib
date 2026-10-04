# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random
import cplib/collections/kd_tree

const N = 100000
var rng = initRand(20261004)
for shape in 0..<5:
    var points = newSeq[array[2, int64]](N)
    for i in 0..<N:
        case shape
        of 0: points[i] = [int64(i), int64(i)]
        of 1: points[i] = [int64(N - i), 0'i64]
        of 2: points[i] = [7'i64, 7'i64]
        of 3: points[i] = [int64(i mod 400), int64(i div 400)]
        else: points[i] = [int64(i), int64(i mod 3) * 1000000000'i64]
    let saved = points
    let tree = initKDTree(points)
    doAssert tree.len == N and saved == points
    doAssert tree.rangeCount([low(int64), low(int64)], [high(int64), high(int64)]) == N
    doAssert tree.rangeCount([high(int64), high(int64)], [high(int64), high(int64)]) == 0
    for queryNumber in 0..<12:
        let query = [int64(rng.rand(-N..N)), int64(rng.rand(-N..N))]
        let lower = [query[0] - 100, query[1] - 200]
        let upper = [query[0] + 100, query[1] + 200]
        var expected: seq[int]
        var best = -1
        var bestDistance = high(int64)
        for i, p in points:
            if lower[0] <= p[0] and p[0] <= upper[0] and lower[1] <= p[1] and p[1] <= upper[1]:
                expected.add(i)
            let dx = p[0] - query[0]
            let dy = p[1] - query[1]
            let distance = dx * dx + dy * dy
            if distance < bestDistance:
                best = i
                bestDistance = distance
        var found = tree.rangeSearch(lower, upper)
        found.sort()
        doAssert found == expected
        doAssert tree.rangeCount(lower, upper) == expected.len
        doAssert tree.nearestNeighbor(query) == best
    if shape == 2:
        doAssert tree.nearestNeighbor([7'i64, 7'i64]) == 0
        var all = tree.rangeSearch([7'i64, 7'i64], [7'i64, 7'i64])
        all.sort()
        doAssert all.len == N
        for i, index in all: doAssert index == i
echo "Hello World"
