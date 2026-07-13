# verification-helper: PROBLEM https://judge.yosupo.jp/problem/dynamic_tree_vertex_add_path_sum
import sequtils, strutils
import cplib/collections/link_cut_tree

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

let n = ii()
let q = ii()
var values = newSeqWith(n, ii())
var lct = newLinkCutTreeWith(values, l + r, 0)
for _ in 0..<n - 1:
    discard lct.link(ii(), ii())

var answers = newSeqOfCap[int](q)
for _ in 0..<q:
    case ii()
    of 0:
        let u = ii()
        let v = ii()
        let w = ii()
        let x = ii()
        doAssert lct.cut(u, v)
        doAssert lct.link(w, x)
    of 1:
        let p = ii()
        lct[p] = lct[p] + ii()
    else:
        answers.add(lct.fold(ii(), ii()))

echo answers.join("\n")
