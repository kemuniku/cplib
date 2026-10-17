# verification-helper: PROBLEM https://judge.yosupo.jp/problem/vertex_add_range_contour_sum_on_tree
include cplib/tmpl/fastio
import cplib/graph/graph
import cplib/tree/centroid_binary_tree
import cplib/collections/fenwick

proc main() =
    let n = input(int)
    let q = input(int)
    let values = input(n, int64)
    var g = initUnWeightedUnDirectedGraph(n)
    for _ in 0..<n - 1:
        let u = input(int)
        let v = input(int)
        g.add_edge(u, v)
    let tree = initCentroidBinaryTree(g)
    var bits = newSeq[FenwickTree[int64]](tree.node_count)
    for node in 0..<tree.node_count:
        let order = tree.distance_order(node)
        var reordered = newSeq[int64](order.len)
        for i, entry in order: reordered[i] = values[entry.vertex]
        bits[node] = initFenwickTree(reordered)
    var answers = newSeqOfCap[int64](q)
    for _ in 0..<q:
        let kind = input(int)
        let v = input(int)
        if kind == 0:
            let delta = input(int64)
            for point in tree.point_path(v):
                bits[point.node].add(point.index, delta)
        else:
            let l = input(int)
            let r = input(int)
            var answer = 0'i64
            for interval in tree.distance_ranges(v, l, r):
                answer += bits[interval.node].get(interval.first, interval.past)
            answers.add(answer)
    if answers.len > 0: print(*answers, sep = "\n")

main()
