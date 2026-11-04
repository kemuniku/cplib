# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sequtils
import cplib/graph/graph, cplib/graph/steiner_tree
block:
  var g=initWeightedUnDirectedGraph(3,int)
  doAssert g.steiner_tree_mincost(@[0,1],high(int))==high(int)
  g.add_edge(1,2,high(int))
  doAssert g.steiner_tree_mincost(@[0])==0
block:
  var g=initWeightedUnDirectedGraph(3,int32)
  doAssert g.steiner_tree_mincost(@[0,1],high(int32))==high(int32)
  g.add_edge(1,2,high(int32))
  doAssert g.steiner_tree_mincost(@[0])==0
var rng=initRand(193815)
for trial in 0..<1000:
  let n=rng.rand(1..6)
  var g=initWeightedUnDirectedGraph(n,int)
  var edges:seq[(int,int,int)]
  for e in 0..<rng.rand(8):
    let a=rng.rand(n-1);let b=rng.rand(n-1);let w=rng.rand(12)
    g.add_edge(a,b,w);edges.add((a,b,w))
  var terms:seq[int]
  for a in 0..<n:
    if rng.rand(1)==1:terms.add(a)
  var best=high(int)
  for mask in 0..<(1 shl edges.len):
    var p=toSeq(0..<n)
    proc root(a:int):int=
      result=a
      while p[result]!=result:result=p[result]
    var cost=0
    for e,(a,b,w) in edges:
      if (mask and (1 shl e))!=0:
        p[root(a)]=root(b);cost+=w
    var ok=true
    for a in terms:
      if root(a)!=root(terms[0]):ok=false
    if ok:best=min(best,cost)
  doAssert g.steiner_tree_mincost(terms,high(int))==best
echo "Hello World"
