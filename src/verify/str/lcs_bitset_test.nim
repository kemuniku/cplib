# verification-helper: PROBLEM https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=ALDS1_10_C

import strutils
import cplib/str/lcs_bitset

for _ in 0..<stdin.readLine().parseInt():
    let s = stdin.readLine()
    let t = stdin.readLine()
    echo LCS(s, t)
