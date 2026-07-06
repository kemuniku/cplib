# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import strutils
import cplib/collections/segtree_beats_template

var seg = initRangeChminChmaxRangeSumMaxMin(@[1, 5, 2, 7])
assert seg.len == 4
assert seg[0..3].sum == 15
assert seg[0..3].min == 1
assert seg[0..3].max == 7
seg.chmin(0..3, 4)
assert seg[0..3].sum == 11
seg.chmax(1..2, 3)
assert seg[0..3].sum == 12
seg.add(2..3, 2)
assert seg[0..3].sum == 16
seg.update(0, 10)
assert seg[0].sum == 10
assert seg[0..3].sum == 25
assert ($seg).contains("sum: 10")
