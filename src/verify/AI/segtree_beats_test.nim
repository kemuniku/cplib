# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import strutils
import cplib/collections/segtree_beats

type Node = object
  sum: int
  sz: int
  fail: bool

proc node(x: int): Node = Node(sum: x, sz: 1, fail: false)
proc merge(l, r: Node): Node = Node(sum: l.sum + r.sum, sz: l.sz + r.sz, fail: false)
proc mapping(f: int, x: Node): Node = Node(sum: x.sum + f * x.sz, sz: x.sz, fail: false)
proc composition(f, g: int): int = f + g

var seg = initSegmentTreeBeats(@[node(1), node(2), node(3), node(4)], merge, Node(sum: 0, sz: 0, fail: false), mapping, composition, 0)
assert seg.len == 4
assert seg.get(0, 4).sum == 10
assert seg[1..2].sum == 5
seg.apply(1, 3, 10)
assert seg.get(0, 4).sum == 30
assert seg[1].sum == 12
seg.apply(0..1, -2)
assert seg[0].sum == -1
assert seg[1].sum == 10
seg.update(2, node(100))
assert seg[2].sum == 100
seg[3] = node(7)
assert seg.get(0, 4).sum == 116
assert ($seg).contains("sum: -1")

var seg2 = newLazySegWith(
  @[node(2), node(3)],
  Node(sum: l.sum + r.sum, sz: l.sz + r.sz, fail: false),
  Node(sum: 0, sz: 0, fail: false),
  Node(sum: x.sum + f * x.sz, sz: x.sz, fail: false),
  f + g,
  0
)
seg2.apply(0, 2, 5)
assert seg2.get(0, 2).sum == 15
