# verification-helper: PROBLEM https://judge.yosupo.jp/problem/furthest_pair
include cplib/geometry/convex_polygon
import tables

proc scanf(formatstr: cstring): cint {.header: "<stdio.h>", varargs.}
proc ii(): int = discard scanf("%lld", addr result)
proc ll(): int64 = discard scanf("%lld", addr result)

let t = ii()
for _ in 0..<t:
    let n = ii()
    var firstIndex = initTable[Point[int64], int]()
    var unique: seq[Point[int64]]
    for i in 0..<n:
        let x = ll()
        let y = ll()
        let p = initPoint(x, y)
        if not firstIndex.hasKey(p):
            firstIndex[p] = i
            unique.add(p)
    let answer = initConvexPolygon(convex_hull(unique)).diameter.get
    let a = firstIndex[answer.endpoints[0]]
    var b = firstIndex[answer.endpoints[1]]
    # 全点同一でも直径APIの結果を使い、異なる入力indexへ戻す。
    if a == b: b = (a + 1) mod n
    echo a, " ", b
