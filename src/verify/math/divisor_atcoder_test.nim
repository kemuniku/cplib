# verification-helper: PROBLEM https://atcoder.jp/contests/abc180/tasks/abc180_c
import strutils
import cplib/math/divisor

var n = stdin.readLine.parseInt
echo divisor(n).join("\n")
