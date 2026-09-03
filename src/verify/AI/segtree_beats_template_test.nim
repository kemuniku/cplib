# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import strutils
import cplib/collections/segtree_beats_template
import cplib/math/int128

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

# Regression test for https://github.com/kemuniku/cplib/issues/485.
# Int128 fields used to be lost when the wrapped segment tree was copied.
let inf128 = parseInt128("1000000000000000000000000000000")
var seg128 = initRangeChminChmaxRangeSumMaxMin(
  @[to_Int128(-15), to_Int128(-10), to_Int128(-5), to_Int128(0), to_Int128(5)],
  inf128,
  to_Int128(0)
)
seg128.chmax(0..4, to_Int128(-10))
seg128.add(0..4, to_Int128(10))
seg128.chmin(0..4, to_Int128(10))
for i, expected in @[0, 0, 5, 10, 10]:
  assert seg128[i].sum == expected
