# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ALDS1_14_B
import cplib/str/rolling_hash

var t, p = stdin.readLine
var rh_t = initRollingHash(t)
var rh_p = initRollingHash(p)
for i in 0..<t.len-p.len+1:
    if rh_t.query(i..<i+p.len) == rh_p.query(0..<p.len):
        echo i
