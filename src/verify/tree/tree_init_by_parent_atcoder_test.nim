# verification-helper: PROBLEM https://atcoder.jp/contests/abc163/tasks/abc163_c
import strutils, sequtils
import cplib/tree/tree

discard stdin.readLine
var p = stdin.readLine.split.map(parseInt).mapIt(it-1)
var g = initUnWeightedTree(p)
var ans = g.edges.mapIt(it.len - 1)
ans[0] += 1
echo ans.join("\n")
