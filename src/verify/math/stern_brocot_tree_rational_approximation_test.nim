# verification-helper: PROBLEM https://judge.yosupo.jp/problem/rational_approximation
import cplib/math/stern_brocot_tree
include cplib/tmpl/fastio

let t = input(int)
for _ in 0..<t:
    let n = input(int)
    let x = input(int)
    let y = input(int)
    let bounds = get_bounds(x, y, n)
    if bounds.p * y == bounds.q * x:
        print(bounds.p, bounds.q, bounds.p, bounds.q)
    else:
        print(bounds.p, bounds.q, bounds.r, bounds.s)
