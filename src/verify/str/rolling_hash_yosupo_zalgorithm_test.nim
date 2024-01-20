# verification-helper: PROBLEM https://judge.yosupo.jp/problem/zalgorithm
import sequtils, strutils
import cplib/str/rolling_hash
import cplib/utils/binary_search

var s = stdin.readLine
var rh = initRollingHash(s)
var ans = newSeqWith(s.len, 0)
for i in 0..<s.len:
    proc isok(x: int): bool = x == 0 or rh.query(i..<i+x) == rh.query(0..<x)
    ans[i] = meguru_bisect(0, s.len - i + 1, isok)
echo ans.join(" ")
