# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/str/merged_static_string
import cplib/str/static_string

let ss = toStaticStrings(@["ab", "cd", "abce"])
let m1 = ss[0] & ss[1]
assert $m1 == "abcd"
assert m1.len == 4
assert m1[2] == 'c'
assert $m1[1..2] == "bc"
var m2 = initMergedStaticString(@[ss[0]])
m2 &= ss[1]
assert m1 == m2
let m3 = ss[0] & ss[2]
assert lcp(m1, m3) == 2
assert cmp(m1, m3) > 0
assert m3 < m1
assert m1 >= m2
