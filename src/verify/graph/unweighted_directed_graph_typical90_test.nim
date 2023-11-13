# verification-helper: PROBLEM https://atcoder.jp/contests/typical90/tasks/typical90_bz
import cplib/graph/graph
import strscans

var n, m: int
discard stdin.readline.scanf("$i $i", n, m)
var g = initUnWeightedDirectedGraph(n)
for i in 0..<m:
    var a, b: int
    discard stdin.readline.scanf("$i $i", a, b)
    if b > a: swap(a, b)
    g.add_edge(a-1, b-1)
var ans = 0
for i in 0..<n:
    if g.edges[i].len == 1: ans += 1
echo ans
