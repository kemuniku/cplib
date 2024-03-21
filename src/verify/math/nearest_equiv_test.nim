# verification-helper: PROBLEM https://atcoder.jp/contests/abc334/tasks/abc334_b
import strutils, sequtils
import cplib/math/nearest_equiv

var a, m, l, r: int
(a, m, l, r) = stdin.readLine.split.map(parseInt)
var s = nearest_equiv(a, l, m)
var t = nearest_equiv(a, r+1, m)
echo max(0, (t - s) div m)
