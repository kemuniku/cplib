# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import std/[random, sequtils, algorithm, strutils]
import cplib/collections/[range_reverse_lazysegtree, range_reverse_dualsegtree]

type
    S = tuple[sum, len: int]
    F = tuple[a, b: int]
const Mod = 998244353
proc op(x, y: S): S = ((x.sum + y.sum) mod Mod, x.len + y.len)
proc mapping(f: F, x: S): S = ((f.a * x.sum + f.b * x.len) mod Mod, x.len)
proc composition(f, g: F): F = (f.a * g.a mod Mod, (f.a * g.b + f.b) mod Mod)
const Identity: F = (1, 0)

# 集約を要求しない双対版でも、同じ操作列を検証する。
template checkOperations(tree: untyped) =
    block:
        var seg = tree
        var values: seq[S]
        var rng = initRand(20260906)
        seg.apply(0, 0, (2, 3))
        seg.reverse(0, 0)
        seg.erase(0, 0)
        for step in 0..<6000:
            let n = values.len
            let l = rng.rand(n)
            let r = rng.rand(l..n)
            case rng.rand(0..8)
            of 0, 1:
                let x: S = (rng.rand(100), 1)
                seg.insert(l, x)
                values.insert(x, l)
            of 2:
                seg.erase(l..<r)
                values = values[0..<l] & values[r..<n]
            of 3:
                let f: F = (rng.rand(0..3), rng.rand(100))
                seg.apply(l, r, f)
                for i in l..<r: values[i] = mapping(f, values[i])
            of 4:
                seg.reverse(l, r)
                if l < r: values.reverse(l, r - 1)
            of 5:
                if l < n:
                    let x: S = (rng.rand(100), 1)
                    seg[l] = x
                    values[l] = x
            of 6:
                if l < n:
                    let f: F = (0, rng.rand(100))
                    seg.apply(l, f)
                    values[l] = mapping(f, values[l])
            of 7:
                if l < n:
                    seg.erase(l)
                    values.delete(l)
            else:
                if l < n: doAssert seg[l] == values[l]
            doAssert seg.len == values.len
            when compiles(seg.get_all):
                var expected: S = (0, 0)
                for x in values: expected = op(expected, x)
                doAssert seg.get_all == expected
                let a = rng.rand(values.len)
                let b = rng.rand(a..values.len)
                expected = (0, 0)
                for i in a..<b: expected = op(expected, values[i])
                doAssert seg.get(a, b) == expected
                let limit = rng.rand(0..values.len + 2)
                doAssert seg.max_right(a, proc(x: S): bool = x.len <= limit) == min(values.len, a + limit)
                doAssert seg.min_left(b, proc(x: S): bool = x.len <= limit) == max(0, b - limit)
            # 毎回全要素を読むと遅延タグが消えるため、定期的にだけ比較する。
            if step mod 71 == 0: doAssert seg.toSeq == values
        doAssert seg.toSeq == values
        seg.erase(0, seg.len)
        doAssert seg.len == 0
        seg.insert(0, (42, 1))
        doAssert seg[^1] == (42, 1)
        seg.erase(0)
        doAssert seg.toSeq == newSeq[S]()

checkOperations(initRangeReverseLazySegmentTree(newSeq[S](), op, (0, 0), mapping, composition, Identity))
checkOperations(initRangeReverseDualSegmentTree(newSeq[S](), mapping, composition, Identity))

# 遅延タグを残したまま挿入・削除する。新しい要素には過去の更新を適用しない。
block:
    var seg = initRangeReverseLazySegmentTree(newSeqWith(100, (sum: 1, len: 1)), op, (0, 0), mapping, composition, Identity)
    seg.apply(0, 100, (2, 3))
    seg.apply(0, 100, (3, 7))
    seg.reverse(0, 100)
    seg.insert(50, (100, 1))
    seg.erase(0, 50)
    doAssert seg[0] == (100, 1)
    doAssert seg.get(1, 51) == (1100, 50)
    doAssert seg.max_right(1, proc(x: S): bool = x.sum <= 66) == 4
    doAssert seg.min_left(51, proc(x: S): bool = x.sum <= 66) == 48

# 非可換な集約でも左右の順序、反転後の二分探索を維持する。
block:
    var seg = newRangeReverseLazySegWith(
        @["a", "b", "c", "d"], l & r, "",
        (if f: x.toUpperAscii else: x), f or g, false)
    seg.apply(0, 4, true)
    seg.reverse(0, 4)
    seg.insert(2, "x")
    seg.erase(1)
    doAssert seg.fold == "DxBA"
    for l in 0..seg.len:
        for r in l..seg.len:
            let target = seg.toSeq[l..<r].join("")
            doAssert seg.max_right(l, proc(x: string): bool = target.startsWith(x)) == r
            doAssert seg.min_left(r, proc(x: string): bool = target.endsWith(x)) == l
    doAssert seg.fold == "DxBA"

# 双対版はモノイドに作用しない更新（chmin など）も扱える。
block:
    var seg = newRangeReverseDualSegWith(4, 100, min(f, x), min(f, g), high(int))
    seg.apply(0, 4, 10)
    seg.insert(2, 50)
    seg.reverse(0, 5)
    seg.erase(0..1)
    doAssert seg.toSeq == @[50, 10, 10]

echo "Hello World"
