# verification-helper: PROBLEM https://judge.yosupo.jp/problem/vertex_get_range_contour_add_on_tree
include cplib/tmpl/fastio
import cplib/graph/graph
import cplib/tree/centroid_binary_tree
import cplib/collections/fenwick

proc main() =
    let n = input(int)
    let q = input(int)
    let values = input(n, int64)
    var g = initUnWeightedUnDirectedStaticGraph(n)
    for _ in 0..<n - 1:
        let u = input(int)
        let v = input(int)
        g.add_edge(u, v)
    g.build()
    let tree = initCentroidBinaryTree(g)
    var bits = newSeq[FenwickTree[int64]](tree.node_count)
    for node in 0..<tree.node_count:
        bits[node] = initFenwickTree[int64](tree.node_info(node).size + 1)
    var answers = newSeqOfCap[int64](q)
    for _ in 0..<q:
        let kind = input(int)
        let v = input(int)
        if kind == 0:
            let l = input(int)
            let r = input(int)
            let delta = input(int64)
            for interval in tree.distance_ranges(v, l, r):
                bits[interval.node].add(interval.first, delta)
                bits[interval.node].add(interval.past, -delta)
        else:
            var answer = values[v]
            for point in tree.point_path(v):
                answer += bits[point.node].prefix(point.index + 1)
            answers.add(answer)
    if answers.len > 0: print(*answers, sep = "\n")

main()
