# verification-helper: PROBLEM https://judge.yosupo.jp/problem/enumerate_palindromes
import strutils, sequtils
import cplib/str/manachar

var s = stdin.readLine
s = s.mapIt(it & "$").join("")[0..<(^1)]
var ans = manachar(s)
for i in 0..<ans.len:
    if i mod 2 != 0: ans[i] = ans[i] div 2 * 2
    else: ans[i] = (ans[i] + 1) div 2 * 2 - 1
echo ans.join(" ")
