# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ALDS1_5_D
import sequtils, strutils
import cplib/utils/inversion_number

discard stdin.readLine.parseInt
var a = stdin.readLine.split.map(parseInt)
echo inversion_number(a)
