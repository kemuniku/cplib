# verification-helper: PROBLEM https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0439
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
import cplib/graph/graph
import cplib/tree/heavylightdecomposition
import sequtils,sets,tables,sugar,strutils
import cplib/utils/constants
import cplib/collections/SWAG


var N = ii()
var C = newseqwith(N,ii())
var G = initUnWeightedUnDirectedGraph(N)

for i in 0..<(N-1):
    var s,t = ii()-1
    G.add_edge(s,t)

var T = G.initHld(0)
var X = newseq[seq[int]](N)
for i in 0..<N:
    X[C[i]-1].add(i)
var ans = newseqwith(N,0)
for i in 0..<N:
    if len(X[i]) != 0:
        var G = T.initAuxiliaryWeightedTree(X[i])
        var HX = X[i].toHashset()
        var memo = initTable[int,int]()
        proc dfs(x,p:int):int {.discardable.}=
            var now = INF64
            for (y,c) in G[x]:
                if p != y:
                    now = min(now,dfs(y,x)+c)
            
            if x in HX:
                memo[x] = 0
                return 0
            else:
                memo[x] = now
                return now
        dfs(G.v[0],-1)
        proc dfs2(x,p,v:int)=
            var swag = initSWAG((x,y:int) => min(x,y),INF64)
            var now = v
            for (y,c) in G[x]:
                if y != p:
                    swag.addLast(memo[y]+c)
            if x in HX:
                ans[x] = min(swag.fold(),v)
            for (y,c) in G[x]:
                if y != p:
                    var tmp = swag.popFirst()
                    if x in HX:
                        dfs2(y,x,c)
                    else:
                        dfs2(y,x,min(now,swag.fold())+c)
                    now = min(now,tmp)
        dfs2(G.v[0],-1,INF64)
echo ans.join("\n")





