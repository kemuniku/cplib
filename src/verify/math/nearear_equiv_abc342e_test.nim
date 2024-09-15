# verification-helper: PROBLEM https://atcoder.jp/contests/abc342/tasks/abc342_e
import sequtils, heapqueue
import cplib/math/nearest_equiv
import cplib/graph/graph
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var n, m = ii()
var g = initWeightedDirectedStaticGraph(n, (int, int, int, int), m)
for i in 0..<m:
    var l, d, k, c = ii()
    var a, b = ii() - 1
    g.add_edge(b, a, (l, d, k, c))
g.build

var inf = int(3003003003003003003)
var dp = newSeqWith(n, -inf)
var q = initHeapQueue[(int, int)]()
q.push((-inf, n-1))
dp[n-1] = inf

while q.len > 0:
    var (t, x) = q.pop
    t = -t
    # echo t, " ", x
    if t != dp[x]: continue
    for (y, cost) in g[x]:
        var (l, d, k, c) = cost
        var nt = nearest_equiv(l, t - c + 1, d) - d
        if nt < l: continue
        if nt >= l + k * d: nt = l + (k - 1) * d
        if dp[y] > nt: continue
        dp[y] = nt
        q.push((-nt, y))

for i in 0..<n-1:
    if dp[i] == -inf: echo "Unreachable"
    else: echo dp[i]
