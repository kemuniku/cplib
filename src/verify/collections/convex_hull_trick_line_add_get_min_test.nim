# verification-helper: PROBLEM https://judge.yosupo.jp/problem/line_add_get_min
import cplib/collections/convex_hull_trick

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int = scanf("%lld", addr result)

let n = ii()
let q = ii()
var hull = initConvexHullTrick()
for i in 0..<n:
    let a = ii()
    let b = ii()
    hull.add_line(a, b)
for i in 0..<q:
    let t = ii()
    if t == 0:
        let a = ii()
        let b = ii()
        hull.add_line(a, b)
    else:
        echo hull.get_min(ii())
