# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/CGL_7_A
import strutils
import cplib/geometry/base
import cplib/geometry/circle
let first = stdin.readLine.splitWhitespace
let second = stdin.readLine.splitWhitespace
let a = initCircle(initPoint(parseInt(first[0]), parseInt(first[1])), parseInt(first[2]))
let b = initCircle(initPoint(parseInt(second[0]), parseInt(second[1])), parseInt(second[2]))
echo common_tangent_count(a, b)
