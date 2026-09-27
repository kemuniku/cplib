# verification-helper: PROBLEM https://judge.yosupo.jp/problem/static_rectangle_add_rectangle_sum
import cplib/utils/static_rectangle_add_rectangle_sum
import cplib/modint/modint

include cplib/tmpl/fastio

type mint = modint998244353_montgomery
let n = ii()
let q = ii()
var rectangles = newSeq[(int, int, int, int, mint)](n)
var queries = newSeq[(int, int, int, int)](q)
for rectangle in rectangles.mitems:
    let l = ii()
    let d = ii()
    let r = ii()
    let u = ii()
    let w = ii()
    rectangle = (l, d, r, u, mint.init(w))
for query in queries.mitems:
    let l = ii()
    let d = ii()
    let r = ii()
    let u = ii()
    query = (l, d, r, u)
for answer in static_rectangle_add_rectangle_sum(rectangles, queries):
    print answer.val
