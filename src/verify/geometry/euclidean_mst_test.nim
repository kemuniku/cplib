# verification-helper: PROBLEM https://judge.yosupo.jp/problem/euclidean_mst
import cplib/geometry/euclidean_mst
include cplib/tmpl/fastio

let n = ii()
var points = newSeq[(int, int)](n)
for i in 0..<n:
    points[i] = (ii(), ii())
for (u, v) in euclidean_mst(points):
    echo u, " ", v
