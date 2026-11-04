# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, math, random
import cplib/collections/kd_tree
import cplib/geometry/base

proc oracleRange[K: static[int]; T: SomeNumber](points: openArray[array[K, T]], lower, upper: array[K, T]): seq[int] =
    for i in 0..<points.len:
        var inside = true
        for axis in 0..<K:
            if points[i][axis] < lower[axis] or upper[axis] < points[i][axis]: inside = false
        if inside: result.add(i)

proc oracleNearest[K: static[int]; T: SomeNumber](points: openArray[array[K, T]], query: array[K, T]): int =
    result = -1
    var best = system.Inf
    for i in 0..<points.len:
        var distance = 0.0
        for axis in 0..<K:
            let difference = float64(points[i][axis]) - float64(query[axis])
            distance += difference * difference
        if distance < best:
            best = distance
            result = i

proc check[K: static[int]; T: SomeNumber](points: seq[array[K, T]], lower, upper, query: array[K, T]) =
    let saved = points
    let tree = initKDTree(points)
    doAssert points == saved
    doAssert tree.len == points.len
    var found = tree.rangeSearch(lower, upper)
    found.sort()
    let expected = oracleRange[K, T](points, lower, upper)
    doAssert found == expected
    doAssert tree.rangeCount(lower, upper) == expected.len
    doAssert tree.nearestNeighbor(query) == oracleNearest[K, T](points, query)

proc randomized[K: static[int]; T: SomeNumber](seed: int, unsigned = false) =
    var rng = initRand(seed)
    for trial in 0..<180:
        var points = newSeq[array[K, T]](rng.rand(0..90))
        for p in points.mitems:
            for x in p.mitems:
                x = T(rng.rand(0..8) - (if unsigned: 0 else: 4))
        let saved = points
        let tree = initKDTree(points)
        doAssert points == saved
        for iteration in 0..<25:
            var lower, upper, query: array[K, T]
            for axis in 0..<K:
                lower[axis] = T(rng.rand(0..8) - (if unsigned: 0 else: 4))
                upper[axis] = T(rng.rand(0..8) - (if unsigned: 0 else: 4))
                query[axis] = T(rng.rand(0..8) - (if unsigned: 0 else: 4))
                if iteration mod 3 != 0 and upper[axis] < lower[axis]: swap(lower[axis], upper[axis])
            var found = tree.rangeSearch(lower, upper)
            found.sort()
            let expected = oracleRange[K, T](points, lower, upper)
            doAssert found == expected
            doAssert tree.rangeCount(lower, upper) == expected.len
            doAssert tree.nearestNeighbor(query) == oracleNearest[K, T](points, query)

randomized[1, int](10)
randomized[2, int64](20)
randomized[3, int32](30)
randomized[5, int16](50)
randomized[2, uint8](21, true)
randomized[8, uint64](80, true)
randomized[2, float32](22)
randomized[3, float64](33)

block:
    let empty = initKDTree(newSeq[array[3, int]]())
    doAssert empty.len == 0
    doAssert empty.nearestNeighbor([0, 0, 0]) == -1
    doAssert empty.rangeSearch([0, 0, 0], [0, 0, 0]).len == 0
    doAssert empty.rangeCount([0, 0, 0], [0, 0, 0]) == 0
    let uninitialized = default(KDTree[2, int])
    doAssert uninitialized.nearestNeighbor([1, 2]) == -1

check(@[[3, -2]], [3, -2], [3, -2], [0, 0])
check(@[[0, 0], [0, 0], [0, 0]], [0, 0], [0, 0], [0, 0])
check(@[[4, 0], [-4, 0], [0, 4], [0, -4], [-4, 0]], [-4, -4], [4, 4], [0, 0])
check(@[[9, 0], [2, 0], [2, 0], [-8, 0], [0, 0]], [0, 0], [2, 0], [1, 0])

block:
    var points: seq[array[2, int]]
    for x in -8..8:
        for y in -8..8: points.add([x, y])
    check(points, [-4, -2], [4, 2], [2, -1])
    check(points, [0, 0], [0, 0], [2, -1])
    check(points, [1, 1], [-1, -1], [2, -1])

block:
    var points = @[[7, 3], [-1, 2], [7, 3], [0, 0]]
    let tree = initKDTree(points)
    points[0] = [100, 100]
    points.setLen(0)
    doAssert tree.len == 4
    doAssert tree.nearestNeighbor([7, 3]) == 0
    doAssert tree.rangeCount([7, 3], [7, 3]) == 2
    let copied = tree
    doAssert copied.nearestNeighbor([7, 3]) == 0

block:
    let points = [initPoint(3'i64, 2'i64), initPoint(-1'i64, 5'i64), initPoint(3'i64, 2'i64)]
    let tree = initKDTree(points)
    doAssert tree.len == 3
    doAssert tree.nearestNeighbor(initPoint(3'i64, 2'i64)) == 0
    var found = tree.rangeSearch(initPoint(3'i64, 2'i64), initPoint(3'i64, 2'i64))
    found.sort()
    doAssert found == @[0, 2]
    doAssert tree.rangeCount(initPoint(-1'i64, 2'i64), initPoint(3'i64, 5'i64)) == 3
    let empty = initKDTree(newSeq[Point[float64]]())
    doAssert empty.nearestNeighbor(initPoint(0.0, 0.0)) == -1

block:
    let lo = low(int64)
    let hi = high(int64)
    let tree = initKDTree(@[[lo, hi], [hi, lo], [0'i64, 0'i64], [lo, hi]])
    doAssert tree.rangeCount([lo, lo], [hi, hi]) == 4
    doAssert tree.rangeCount([lo, hi], [lo, hi]) == 2
    doAssert tree.rangeSearch([hi, lo], [hi, lo]) == @[1]
    # 最近傍の距離計算は型の範囲に収まる入力だけを対象にします。
    let nearHi = initKDTree(@[[hi - 2], [hi - 4], [hi]])
    doAssert nearHi.nearestNeighbor([hi - 3]) == 0
    let nearLo = initKDTree(@[[lo + 2], [lo + 4], [lo]])
    doAssert nearLo.nearestNeighbor([lo + 3]) == 0
    let maxSquare = initKDTree(@[[3037000499'i64], [3037000498'i64]])
    doAssert maxSquare.nearestNeighbor([0'i64]) == 1
    let unsigned = initKDTree(@[[high(uint64) - 4], [high(uint64) - 2]])
    doAssert unsigned.nearestNeighbor([high(uint64) - 3]) == 0

block:
    let tiny = initKDTree(@[[0.0, -0.0], [1e-150, 0.0], [-1e-150, 0.0]])
    doAssert tiny.nearestNeighbor([0.0, 0.0]) == 0
    doAssert tiny.nearestNeighbor([1e-150, 0.0]) == 1
    doAssert tiny.rangeCount([0.0, 0.0], [0.0, 0.0]) == 1
    let large = initKDTree(@[[1e150], [-1e150]])
    doAssert large.nearestNeighbor([0.0]) == 0
    check(@[[0.5, 1.25], [0.5, 1.5], [0.5, 1.25]], [0.5, 1.25], [0.5, 1.25], [0.5, 1.375])
    let underflow = initKDTree(@[[1e-200], [0.0]])
    doAssert underflow.nearestNeighbor([0.0]) == 0
    let fullFloatRange = initKDTree(@[[-1e308], [1e308]])
    doAssert fullFloatRange.rangeCount([-1e308], [1e308]) == 2

block:
    let empty = initKDTree(newSeq[array[2, float64]]())
    let tree = initKDTree(@[[0.0, 0.0]])
    for bad in [NaN, system.Inf, NegInf]:
        var rejected = false
        try: discard initKDTree(@[[bad, 0.0]])
        except ValueError: rejected = true
        doAssert rejected
        for t in [empty, tree]:
            rejected = false
            try: discard t.nearestNeighbor([bad, 0.0])
            except ValueError: rejected = true
            doAssert rejected
            rejected = false
            try: discard t.rangeCount([0.0, bad], [0.0, 0.0])
            except ValueError: rejected = true
            doAssert rejected
            rejected = false
            try: discard t.rangeSearch([0.0, 0.0], [bad, 0.0])
            except ValueError: rejected = true
            doAssert rejected

block:
    for bad in [float32(NaN), float32(system.Inf), float32(NegInf)]:
        var rejected = false
        try: discard initKDTree(@[[bad]])
        except ValueError: rejected = true
        doAssert rejected
        let tree = initKDTree(@[[0'f32]])
        rejected = false
        try: discard tree.nearestNeighbor([bad])
        except ValueError: rejected = true
        doAssert rejected

echo "Hello World"
