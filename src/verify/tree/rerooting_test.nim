# verification-helper: PROBLEM https://judge.yosupo.jp/problem/tree_path_composite_sum
import sequtils, strutils, tables
import cplib/tree/rerooting
import cplib/graph/graph
import atcoder/modint
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
type mint = modint998244353
var N = ii()
var A = newseqwith(N,ii())
var G = initUnWeightedUnDirectedGraph(N)
var T = initTable[(int,int),(mint,mint)]()
for i in 0..<(N-1):
    var u,v = ii()
    var b,c = ii().mint()
    G.add_edge(u,v)
    T[(u,v)] = (b,c)
    T[(v,u)] = (b,c)

proc merge(x,y:(mint,int)):(mint,int)=
    return (x[0]+y[0],x[1]+y[1])

proc put_vertex(x:(mint,int),v:int):(mint,int)=
    return (x[0] + A[v],x[1]+1)

proc put_edge(x:(mint,int),u,v:int):(mint,int)=
    var (b,c) = T[(u,v)]
    return (b*x[0]+c*x[1],x[1])

echo G.solve_Rerooting(merge,(mint(0),0),put_edge,put_vertex).mapit(it[0]).join(" ")

