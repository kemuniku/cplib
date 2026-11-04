# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_4_A
# verification-helper: ERROR 1e-5
import sequtils, strutils
import cplib/utils/binary_search

let input = stdin.readLine.split.map(parseInt)
let a = input[0]
let b = input[1]
var div_int = meguru_bisect(0, a+1, proc(x: int): bool = a >= b * x)
var rem = a - b * div_int
var div_flaot = meguru_bisect(0.0, float64(a + 1), proc(x: float64): bool = (float64(a) >= float64(b) * x))
echo div_int, " ", rem, " ", div_flaot
