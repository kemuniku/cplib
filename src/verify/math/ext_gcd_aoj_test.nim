# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/NTL_1_E
import strutils, sequtils
import cplib/math/ext_gcd

var a = stdin.readLine.split.map(parseInt)
var (x, y) = ext_gcd(a[0], a[1])
echo x, " ", y
