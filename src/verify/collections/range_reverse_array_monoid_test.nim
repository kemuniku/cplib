# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"
import sequtils
import cplib/collections/range_reverse_array_monoid

proc addInt(a, b: int): int = a + b

var emptyMonoid = initRangeReverseArrayMonoid(newSeq[int](), addInt, 0)
emptyMonoid.reverse(0, 0)
assert emptyMonoid.len == 0
assert emptyMonoid.get_all == 0
assert emptyMonoid.get(0, 0) == 0

var d = initRangeReverseArrayMonoid((0..<8).toSeq, addInt, 0)
assert d.len == 8
assert d.get_all == 28
assert d.get(2, 6) == 14
assert d[2..5] == 14
d.reverse(1, 7)
assert d.toSeq == @[0, 6, 5, 4, 3, 2, 1, 7]
assert d.get_all == 28
assert d.get(1, 4) == 15
d[3] = 100
assert d.toSeq == @[0, 6, 5, 100, 3, 2, 1, 7]
assert d.get(2, 6) == 110
assert d[^1] == 7

var e = newRangeReverseArrayMonoidWith((1..5).toSeq, l + r, 0)
assert e.fold == 15
e.reverse(1..<4)
assert e.toSeq == @[1, 4, 3, 2, 5]
assert e.fold(1, 4) == 9

proc concat(a, b: string): string = a & b

var f = initRangeReverseArrayMonoid(["a", "b", "c", "d", "e"], concat, "")
assert f.get_all == "abcde"
assert f.get(1, 4) == "bcd"
f.reverse(1, 5)
assert f.toSeq == @["a", "e", "d", "c", "b"]
assert f.get_all == "aedcb"
assert f[1..3] == "edc"
f[2] = "X"
assert f.toSeq == @["a", "e", "X", "c", "b"]
assert f.fold == "aeXcb"
assert $f == "a e X c b"

import std/[random, strutils, algorithm]

block:
    var rng = initRand(91842)
    var seg = newRangeReverseArrayMonoidWith(newSeq[int](), l + r, 0)
    var values: seq[int]
    for step in 0..<12000:
        let n = values.len
        let i = rng.rand(n)
        case rng.rand(0..6)
        of 0, 1:
            let x = rng.rand(20)
            seg.insert(i, x)
            values.insert(x, i)
        of 2:
            if i < n:
                seg.erase(i)
                values.delete(i)
        of 3:
            if i < n:
                let x = rng.rand(20)
                seg[i] = x
                values[i] = x
        of 4:
            if step mod 17 == 0:
                let r = rng.rand(i..n)
                seg.erase(i..<r)
                values = values[0..<i] & values[r..<n]
        of 5:
            let r = rng.rand(i..n)
            seg.reverse(i, r)
            if i < r: values.reverse(i, r - 1)
        else:
            if i < n: doAssert seg[i] == values[i]
        doAssert seg.len == values.len
        var total = 0
        for x in values: total += x
        doAssert seg.fold == total
        let l = rng.rand(values.len)
        let r = rng.rand(l..values.len)
        var expected = 0
        for j in l..<r: expected += values[j]
        doAssert seg[l..<r] == expected
        let limit = rng.rand(100)
        var right = l
        var sum = 0
        while right < values.len and sum + values[right] <= limit:
            sum += values[right]
            inc right
        doAssert seg.max_right(l, proc(x: int): bool = x <= limit) == right
        var left = r
        sum = 0
        while left > 0 and sum + values[left - 1] <= limit:
            dec left
            sum += values[left]
        doAssert seg.min_left(r, proc(x: int): bool = x <= limit) == left
        if step mod 101 == 0: doAssert seg.toSeq == values
    seg.erase(0, seg.len)
    doAssert seg.fold == 0
    doAssert seg.toSeq == newSeq[int]()
    seg.insert(0, 7)
    doAssert seg[^1] == 7
    doAssert $seg == "7"

# 非可換な集約と境界探索の順序を検証する。
block:
    var seg = newRangeReverseArrayMonoidWith(@["a", "bc", "d", "ef", "g"], l & r, "")
    seg.insert(2, "xy")
    seg.erase(0)
    seg[3] = "z"
    let values = @["bc", "xy", "d", "z", "g"]
    doAssert seg.toSeq == values
    for l in 0..seg.len:
        for r in l..seg.len:
            let target = values[l..<r].join("")
            doAssert seg.fold(l, r) == target
            doAssert seg.max_right(l, proc(x: string): bool = target.startsWith(x)) == r
            doAssert seg.min_left(r, proc(x: string): bool = target.endsWith(x)) == l
    doAssert seg.fold == values.join("")
    seg.erase(1..3)
    doAssert seg.toSeq == @["bc", "g"]

# 構築と、一点更新・取得が集約を不必要に再計算しないことを確認する。
block:
    var calls = 0
    proc op(a, b: int): int =
        inc calls
        a + b
    var seg = initRangeReverseArrayMonoid(newSeqWith(10000, 1), op, 0)
    doAssert seg.get_all == 10000
    calls = 0
    doAssert seg.get(0, 10000) == 10000
    doAssert seg[5000] == 1
    doAssert calls == 0
    seg.update(5000, 20)
    doAssert seg.get_all == 10019
    doAssert seg.get(4999..5001) == 22
    doAssert seg.fold(0..<0) == 0

# 非可換な集約で、未伝播の反転と挿入・削除・探索を混在させる。
block:
    var rng = initRand(37283)
    var values = @["a", "b", "c", "d"]
    var seg = newRangeReverseArrayMonoidWith(values, l & r, "")
    for step in 0..<2000:
        let n = values.len
        let l = rng.rand(n)
        let r = rng.rand(l..n)
        case step mod 4
        of 0:
            seg.reverse(l, r)
            if l < r: values.reverse(l, r - 1)
        of 1:
            seg.insert(l, "x")
            values.insert("x", l)
        of 2:
            seg.erase(l, r)
            values = values[0..<l] & values[r..<n]
        else:
            if l < n:
                seg[l] = "yz"
                values[l] = "yz"
        doAssert seg.fold == values.join("")
        let a = rng.rand(values.len)
        let b = rng.rand(a..values.len)
        let target = values[a..<b].join("")
        doAssert seg.get(a, b) == target
        doAssert seg.max_right(a, proc(x: string): bool = target.startsWith(x)) == b
        doAssert seg.min_left(b, proc(x: string): bool = target.endsWith(x)) == a
    doAssert seg.toSeq == values
