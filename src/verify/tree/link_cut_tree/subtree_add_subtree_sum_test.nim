# verification-helper: PROBLEM https://judge.yosupo.jp/problem/dynamic_tree_subtree_add_subtree_sum
import sequtils, strutils
import cplib/tree/lazy_subtree_link_cut_tree

proc scanf(formatstr: cstring): cint {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = discard scanf("%lld", addr result)

let n = ii()
let q = ii()
let values = newSeqWith(n, (sum: int64(ii()), count: 1))
let tree = newLazySubtreeLinkCutTreeWith(
    values,
    (sum: l.sum + r.sum, count: l.count + r.count),
    (sum: 0'i64, count: 0),
    (sum: x.sum + f * int64(x.count), count: x.count),
    f + g, 0'i64,
    (sum: -x.sum, count: -x.count), -f
)
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
        let v = ii()
        let p = ii()
        let x = int64(ii())
        tree.subtreeApply(v, p, x)
    else:
        let v = ii()
        let p = ii()
        answers.add($tree.subtreeProd(v, p).sum)
echo answers.join("\n")
