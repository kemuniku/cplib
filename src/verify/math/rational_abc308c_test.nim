# verification-helper: PROBLEM https://atcoder.jp/contests/abc308/tasks/abc308_c
import algorithm, strutils, sequtils
import cplib/math/rational

var n = stdin.readLine.parseint
var people: seq[(Rational, int)]
for i in 0..<n:
    var a, b: int
    (a, b) = stdin.readLine.split.map parseInt
    var x = initRational(a, a+b)
    people.add((x, -i-1))
people.sort(Descending)
echo people.mapit(-it[1]).join(" ")
