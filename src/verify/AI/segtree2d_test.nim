# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/segtree2d

var seg2d = initSegmentTree2D(@[@[1, 2, 3], @[4, 5, 6]], proc(x, y: int): int = x + y, 0)
assert seg2d.get(0, 2, 0, 3) == 21
assert seg2d.get(1, 2, 1, 3) == 11
seg2d.update(0, 1, 10)
assert seg2d.get(0, 1, 0, 3) == 14
assert seg2d.get(0, 2, 1, 2) == 15
