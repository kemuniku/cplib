# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import cplib/graph/online_dynamic_connectivity
import sequtils

var dc = initOnlineDynamicConnectivity(6)
assert dc.count == 6
assert dc.addEdge(0, 1)
assert dc.addEdge(1, 2)
assert dc.addEdge(0, 2)
assert not dc.addEdge(0, 2)
assert dc.addEdge(2, 3)
assert dc.isSame(0, 3)
assert dc.componentSize(1) == 4
assert dc.count == 3

# 非木辺の削除
assert dc.removeEdge(0, 2)
assert dc.isSame(0, 3)
# 木辺の削除を残った非木辺で置換
assert dc.addEdge(0, 2)
assert dc.removeEdge(1, 2)
assert dc.isSame(0, 3)
# 橋の削除
assert dc.removeEdge(2, 3)
assert not dc.isSame(0, 3)
assert dc.componentSize(0) == 3
assert dc.componentSize(3) == 1
assert dc.count == 4

assert dc.addEdge(3, 4)
assert dc.addEdge(4, 5)
assert dc.addEdge(5, 3)
assert dc.removeEdge(3, 4)
assert dc.isSame(3, 4)
assert dc.removeEdge(4, 5)
assert not dc.isSame(3, 4)
assert dc.addEdge(2, 4)
assert dc.isSame(0, 4)
assert dc.containsEdge(2, 4)

assert dc.addEdge(5, 5)
assert dc.containsEdge(5, 5)
assert dc.removeEdge(5, 5)
assert not dc.removeEdge(5, 5)

# 素朴解とのランダム差分テスト
const n = 12
var
    rndDc = initOnlineDynamicConnectivity(n)
    adjacency = newSeqWith(n, newSeq[bool](n))
    seed = 88172645463325252'u64

proc nextInt(m: int): int =
    seed = seed xor (seed shl 7)
    seed = seed xor (seed shr 9)
    int(seed mod uint64(m))

proc naiveSame(s, t: int): bool =
    var seen = newSeq[bool](n)
    var que = @[s]
    seen[s] = true
    var head = 0
    while head < que.len:
        let u = que[head]
        inc head
        for v in 0..<n:
            if adjacency[u][v] and not seen[v]:
                seen[v] = true
                que.add(v)
    seen[t]

for step in 0..<3000:
    var u = nextInt(n)
    var v = nextInt(n)
    if u == v: v = (v + 1) mod n
    if adjacency[u][v]:
        assert rndDc.removeEdge(u, v)
        adjacency[u][v] = false
        adjacency[v][u] = false
    else:
        assert rndDc.addEdge(u, v)
        adjacency[u][v] = true
        adjacency[v][u] = true
    for x in 0..<n:
        for y in 0..<n:
            assert rndDc.isSame(x, y) == naiveSame(x, y)

echo "Hello World"
