# verification-helper: PROBLEM https://judge.yosupo.jp/problem/sort_points_by_argument
import cplib/geometry/base
import cplib/geometry/argsort
include cplib/tmpl/fastio

let n = ii()
var points = newSeq[Point[int]](n)
for i in 0..<n:
    let x = ii()
    let y = ii()
    points[i] = initPoint(x, y)
argsort(points)

# LCは負のyの点から始め、零の角度を0、負のx軸の角度をpiとする。
var nonzero = n
while nonzero > 0 and points[nonzero - 1].x == 0 and points[nonzero - 1].y == 0:
    dec nonzero
var lower = 0
while lower < nonzero and points[lower].y >= 0:
    inc lower
for i in lower..<nonzero:
    echo points[i].x, " ", points[i].y
for i in nonzero..<n:
    echo points[i].x, " ", points[i].y
for i in 0..<lower:
    echo points[i].x, " ", points[i].y
