# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import bitops, random
import cplib/graph/matroid_intersection
import cplib/collections/unionfind

type Edge = tuple[u, v: int]

proc maskOf(items: openArray[int], n: int): int =
    for e in items:
        doAssert e in 0..<n
        doAssert (result and (1 shl e)) == 0
        result = result or (1 shl e)

proc partitionTable(colors, limits: seq[int]): seq[bool] =
    result = newSeq[bool](1 shl colors.len)
    for mask in 0..<result.len:
        result[mask] = true
        for color, limit in limits:
            var count = 0
            for e, c in colors:
                if c == color and (mask and (1 shl e)) != 0: inc count
            if count > limit: result[mask] = false

proc graphicTable(vertices: int, edges: seq[Edge]): seq[bool] =
    result = newSeq[bool](1 shl edges.len)
    for mask in 0..<result.len:
        var component = newSeq[int](vertices)
        for v in 0..<vertices: component[v] = v
        result[mask] = true
        for e, edge in edges:
            if (mask and (1 shl e)) == 0: continue
            let a = component[edge.u]
            let b = component[edge.v]
            if a == b:
                result[mask] = false
                break
            for v in 0..<vertices:
                if component[v] == b: component[v] = a

proc linearTable(vectors: seq[int]): seq[bool] =
    result = newSeq[bool](1 shl vectors.len)
    for mask in 0..<result.len:
        result[mask] = true
        var subset = mask
        while subset != 0:
            var total = 0
            for e, vector in vectors:
                if (subset and (1 shl e)) != 0: total = total xor vector
            if total == 0:
                result[mask] = false
                break
            subset = (subset - 1) and mask

proc tableOracle(table: seq[bool], n: int): IndependenceOracle =
    result = proc(items: openArray[int]): bool = table[maskOf(items, n)]

proc optimum(a, b: seq[bool]): int =
    for mask in 0..<a.len:
        if a[mask] and b[mask]: result = max(result, countSetBits(mask))

proc validate(n: int, a, b: seq[bool], answer: seq[int]): int =
    let mask = maskOf(answer, n)
    doAssert a[mask] and b[mask]
    for i in 1..<answer.len: doAssert answer[i - 1] < answer[i]
    result = optimum(a, b)
    doAssert answer.len == result

proc check(n: int, a, b: seq[bool]) =
    var calls = 0
    let first: IndependenceOracle = proc(items: openArray[int]): bool =
        inc calls
        a[maskOf(items, n)]
    let second: IndependenceOracle = proc(items: openArray[int]): bool =
        inc calls
        b[maskOf(items, n)]
    let answer = matroidIntersection(n, first, second)
    let r = validate(n, a, b, answer)
    doAssert calls <= n * (r + 1) * (r + 2)
    discard validate(n, b, a, matroidIntersection(n, second, first))
    doAssert matroidIntersection(n, first, second) == answer

proc checkPartitionGraphic(vertices: int, edges: seq[Edge], colors, limits: seq[int]) =
    let n = edges.len
    let partition: IndependenceOracle = proc(items: openArray[int]): bool =
        var counts = newSeq[int](limits.len)
        for e in items:
            inc counts[colors[e]]
            if counts[colors[e]] > limits[colors[e]]: return false
        true
    let graphic: IndependenceOracle = proc(items: openArray[int]): bool =
        var uf = initUnionFind(vertices)
        for e in items:
            let (u, v) = edges[e]
            if uf.issame(u, v): return false
            uf.unite(u, v)
        true
    let a = partitionTable(colors, limits)
    let b = graphicTable(vertices, edges)
    check(n, a, b)
    discard validate(n, a, b, matroidIntersection(n, partition, graphic))
    discard validate(n, b, a, matroidIntersection(n, graphic, partition))

block:
    var calls = 0
    let never: IndependenceOracle = proc(items: openArray[int]): bool =
        inc calls
        false
    doAssert matroidIntersection(0, never, never).len == 0
    doAssert calls == 0
    var rejected = false
    try:
        discard matroidIntersection(-1, never, never)
    except ValueError:
        rejected = true
    doAssert rejected and calls == 0
    for n in 0..9:
        let free = partitionTable(newSeq[int](n), @[n])
        let zero = partitionTable(newSeq[int](n), @[0])
        check(n, free, free)
        check(n, free, zero)
        check(n, zero, zero)
    doAssert matroidIntersection(100000, never, never).len == 0
    doAssert calls == 100000
    let rank5: IndependenceOracle = proc(items: openArray[int]): bool = items.len <= 5
    let rank7: IndependenceOracle = proc(items: openArray[int]): bool = items.len <= 7
    doAssert matroidIntersection(2048, rank5, rank7) == @[0, 1, 2, 3, 4]
    doAssert matroidIntersection(2048, rank7, rank5) == @[0, 1, 2, 3, 4]

block:
    let a = partitionTable(@[0, 0, 1], @[1, 1])
    let b = partitionTable(@[0, 1, 0], @[1, 1])
    doAssert matroidIntersection(3, tableOracle(a, 3), tableOracle(b, 3)) == @[1, 2]
    check(3, a, b)
    let left = @[0, 1, 2, 0, 1, 3, 2]
    let right = @[0, 1, 2, 1, 2, 0, 3]
    let c = partitionTable(left, @[1, 1, 1, 1])
    let d = partitionTable(right, @[1, 1, 1, 1])
    doAssert matroidIntersection(7, tableOracle(c, 7), tableOracle(d, 7)) == @[3, 4, 5, 6]
    check(7, c, d)

block:
    checkPartitionGraphic(4, @[(0, 1), (1, 2), (0, 2), (2, 3)], @[0, 0, 1, 1], @[1, 1])
    checkPartitionGraphic(3, @[(0, 0), (0, 1), (0, 1), (1, 2), (2, 0), (2, 2)],
        @[0, 0, 1, 1, 2, 2], @[1, 1, 0])
    checkPartitionGraphic(0, @[], @[], @[])

block:
    for first in 0..<16:
        for second in 0..<16:
            var a, b = newSeq[int](4)
            for e in 0..<4:
                a[e] = (first shr e) and 1
                b[e] = (second shr e) and 1
            check(4, partitionTable(a, @[1, 1]), partitionTable(b, @[1, 1]))
    var tables: seq[seq[bool]]
    for encoding in 0..<64:
        var vectors = newSeq[int](3)
        for e in 0..<3: vectors[e] = (encoding shr (2 * e)) and 3
        tables.add(linearTable(vectors))
    for a in tables:
        for b in tables: check(3, a, b)

var rng = initRand(956)
for trial in 0..<180:
    let n = rng.rand(0..9)
    let vertices = rng.rand(1..5)
    var edges, otherEdges: seq[Edge]
    var colors, otherColors, vectors, otherVectors: seq[int]
    var limits, otherLimits = newSeq[int](4)
    for c in 0..<4:
        limits[c] = rng.rand(0..3)
        otherLimits[c] = rng.rand(0..3)
    for e in 0..<n:
        edges.add((rng.rand(vertices - 1), rng.rand(vertices - 1)))
        otherEdges.add((rng.rand(vertices - 1), rng.rand(vertices - 1)))
        colors.add(rng.rand(3))
        otherColors.add(rng.rand(3))
        vectors.add(rng.rand(15))
        otherVectors.add(rng.rand(15))
    let p = partitionTable(colors, limits)
    let g = graphicTable(vertices, edges)
    let l = linearTable(vectors)
    check(n, p, partitionTable(otherColors, otherLimits))
    check(n, g, graphicTable(vertices, otherEdges))
    check(n, l, linearTable(otherVectors))
    check(n, p, l)
    check(n, g, l)
    checkPartitionGraphic(vertices, edges, colors, limits)

echo "Hello World"
