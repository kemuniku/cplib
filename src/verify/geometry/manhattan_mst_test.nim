# verification-helper: PROBLEM https://judge.yosupo.jp/problem/manhattanmst
import cplib/geometry/manhattan_mst
include cplib/tmpl/fastio

let n = ii()
var points = newSeq[(int64, int64)](n)
for i in 0..<n:
    points[i] = (int64(ii()), int64(ii()))
let edges = manhattan_mst(points)
var total = 0'i64
for (u, v) in edges:
    total += abs(points[u][0] - points[v][0]) + abs(points[u][1] - points[v][1])
echo total
for (u, v) in edges:
    echo u, " ", v
