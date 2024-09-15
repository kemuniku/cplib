# verification-helper: PROBLEM https://atcoder.jp/contests/abc308/tasks/abc308_c
import algorithm, strutils, sequtils
import cplib/math/fractions

var n = stdin.readLine.parseint
var people: seq[(Fraction[int], int)]
for i in 0..<n:
    var a, b: int
    (a, b) = stdin.readLine.split.map parseInt
    var x = initFraction(a, a+b)
    people.add((x, -i-1))
people.sort(Descending)
echo people.mapit(-it[1]).join(" ")
