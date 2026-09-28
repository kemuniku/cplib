# verification-helper: PROBLEM https://judge.yosupo.jp/problem/general_weighted_matching
import cplib/graph/graph
import cplib/graph/general_weighted_matching_sparse
include cplib/tmpl/fastio

let n = ii()
let m = ii()
var g = initWeightedUnDirectedGraph(n, int64)
for i in 0..<m:
    let u = ii()
    let v = ii()
    let w = int64(ii())
    g.add_edge(u, v, w)
let (weight, matching) = g.maximum_weight_matching_sparse()
echo matching.len, " ", weight
for (u, v) in matching:
    echo u, " ", v
