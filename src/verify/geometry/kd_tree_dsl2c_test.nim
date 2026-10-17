# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/DSL_2_C
import algorithm
import cplib/collections/kd_tree
include cplib/tmpl/fastio

let n = ii()
var points = newSeq[array[2, int]](n)
for i in 0..<n: points[i] = [ii(), ii()]
let tree = initKDTree(points)
let q = ii()
for i in 0..<q:
    let sx = ii()
    let tx = ii()
    let sy = ii()
    let ty = ii()
    var found = tree.rangeSearch([sx, sy], [tx, ty])
    found.sort()
    for index in found: echo index
    echo ""
