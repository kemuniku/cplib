# verification-helper: PROBLEM https://atcoder.jp/contests/abc220/tasks/abc220_f
import sequtils, strutils, tables
import cplib/tree/rerooting
import cplib/graph/graph
import atcoder/modint
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
var N = ii()
var G = initUnWeightedUnDirectedGraph(N)
for i in 0..<(N-1):
    var A,B = ii()-1
    G.add_edge(A,B)

proc merge(x,y:(int,int)):(int,int)=
    return (x[0]+y[0],x[1]+y[1])
proc put_vertex(x:(int,int),v:int):(int,int)=
    return x
proc put_edge(x:(int,int),u,v:int):(int,int)=
    return (x[0]+x[1]+1,x[1]+1)

echo G.solve_Rerooting(merge,(0,0),put_edge,put_vertex).mapit(it[0]).join("\n")
