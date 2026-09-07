# verification-helper: PROBLEM https://judge.yosupo.jp/problem/rooted_tree_isomorphism_classification
import algorithm, sequtils, strutils
import cplib/graph/graph
import cplib/tree/tree_hash

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} =
    scanf("%lld", addr result)

let n = ii()
var g = initUnWeightedUnDirectedStaticGraph(n)
for i in 1..<n:
    let p = ii()
    g.add_edge(i, p)
g.build()

let hashes = g.subtree_hash()
let values = hashes.sorted().deduplicate(true)
echo values.len
echo hashes.mapIt(values.lowerBound(it)).join(" ")
