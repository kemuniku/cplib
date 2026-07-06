# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"
import sequtils, strutils
import cplib/collections/range_reverse_lazysegtree

type SumLen = tuple[sum: int, len: int]

proc op(a, b: SumLen): SumLen =
    (sum: a.sum + b.sum, len: a.len + b.len)

proc mapping(f: int, x: SumLen): SumLen =
    (sum: x.sum + f * x.len, len: x.len)

proc composition(f, g: int): int =
    f + g

var v: seq[SumLen]
for i in 0..<8:
    v.add((sum: i, len: 1))

var seg = initRangeReverseLazySegmentTree(v, op, (sum: 0, len: 0), mapping, composition, 0)
assert seg.len == 8
assert seg.get_all.sum == 28
assert seg.get(2, 6).sum == 14
assert seg[2..5].sum == 14

seg.apply(1, 5, 10)
assert seg.toSeq.mapIt(it.sum) == @[0, 11, 12, 13, 14, 5, 6, 7]
assert seg.get_all.sum == 68
assert seg.get(1, 4).sum == 36

seg.reverse(2, 7)
assert seg.toSeq.mapIt(it.sum) == @[0, 11, 6, 5, 14, 13, 12, 7]
assert seg.get(2, 6).sum == 38

seg.apply(3..5, -3)
assert seg.toSeq.mapIt(it.sum) == @[0, 11, 6, 2, 11, 10, 12, 7]
assert seg.get_all.sum == 59

seg[4] = (sum: 100, len: 1)
assert seg.toSeq.mapIt(it.sum) == @[0, 11, 6, 2, 100, 10, 12, 7]
assert seg[^1].sum == 7
assert seg.fold.sum == 148

var seg2 = newRangeReverseLazySegWith(
    v,
    (sum: l.sum + r.sum, len: l.len + r.len),
    (sum: 0, len: 0),
    (sum: x.sum + f * x.len, len: x.len),
    f + g,
    0
)
seg2.reverse(0..<8)
seg2.apply(0, 3, 1)
assert seg2.toSeq.mapIt(it.sum) == @[8, 7, 6, 4, 3, 2, 1, 0]

proc concat(a, b: string): string =
    a & b

proc upperMapping(f: bool, x: string): string =
    if f: x.toUpperAscii else: x

proc upperComposition(f, g: bool): bool =
    f or g

var s = initRangeReverseLazySegmentTree(["a", "b", "c", "d", "e"], concat, "", upperMapping, upperComposition, false)
assert s.get_all == "abcde"
s.apply(1, 4, true)
assert s.get_all == "aBCDe"
s.reverse(0, 5)
assert s.get_all == "eDCBa"
s.apply(0..<2, true)
assert s.get_all == "EDCBa"
s.reverse(1..3)
assert s.toSeq == @["E", "B", "C", "D", "a"]
s[2] = "x"
assert s.get_all == "EBxDa"
assert $s == "E B x D a"
