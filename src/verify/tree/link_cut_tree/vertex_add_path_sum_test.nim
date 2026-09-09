# verification-helper: PROBLEM https://judge.yosupo.jp/problem/dynamic_tree_vertex_add_path_sum
import sequtils, strutils
import cplib/tree/link_cut_tree

proc scanf(formatstr: cstring): cint {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = discard scanf("%lld", addr result)

let n = ii()
let q = ii()
let values = newSeqWith(n, int64(ii()))
let tree = newLinkCutTreeWith(values, l + r, 0'i64)
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
        let x = int64(ii())
        tree[p] = tree[p] + x
    else:
        let u = ii()
        let v = ii()
        answers.add($tree.pathProd(u, v))
echo answers.join("\n")
