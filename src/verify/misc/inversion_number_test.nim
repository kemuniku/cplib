# verify-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ALDS1_5_D
include cplib/tmpl/citrus
import cplib/misc/inversion_number

var n = input(int)
var a = input(int, n)
print(inversion_number(a))
