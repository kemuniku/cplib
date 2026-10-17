# verification-helper: PROBLEM https://judge.yosupo.jp/problem/static_convex_hull
import cplib/geometry/base
import cplib/geometry/polygon

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int64 {.inline.} = scanf("%lld", addr result)

let t = int(ii())
for caseIndex in 0..<t:
    let n = int(ii())
    var points = newSeq[Point[int64]](n)
    for i in 0..<n:
        let x = ii()
        let y = ii()
        points[i] = initPoint(x, y)
    let answer = convex_hull(points, true)
    echo answer.len
    for p in answer:
        echo p.x, " ", p.y
