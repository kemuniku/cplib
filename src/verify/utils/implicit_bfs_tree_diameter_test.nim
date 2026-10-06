# verification-helper: PROBLEM https://judge.yosupo.jp/problem/tree_diameter
include cplib/tmpl/sheep
import cplib/utils/implicit_bfs

let N = ii()
var edges = newSeq[seq[(int, int)]](N)
var neighbors = newSeq[seq[int]](N)
for i in 0..<N - 1:
    var a, b, c = ii()
    edges[a].add((b, c))
    edges[b].add((a, c))
    neighbors[a].add(b)
    neighbors[b].add(a)

let adjacent: ImplicitBfsAdjacent[int] = proc(v: int): seq[int] = neighbors[v]

proc farthest(start: int): tuple[vertex, cost: int] =
    let restored = restore_implicit_bfs(@[start], adjacent)
    var costs = newSeq[int](N)
    var order = @[start]
    var index = 0
    result.vertex = start
    # 木の経路は一意なので、BFS の親情報に沿って元の辺重みを累積できる。
    while index < order.len:
        let vertex = order[index]
        inc index
        for (next, edgeCost) in edges[vertex]:
            if restored.prev.hasKey(next) and restored.prev[next] == vertex:
                costs[next] = costs[vertex] + edgeCost
                order.add(next)
                if costs[next] > result.cost:
                    result = (next, costs[next])

let first = farthest(0).vertex
let (last, cost) = farthest(first)
let (path, _) = shortest_path_implicit_bfs(@[first], @[last], adjacent)
echo cost, " ", path.len
echo path.join(" ")
