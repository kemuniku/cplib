# verification-helper: PROBLEM https://judge.yosupo.jp/problem/closest_pair
import options
import cplib/geometry/base
import cplib/geometry/closest_pair
include cplib/tmpl/fastio

let t = ii()
for _ in 0..<t:
    let n = ii()
    var points = newSeq[Point[int64]](n)
    for i in 0..<n:
        points[i] = initPoint(int64(ii()), int64(ii()))
    let (u, v) = closest_pair(points).get.indices
    echo u, " ", v
