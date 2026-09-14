# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/compressed_segtree
import random

proc merge(x, y: int64): int64 = x + y

block:
    let st = initCompressedSegmentTree([9'i64, -1000000000000, 9, 1000000000000], merge, 0'i64)
    doAssert st.len == 3
    st[-1000000000000'i64] = 4
    st[9'i64] = 7
    st[1000000000000'i64] = 11
    doAssert st.get(-1000000000001'i64, 10'i64) == 11
    doAssert st[8'i64] == 0
    doAssert st.get_all() == 22
    doAssert st[low(int64)..high(int64)] == 22
    doAssert st.get(9'i64, 9'i64) == 0
    doAssert st[10'i64..<10'i64] == 0
    var rejected = false
    try: st[8'i64] = 1
    except AssertionDefect: rejected = true
    doAssert rejected

block:
    let st = initCompressedSegmentTree(newSeq[int](), merge, 0'i64)
    doAssert st.len == 0 and st.get_all() == 0
    doAssert st.get(-100, 100) == 0 and st[0] == 0

block:
    proc concat(x, y: string): string = x & y
    let st = initCompressedSegmentTree(["z", "a", "m", "a"], concat, "",
        proc(x: string): string = x)
    doAssert st.get_all() == "amz"
    doAssert st.get("b", "zz") == "mz"
    st["m"] = "M"
    doAssert st["a".."m"] == "aM"

block:
    var rng = initRand(20260914)
    for n in 0..40:
        var coords: seq[int] = @[]
        for i in 0..<n: coords.add(i * 7 - 100)
        let st = initCompressedSegmentTree(coords, merge, 0'i64)
        var values = newSeq[int64](n)
        for step in 0..<300:
            if n > 0 and rng.rand(2) == 0:
                let i = rng.rand(n - 1)
                values[i] = int64(rng.rand(-100..100))
                st[coords[i]] = values[i]
                doAssert st[coords[i]] == values[i]
            var l = rng.rand(-120..220)
            var r = rng.rand(-120..220)
            if r < l: swap(l, r)
            var expected, total: int64
            for i, x in coords:
                total += values[i]
                if l <= x and x < r: expected += values[i]
            doAssert st.get(l, r) == expected
            doAssert st.get_all() == total

echo "Hello World"
