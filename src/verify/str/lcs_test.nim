# verification-helper: PROBLEM https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=ALDS1_10_C

import sequtils,strutils
import cplib/str/lcs

for _ in 0..<(stdin.readLine().parseInt()):
    var S = stdin.readline().toseq()
    var T = stdin.readline().toseq()
    echo LCS(S,T)