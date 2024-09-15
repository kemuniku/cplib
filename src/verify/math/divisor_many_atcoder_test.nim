# verification-helper: PROBLEM https://atcoder.jp/contests/abc170/tasks/abc170_d
import strutils, sequtils, tables, sets
import cplib/math/divisor

var _ = stdin.readLine.parseInt
var a = stdin.readLine.split.map parseInt
var cnt = a.toCountTable
var st = a.toHashSet
a = a.filterIt(cnt[it] <= 1)
echo a.countit(divisor(it, true)[0..<(^1)].allIt(not (it in st)))
