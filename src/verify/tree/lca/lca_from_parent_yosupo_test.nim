# verification-helper: PROBLEM https://judge.yosupo.jp/problem/lca
include cplib/tmpl/fastio
import cplib/tree/lca

let n = ii()
let q = ii()
let parent = @[-1] & lii(n - 1)
let tree = initLCAFromParent(parent, 0)
for _ in 0..<q:
    let u = ii()
    let v = ii()
    print(tree.lca(u, v))
