# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sequtils, strutils
import cplib/collections/[avl_monoid, avl_lazysegtree, avl_dualsegtree]

proc concat(a, b: string): string = a & b

block:
    var rng = initRand(20261015)
    var tree = newAvlMonoidWith(newSeq[string](), l & r, "")
    var values: seq[string]
    doAssert tree.fold == ""
    for step in 0..<2500:
        let n = values.len
        let l = rng.rand(n)
        let r = rng.rand(l..n)
        case rng.rand(0..5)
        of 0, 1:
            let x = $(rng.rand(0..9))
            tree.insert(l, x)
            values.insert(x, l)
        of 2:
            tree.erase(l, r)
            values = values[0..<l] & values[r..<n]
        of 3:
            if l < n:
                let x = $(rng.rand(0..9))
                tree[l] = x
                values[l] = x
        of 4:
            if l < n:
                tree.erase(l)
                values.delete(l)
        else:
            discard
        doAssert tree.len == values.len
        doAssert tree.toSeq == values
        doAssert tree.fold == values.join("")
        let a = rng.rand(values.len)
        let b = rng.rand(a..values.len)
        doAssert tree.fold(a, b) == values[a..<b].join("")
        let limit = rng.rand(0..values.len + 2)
        doAssert tree.max_right(a, proc(x: string): bool = x.len <= limit) == min(values.len, a + limit)
        doAssert tree.min_left(b, proc(x: string): bool = x.len <= limit) == max(0, b - limit)
    tree.erase(0, tree.len)
    doAssert tree.toSeq.len == 0

block:
    var tree = initAvlMonoid(@["ab", "c", "de"], concat, "")
    doAssert tree.max_right(0, proc(x: string): bool = "abc".startsWith(x)) == 2
    doAssert tree.min_left(3, proc(x: string): bool = "cde".endsWith(x)) == 1
    tree.insert(1, "X")
    doAssert tree.get_all == "abXcde"
    tree.erase(2)
    doAssert tree.get_all == "abXde"

const Mod = 998244353
type S = tuple[sum, len: int]
type F = tuple[a, b: int]
const Identity: F = (1, 0)
proc op(x, y: S): S = ((x.sum + y.sum) mod Mod, x.len + y.len)
proc mapping(f: F, x: S): S = ((f.a * x.sum + f.b * x.len) mod Mod, x.len)
proc composition(f, g: F): F = (f.a * g.a mod Mod, (f.a * g.b + f.b) mod Mod)

template checkOperations(tree: untyped) =
    block:
        var seg = tree
        var values: seq[S]
        var rng = initRand(20261016)
        seg.apply(0, 0, Identity)
        seg.erase(0, 0)
        for step in 0..<3000:
            let n = values.len
            let l = rng.rand(n)
            let r = rng.rand(l..n)
            case rng.rand(0..7)
            of 0, 1:
                let x: S = (rng.rand(100), 1)
                seg.insert(l, x)
                values.insert(x, l)
            of 2:
                seg.erase(l, r)
                values = values[0..<l] & values[r..<n]
            of 3:
                let f: F = (rng.rand(0..3), rng.rand(100))
                seg.apply(l, r, f)
                for i in l..<r: values[i] = mapping(f, values[i])
            of 4:
                if l < n:
                    let x: S = (rng.rand(100), 1)
                    seg[l] = x
                    values[l] = x
            of 5:
                if l < n:
                    let f: F = (0, rng.rand(100))
                    seg.apply(l, f)
                    values[l] = mapping(f, values[l])
            of 6:
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
            if step mod 73 == 0: doAssert seg.toSeq == values
        doAssert seg.toSeq == values
        seg.erase(0, seg.len)
        seg.insert(0, (42, 1))
        doAssert seg[^1] == (42, 1)

checkOperations(initAvlLazySegmentTree(newSeq[S](), op, (0, 0), mapping, composition, Identity))
checkOperations(initAvlDualSegmentTree(newSeq[S](), mapping, composition, Identity))

block:
    var seg = newAvlLazySegWith(@["a", "b", "c", "d"], l & r, "",
        (if f: x.toUpperAscii else: x), f or g, false)
    seg.apply(0, 4, true)
    seg.insert(2, "x")
    seg.erase(1)
    doAssert seg.fold == "AxCD"
    doAssert seg.get(1, 3) == "xC"
    doAssert seg.max_right(0, proc(x: string): bool = "Ax".startsWith(x)) == 2
    doAssert seg.min_left(4, proc(x: string): bool = "CD".endsWith(x)) == 2

block:
    var seg = newAvlDualSegWith(4, 100, min(f, x), min(f, g), high(int))
    seg.apply(0, 4, 10)
    seg.insert(2, 50)
    seg.erase(0..1)
    doAssert seg.toSeq == @[50, 10, 10]

echo "Hello World"
