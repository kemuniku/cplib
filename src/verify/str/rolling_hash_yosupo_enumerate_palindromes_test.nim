# verification-helper: PROBLEM https://judge.yosupo.jp/problem/enumerate_palindromes
import sequtils, strutils, algorithm
import cplib/str/rolling_hash
import cplib/utils/binary_search

var s = stdin.readLine
var n = s.len
var rh = initRollingHash(s)
var rhr = initRollingHash(s.reversed.join(""))
var ans = newSeqWith(n*2-1, 0)
for i in 0..<n*2-1:
    var l = i div 2
    var r = n - 1 - (i div 2)
    if i mod 2 == 0:
        proc isok(x: int): bool = return x == 0 or rh.query(l-x..l+x) == rhr.query(r-x..r+x)
        var mx = min(i div 2, n - 1 - (i div 2))
        var x = meguru_bisect(0, mx+1, isok)
        ans[i] = x * 2 + 1
    else:
        proc isok(x: int): bool = return x == 0 or rh.query(l-x+1..l+x) == rhr.query(r-x..r+x-1)
        var mx = min((i div 2) + 1, n - 1 - (i div 2))
        var x = meguru_bisect(0, mx+1, isok)
        ans[i] = x * 2
echo ans.join(" ")
