# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/dualsegtree

type Affine = tuple[a, b: int]

proc mapping(f: Affine, x: int): int =
    f.a * x + f.b

proc composition(f, g: Affine): Affine =
    (f.a * g.a, f.a * g.b + f.b)

let id = (a: 1, b: 0)
var seg = initDualSegmentTree([1, 2, 3, 4, 5], mapping, composition, id)
assert seg.len == 5
seg.apply(0, 5, (a: 2, b: 1))
seg.apply(1, 4, (a: 3, b: -2))
assert seg.toSeq == @[3, 13, 19, 25, 11]
seg.apply(2..4, (a: 1, b: 10))
assert seg[2] == 29
assert seg[^1] == 21
seg[3] = 100
assert seg.toSeq == @[3, 13, 29, 100, 21]
assert $seg == "3 13 29 100 21"

var bySize = newDualSegWith(
    4,
    5,
    f.a * x + f.b,
    (a: f.a * g.a, b: f.a * g.b + f.b),
    (a: 1, b: 0)
)
bySize.apply(1, 4, (a: 2, b: 0))
assert bySize.toSeq == @[5, 10, 10, 10]

var empty = initDualSegmentTree(newSeq[int](), mapping, composition, id)
empty.apply(0, 0, (a: 2, b: 3))
assert empty.len == 0
assert empty.toSeq == newSeq[int]()
