# verification-helper: PROBLEM https://judge.yosupo.jp/problem/staticrmq
import options
import cplib/collections/three_sided_range_tree

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var n, q = ii()
let points = initThreeSidedRangeTree[int, int]()
for i in 0..<n:
    discard points.add(i, ii())
for _ in 0..<q:
    var l, r = ii()
    stdout.writeLine(points.findBelow(l, r, 1_000_000_000).get.y)
