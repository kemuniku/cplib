# verification-helper: PROBLEM https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=DPL_1_E

import cplib/str/edit_distance

let S = stdin.readLine()
let T = stdin.readLine()
echo editDistance(S, T)
