# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"
import sequtils
import cplib/collections/range_reverse_dualsegtree

proc addMapping(f, x: int): int =
    x + f

proc addComposition(f, g: int): int =
    f + g

var seg = initRangeReverseDualSegmentTree([0, 1, 2, 3, 4, 5, 6, 7], addMapping, addComposition, 0)
assert seg.len == 8
assert seg.toSeq == @[0, 1, 2, 3, 4, 5, 6, 7]

seg.apply(2, 6, 10)
assert seg.toSeq == @[0, 1, 12, 13, 14, 15, 6, 7]
assert seg[3] == 13

seg.reverse(1, 7)
assert seg.toSeq == @[0, 6, 15, 14, 13, 12, 1, 7]
assert seg[^1] == 7

seg.apply(3..5, -2)
assert seg.toSeq == @[0, 6, 15, 12, 11, 10, 1, 7]

seg[4] = 100
assert seg.toSeq == @[0, 6, 15, 12, 100, 10, 1, 7]
seg.reverse(0..<8)
assert seg.toSeq == @[7, 1, 10, 100, 12, 15, 6, 0]

var empty = initRangeReverseDualSegmentTree(newSeq[int](), addMapping, addComposition, 0)
empty.apply(0, 0, 1)
empty.reverse(0, 0)
assert empty.len == 0
assert empty.toSeq == newSeq[int]()

type Affine = tuple[a: int, b: int]

proc affineMapping(f: Affine, x: int): int =
    f.a * x + f.b

proc affineComposition(f, g: Affine): Affine =
    (a: f.a * g.a, b: f.a * g.b + f.b)

var affine = newRangeReverseDualSegWith(
    @[1, 2, 3, 4],
    f.a * x + f.b,
    (a: f.a * g.a, b: f.a * g.b + f.b),
    (a: 1, b: 0)
)
affine.apply(0, 4, (a: 2, b: 1))
affine.apply(1, 3, (a: 3, b: -2))
assert affine.toSeq == @[3, 13, 19, 9]
affine.reverse(0..3)
assert affine.toSeq == @[9, 19, 13, 3]

var initializedBySize = initRangeReverseDualSegmentTree(4, 5, affineMapping, affineComposition, (a: 1, b: 0))
initializedBySize.apply(1, 4, (a: 2, b: 0))
assert initializedBySize.toSeq == @[5, 10, 10, 10]
initializedBySize.reverse(0, 4)
assert initializedBySize.toSeq == @[10, 10, 10, 5]

var initializedBySizeTemplate = newRangeReverseDualSegWith(
    3,
    1,
    f.a * x + f.b,
    (a: f.a * g.a, b: f.a * g.b + f.b),
    (a: 1, b: 0)
)
initializedBySizeTemplate.apply(0, 3, (a: 4, b: 2))
assert initializedBySizeTemplate.toSeq == @[6, 6, 6]
