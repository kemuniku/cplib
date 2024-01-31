# verification-helper: PROBLEM https://yukicoder.me/problems/no/2249
import strutils, sequtils
import cplib/math/euler_phi

var t = stdin.readLine.parseint
var mx = 10000000
var li = euler_phi_list(mx)
var dp = newSeqWith(mx+1, 0)
for i in 2..mx:
    dp[i] = dp[i-1] + li[i] * 1 + (i - 1 - li[i]) * 2
var ans = newSeq[int](0)
for _ in 0..<t:
    var n = stdin.readLine.parseint
    ans.add(dp[n])
echo ans.join("\n")
