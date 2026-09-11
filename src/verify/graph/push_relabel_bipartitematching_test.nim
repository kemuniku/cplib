# verification-helper: PROBLEM https://judge.yosupo.jp/problem/bipartitematching
import cplib/graph/push_relabel
include cplib/tmpl/fastio

let left = ii()
let right = ii()
let m = ii()
let src = left + right
let dst = src + 1
var g = initPushRelabel[int](dst + 1)
for i in 0..<left:
    g.add_edge(src, i, 1)
for i in 0..<right:
    g.add_edge(left + i, dst, 1)
for i in 0..<m:
    let a = ii()
    let b = ii()
    g.add_edge(a, left + b, 1)
print g.flow(src, dst)
for i in left + right..<left + right + m:
    let e = g.get_edge(i)
    if e.flow == 1:
        print(e.src, e.dst - left)
