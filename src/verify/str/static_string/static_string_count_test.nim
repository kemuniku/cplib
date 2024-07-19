# verification-helper: PROBLEM https://atcoder.jp/contests/abc362/tasks/abc362_g
import cplib/str/static_string
import strutils
var S = stdin.readLine()
var Q = stdin.readLine().parseInt()
var SB = initStaticStringBase(S)
for i in 0..<Q:
    var T = stdin.readLine()
    stdout.writeLine(SB.count(T))