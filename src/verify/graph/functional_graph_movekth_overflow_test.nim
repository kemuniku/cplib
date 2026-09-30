# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/functional_graph

proc expected(next: seq[int], start, count: int): int =
    var seen = newSeq[int](next.len)
    for i in 0..<seen.len:
        seen[i] = -1
    var path: seq[int] = @[]
    var v = start
    while seen[v] == -1:
        seen[v] = path.len
        path.add(v)
        v = next[v]
    if count < path.len:
        return path[count]
    let prefix = seen[v]
    return path[prefix + (count-prefix) mod (path.len-prefix)]

for next in [@[0], @[1, 0], @[1, 2, 0], @[1, 2, 0, 2, 3], @[0, 2, 1, 4, 2]]:
    let graph = initFunctionalGraph(next)
    for start in 0..<next.len:
        for count in 0..100:
            doAssert graph.movekth(start, count) == expected(next, start, count)
        for count in [high(int)-2, high(int)-1, high(int)]:
            doAssert graph.movekth(start, count) == expected(next, start, count)
echo "Hello World"
