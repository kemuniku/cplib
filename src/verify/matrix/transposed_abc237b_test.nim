# verification-helper: PROBLEM https://atcoder.jp/contests/abc237/tasks/abc237_b
import strutils, sequtils
import cplib/matrix/matops
var h, w: int
(h, w) = stdin.readLine.split.map(parseInt)
var a = newSeqWith(h, stdin.readLine.split.map(parseInt))
for ai in a.transposed: echo ai.join(" ")
