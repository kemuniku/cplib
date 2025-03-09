# verification-helper: PROBLEM https://atcoder.jp/contests/abc340/tasks/abc340_g
import sequtils,sets
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
import cplib/graph/graph
import cplib/tree/heavylightdecomposition
import atcoder/modint
type mint = modint998244353
var N = ii()
var A = newseqwith(N,ii())

var G = initUnWeightedUnDirectedGraph(N)

for i in 0..<(N-1):
    var u,v = ii()-1
    G.add_edge(u,v)

var T = G.initHld(0)

var X = newseq[seq[int]](N)
for i in 0..<(N):
    X[A[i]-1].add(i)

var anss = mint(0)

for i in 0..<(N):
    if len(X[i]) > 0:
        var HX = X[i].toHashSet()
        var G = T.initAuxiliaryTree(X[i])
        var ans = mint(0)
        proc dfs(x,p:int):(mint,mint)=
            #(iが端でないようなもの、iが端のもの)
            for y in G[x]:
                if y != p:
                    var (a,b) = dfs(y,x)
                    result[0] += (result[0]+result[1])*(a+b)
                    result[1] += (a+b)
            if x in HX:
                result[1] += 1
                ans += result[1]+result[0]
            else:
                ans += result[0]
            return result
        discard dfs(G.v[0],-1)
        anss += ans

echo anss
