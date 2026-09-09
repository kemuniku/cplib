# verification-helper: PROBLEM https://judge.yosupo.jp/problem/dynamic_tree_vertex_set_path_composite
import sequtils, strutils
import cplib/tree/link_cut_tree

const Mod = 998244353'i64
type Affine = tuple[a, b: int64]

proc scanf(formatstr: cstring): cint {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = discard scanf("%lld", addr result)
proc op(l, r: Affine): Affine =
    (a: l.a * r.a mod Mod, b: (l.b * r.a + r.b) mod Mod)

let n = ii()
let q = ii()
let values = newSeqWith(n, (a: int64(ii()), b: int64(ii())))
let tree = initLinkCutTree(values, op, (a: 1'i64, b: 0'i64))
for i in 0..<n - 1:
    let u = ii()
    let v = ii()
    tree.link(u, v)

var answers: seq[string]
for i in 0..<q:
    case ii()
    of 0:
        let u = ii()
        let v = ii()
        let w = ii()
        let x = ii()
        tree.cut(u, v)
        tree.link(w, x)
    of 1:
        let p = ii()
        let c = int64(ii())
        let d = int64(ii())
        tree[p] = (a: c, b: d)
    else:
        let u = ii()
        let v = ii()
        let x = int64(ii())
        let f = tree.pathProd(u, v)
        answers.add($((f.a * x + f.b) mod Mod))
echo answers.join("\n")
