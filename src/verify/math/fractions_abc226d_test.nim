# verification-helper: PROBLEM https://atcoder.jp/contests/abc226/tasks/abc226_d
import sequtils, strutils, sets
import cplib/math/fractions

var n = stdin.readLine.parseInt
var x, y = newSeqWith(n, 0)
for i in 0..<n: (x[i], y[i]) = stdin.readLine.split.map parseInt
var st = initHashSet[Fraction[int]](0)
for i in 0..<n:
    for j in i+1..<n:
        var x = initFraction(x[i] - x[j], y[i] - y[j])
        if x == initFraction(-1, 0): x = initFraction(1, 0)
        st.incl(x)
echo st.len * 2
