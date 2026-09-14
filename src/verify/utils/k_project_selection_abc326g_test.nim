# verification-helper: PROBLEM https://atcoder.jp/contests/abc326/tasks/abc326_g
import cplib/utils/k_project_selection
import strutils, sequtils

let nm = stdin.readLine.split.map(parseInt)
let n = nm[0]
let m = nm[1]
let c = stdin.readLine.split.map(parseBiggestInt)
let a = stdin.readLine.split.map(parseBiggestInt)
var opt = initKProjectSelection(n, 5, int64)
for i in 0..<n:
    var costs = newSeq[int64](5)
    for level in 0..<5: costs[level] = int64(level) * c[i]
    opt.add_unary_cost(i, costs)
for i in 0..<m:
    let levels = stdin.readLine.split.map(parseInt)
    var conditions: seq[tuple[variable, threshold: int]]
    for j in 0..<n: conditions.add((j, levels[j] - 1))
    opt.add_gain_if_all_ge(conditions, a[i])
echo -opt.solve().min_cost
