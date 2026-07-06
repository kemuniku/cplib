# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/wordsizetree

var wt = initWordsizeTree()
assert wt.ge(0) == -1
wt.incl(5)
wt.incl(70)
wt.incl(4097)
assert wt[5]
assert wt[70]
assert wt.ge(0) == 5
assert wt.ge(6) == 70
assert wt.ge(4097) == 4097
assert wt.le(4096) == 70
assert wt.le(70) == 70
wt.excl(70)
assert not wt[70]
assert wt.ge(6) == 4097
assert wt.le(4096) == 5

var wt2 = initWordsizeTree(@[false, true, false, true])
assert wt2.ge(0) == 1
assert wt2.le(10) == 3
