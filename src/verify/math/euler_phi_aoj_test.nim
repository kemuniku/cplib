# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/NTL_1_D
import strutils
import cplib/math/euler_phi

var n = stdin.readLine.parseint
echo euler_phi(n)
