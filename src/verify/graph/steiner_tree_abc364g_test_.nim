# verification-helper: PROBLEM https://atcoder.jp/contests/abc364/tasks/abc364_g
import cplib/graph/graph
import cplib/graph/steiner_tree
import cplib/utils/constants
import sequtils
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
{.warning[UnusedImport]: off.}
{.hint[XDeclaredButNotUsed]: off.}

var n, m, k = ii()
var g = initWeightedUnDirectedGraph(n)
for i in 0..<m:
    var u, v = ii() - 1
    var c = ii()
    g.add_edge(u, v, c)

var terminal = (0..<k-1).toseq

var dp = steiner_tree_dp(g, terminal, INF64)
for i in k-1..<n:
    echo dp[^1][i]
