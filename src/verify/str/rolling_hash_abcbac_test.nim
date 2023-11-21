# verification-helper: PROBLEM https://atcoder.jp/contests/abc284/tasks/abc284_f
import strutils, algorithm
import cplib/str/rolling_hash

var n = stdin.readLine.parseInt
var t = stdin.readLine
var rh = initRollingHash(t)
var rhi = initRollingHash(t.reversed)
const rmod = (1u shl 61) - 1
for i in 0..n:
    var sh = rh.query(0..<i)
    sh += rh.query(n..<2*n)
    sh += rmod - rh.query(n..<n+i)
    sh = (sh shr 61) + (sh and rmod)
    if sh > rmod: sh -= rmod
    var shi = rhi.query(n-i..<2*n-i)
    if sh == shi:
        echo t[0..<i] & t[n+i..<2*n]
        echo i
        quit()
echo -1
