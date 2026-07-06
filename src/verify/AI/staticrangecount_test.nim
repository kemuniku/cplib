# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/staticrangecount

var rc = initStaticRangeCount(@[1, 2, 1, 3, 1, 2])
assert rc.count(0, 6, 1) == 3
assert rc.count(1, 5, 1) == 2
assert rc.count(0..2, 1) == 2
assert rc.count(2..5, 2) == 1
assert rc.count(0, 6, 9) == 0
