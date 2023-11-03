# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_4_A
# verification-helper: ERROR 1e-5
include cplib/tmpl/citrus
import cplib/misc/binary_search

var a, b = input(int)
var div_int = meguru_bisect(0, a+1, proc(x: int): bool = a >= b * x)
var rem = a - b * div_int
var div_flaot = meguru_bisect(0.0, float64(a + 1), (x)=>(a >= b * x))
print(div_int, rem, div_flaot)
