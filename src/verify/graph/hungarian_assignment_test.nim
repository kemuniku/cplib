# verification-helper: PROBLEM https://judge.yosupo.jp/problem/assignment
import strutils, sequtils
import cplib/graph/hungarian

let n = stdin.readLine.parseInt
var cost = newSeq[seq[int32]](n)
for row in 0..<n:
    cost[row] = stdin.readLine.splitWhitespace.mapIt(int32(parseBiggestInt(it)))
let answer = min_cost_assignment(cost)
doAssert answer.feasible
echo answer.cost
echo answer.columnOfRow.mapIt($it).join(" ")
