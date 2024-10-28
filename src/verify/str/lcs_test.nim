# verification-helper: PROBLEM https://atcoder.jp/contests/dp/tasks/dp_f

import sequtils,strutils
import cplib/str/lcs

var S = stdin.readline().toseq()
var T = stdin.readline().toseq()
echo restoreLCS(S,T).join("")
assert len(restoreLCS(S,T)) == LCS(S,T)