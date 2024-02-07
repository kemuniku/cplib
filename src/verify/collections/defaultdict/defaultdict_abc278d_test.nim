# verification-helper: PROBLEM https://atcoder.jp/contests/abc278/tasks/abc278_d
import cplib/collections/defaultdict
import strutils, sequtils, tables, hashes
var n = stdin.readLine.parseInt
var a = stdin.readLine.split.map parseInt
var add = (0..<n).toSeq.mapIt((it, a[it])).toDefaultDict(0)
var base = 0
var q = stdin.readLine.parseInt
var ans = newSeqOfCap[int](q)
for i in 0..<q:
    var t = stdin.readLine.split.map parseInt
    if t[0] == 1:
        base = t[1]
        add.clear
    elif t[0] == 2:
        add[t[1] - 1] += t[2]
    else:
        ans.add(base + add[t[1] - 1])
echo ans.join("\n")
