# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/compressed_segtree
import random, algorithm

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

block:
    let st = newCompressedSegWith([30, 10, 20, 10], l & r, "",
        proc(x: int): string = $x)
    doAssert $st == "10 20 30"
    doAssert st[10..20] == "1020"
    let empty = newCompressedSegWith(newSeq[int](), l + r, 0)
    doAssert $empty == ""

block:
    proc concat(x, y: string): string = x & y
    for n in 0..17:
        var coords: seq[int] = @[]
        for i in countdown(n - 1, 0):
            coords.add(i * 3)
            coords.add(i * 3)
        let original = coords
        let st = initCompressedSegmentTree(coords, concat, "",
            proc(x: int): string = "[" & $x & "]")
        doAssert coords == original
        doAssert st.len == n
        for pass in 0..1:
            for l in -2..(n * 3 + 2):
                for r in l..(n * 3 + 2):
                    var halfOpen, closed: string
                    for i in 0..<n:
                        let x = i * 3
                        let value = if pass == 0: "[" & $x & "]" else: "<" & $x & ">"
                        if l <= x and x < r: halfOpen.add(value)
                        if l <= x and x <= r: closed.add(value)
                    doAssert st.get(l, r) == halfOpen
                    doAssert st[l..r] == closed
                    doAssert st[(r + 1)..l] == ""
            for i in 0..<n: st[i * 3] = "<" & $(i * 3) & ">"

block:
    proc checkClosure(separator: string) =
        proc concat(x, y: string): string =
            if x.len == 0: y
            elif y.len == 0: x
            else: x & separator & y
        let st = initCompressedSegmentTree([0, 2, 4, 6, 8], concat, "",
            proc(x: int): string = $x)
        doAssert st.get(1, 7) == "2" & separator & "4" & separator & "6"
        st[4] = "x"
        doAssert st[2..6] == "2" & separator & "x" & separator & "6"
    checkClosure(":")

proc checkIntegerCoordinates[K: SomeInteger](coords: seq[K]) =
    let original = coords
    var sorted = coords
    sorted.sort()
    var unique: seq[K]
    for x in sorted:
        if unique.len == 0 or unique[^1] != x: unique.add(x)
    let ordinary = initCompressedSegmentTree(coords, merge, 0'i64)
    let specialized: CompressedSegmentTree[K, int64] = newCompressedSegWith(coords, l + r, 0'i64)
    for st in [ordinary, specialized]:
        doAssert st.len == unique.len
        for i, x in unique:
            st[x] = int64(i + 1)
        for i, x in unique:
            doAssert st[x] == int64(i + 1)
            doAssert st[x..x] == int64(i + 1)
        doAssert st.get_all() == int64(unique.len * (unique.len + 1) div 2)
        for i in countup(0, unique.len - 1, 31):
            let j = min(i + 57, unique.len - 1)
            doAssert st.get(unique[i], unique[j]) == int64((i + 1 + j) * (j - i) div 2)
    doAssert coords == original

block:
    var rng = initRand(129734)
    var signed: seq[int64] = @[low(int64), high(int64), -1'i64, 0'i64]
    var unsigned: seq[uint64] = @[low(uint64), high(uint64), 1u64 shl 63]
    var small: seq[int8]
    for i in 0..<6000:
        let bits = (uint64(rng.rand(high(int32))) shl 33) or uint64(rng.rand(high(int32)))
        signed.add(cast[int64](bits))
        unsigned.add(bits)
        small.add(cast[int8](i and 255))
    checkIntegerCoordinates(signed)
    checkIntegerCoordinates(unsigned)
    checkIntegerCoordinates(small)
    checkIntegerCoordinates(@[3'i16, -2'i16, low(int16), high(int16)])
    checkIntegerCoordinates(@[3'u16, 0'u16, high(uint16)])
    checkIntegerCoordinates(@[3'i32, -2'i32, low(int32), high(int32)])
    checkIntegerCoordinates(@[3'u32, 0'u32, high(uint32)])
    for n in [63, 64, 65, 2047, 2048, 2049]:
        var coords: seq[int]
        for i in countdown(n - 1, 0): coords.add(i * 11)
        checkIntegerCoordinates(coords)
        let st = newCompressedSegWith(coords, l + r, 0)
        doAssert st[-1] == 0 and st[1] == 0 and st[n * 11] == 0
        var rejected = false
        try: st[1] = 10
        except AssertionDefect: rejected = true
        doAssert rejected

block:
    proc make(separator: string): CompressedSegmentTree[int, string] =
        newCompressedSegWith([0, 2, 4, 6, 8],
            (if l == "": r elif r == "": l else: l & separator & r), "",
            proc(x: int): string = $x)
    let a = make(":")
    let b = make("/")
    for st in [a, b]:
        st[4] = "X"
    doAssert a.get(1, 7) == "2:X:6"
    doAssert b[2..6] == "2/X/6"
    doAssert a.get_all() == "0:2:X:6:8"
    doAssert b.get_all() == "0/2/X/6/8"
    let empty: CompressedSegmentTree[int, int] = newCompressedSegWith(newSeq[int](), l + r, 0)
    doAssert empty.get(-1, 1) == 0 and empty[-1..1] == 0

block:
    let coords = @[
        54, 58, 168, 407, 752, 792, 967, 1039,
        1050, 1100, 1161, 1197, 1310, 1381, 1768, 2025,
        2102, 2271, 2321, 2398, 2738, 3205, 3527, 3580,
        3920, 4018, 4468, 4583, 4617, 4755, 4798, 5289,
        5311, 5456, 5468, 5493, 5712, 5773, 5869, 5973,
        6137, 6218, 6404, 6605, 6622, 6712, 6864, 7018,
        7337, 7389, 7434, 7668, 7824, 7896, 7942, 8182,
        8204, 8229, 8532, 8542, 8831, 8931, 9087, 9444
    ]
    checkIntegerCoordinates(coords)
    let st = newCompressedSegWith(coords, l + r, 0)
    doAssert st[9474] == 0

echo "Hello World"
