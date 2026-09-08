# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/DPL_1_E

import cplib/str/edit_distance

let s = stdin.readLine()
let t = stdin.readLine()
echo editDistance(s, t, max(s.len, t.len))
