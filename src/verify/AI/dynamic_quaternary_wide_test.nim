# verification-helper: IGNORE
import cplib/collections/dynamic_quaternary_vector
import cplib/collections/dynamic_quaternary_waveletmatrix
import cplib/collections/dynamic_bplus_kernels
import algorithm, options, random

const quadTestWords {.intdefine.} = 256
const capacity = quadTestWords * 32
type WideVector = QuadVector[32, quadTestWords]
type WideMatrix = DynamicQuadWaveletMatrix[WideVector]
type Counts = array[4, int]
static: doAssert quadTestWords in [256, 512]

template rejects(error: typedesc, body: untyped) =
    block:
        var caught = false
        try: body
        except error: caught = true
        doAssert caught

proc checkVector(t: WideVector, a: seq[int]) =
    t.validate()
    doAssert t.len == a.len
    var points = @[0, 1, 31, 32, 33, 127, 128, 129, 255, 256, 257,
        511, 512, 513, 1023, 1024, 1025, capacity div 2 - 1,
        capacity div 2, capacity div 2 + 1, capacity - 1, capacity,
        capacity + 1, a.len div 2, a.len - 1, a.len]
    for leaf in 1..32:
        for delta in -1..1: points.add(leaf * capacity + delta)
    points.sort()
    var counts: Counts
    var first, last: Counts
    for d in 0..3:
        first[d] = -1
        last[d] = -1
    var next = 0
    for p in 0..a.len:
        while next < points.len and points[next] < p: inc next
        if next < points.len and points[next] == p:
            doAssert t.ranks(p) == counts
            doAssert t.ranksPair(0, p) == (default(Counts), counts)
            doAssert t.ranksPair(p, p) == (counts, counts)
            for d in 0..3:
                doAssert t.rank(p, d) == counts[d]
                doAssert t.rankPair(0, p, d) == (0, counts[d])
            if p < a.len:
                doAssert t[p] == a[p]
                doAssert t.rankAccess(p) == (counts[a[p]], a[p])
        if p < a.len:
            let d = a[p]
            if first[d] < 0: first[d] = p
            last[d] = p
            inc counts[d]
    for d in 0..3:
        doAssert t.total(d) == counts[d]
        doAssert t.select(d, 0) == first[d]
        doAssert t.select(d, counts[d] - 1) == last[d]
        doAssert t.select(d, -1) == -1
        doAssert t.select(d, counts[d]) == -1

proc replaceChecked(t: WideVector, a: var seq[int], p, d: int) =
    var counts: Counts
    for i in 0..<p: inc counts[a[i]]
    let old = a[p]
    doAssert t.replaceRank(p, d) == (old, counts[old], counts[d])
    a[p] = d
    doAssert t[p] == d

proc checkVectorStructure(kernel: BPlusKernel) =
    block:
        var a = newSeq[int](capacity)
        for x in a.mitems: x = 3
        let t = initQuadVector(WideVector, a, kernel)
        var splitBytes, mergedBytes: int
        for turn in 0..<(if defined(dynamicWmFullTest): 24 else: 6):
            let p = [0, 31, 32, capacity div 2, capacity - 1, capacity][turn mod 6]
            doAssert t.insert(p, 3) == p
            a.insert(3, p)
            checkVector(t, a)
            if turn == 0: splitBytes = t.storageBytes
            else: doAssert t.storageBytes == splitBytes
            # 左葉を下限未満にして、毎回確実に併合・根の縮退まで戻す。
            doAssert t.erase(0) == (0, 3)
            a.delete(0)
            checkVector(t, a)
            if turn == 0: mergedBytes = t.storageBytes
            else: doAssert t.storageBytes == mergedBytes
            t.replaceChecked(a, p mod capacity, 0)
            t.replaceChecked(a, p mod capacity, 0)
            t.replaceChecked(a, p mod capacity, 3)
    block:
        # 満杯の32葉を持つ根から1葉を分割し、根の昇格・縮退を往復する。
        var a = newSeq[int](32 * capacity)
        for i in 0..<a.len: a[i] = (i * 17 + i div 7) and 3
        let t = initQuadVector(WideVector, a, kernel)
        checkVector(t, a)
        for turn in 0..<(if defined(dynamicWmFullTest): 8 else: 2):
            doAssert t.insert(0, turn mod 4) == 0
            a.insert(turn mod 4, 0)
            checkVector(t, a)
            doAssert t.erase(0) == (0, turn mod 4)
            a.delete(0)
            checkVector(t, a)
        for p in [0, capacity div 2 - 1, capacity div 2, capacity - 1,
                  capacity, capacity + 1, a.len div 2, a.len - 1]:
            let old = a[p]
            t.replaceChecked(a, p, (old + 1) mod 4)
            t.replaceChecked(a, p, (old + 1) mod 4)
            t.replaceChecked(a, p, old)
        checkVector(t, a)
    block:
        var a = newSeq[int](capacity + capacity div 2)
        for i in 0..<a.len: a[i] = (i * 13 + i div 11) and 3
        let t = initQuadVector(WideVector, a, kernel)
        let initialBytes = t.storageBytes
        # 左葉を下限未満にして再分配を起こす。oracleの先頭削除は最後にまとめる。
        let removed = capacity div 4 + 1
        for p in 0..<removed: doAssert t.erase(0) == (0, a[p])
        a = a[removed..^1]
        checkVector(t, a)
        var counts: Counts
        for d in a: inc counts[d]
        while a.len > 0:
            let d = a[^1]
            doAssert t.erase(a.len - 1) == (counts[d] - 1, d)
            dec counts[d]
            a.setLen(a.len - 1)
            if a.len in [capacity, capacity div 2, 33, 32, 1, 0]: checkVector(t, a)
        # 空列まで縮退したpoolを再び使い、再割当てでノード数が増えないことを確認する。
        for i in 0..capacity:
            let d = i mod 4
            doAssert t.insert(a.len, d) == counts[d]
            inc counts[d]
            a.add(d)
        checkVector(t, a)
        doAssert t.storageBytes == initialBytes

proc checkVectorAssertions(kernel: BPlusKernel) =
    rejects(AssertionDefect): discard initQuadVector(WideVector, @[-1], kernel)
    rejects(AssertionDefect): discard initQuadVector(WideVector, @[4], kernel)
    let t = initQuadVector(WideVector, newSeq[int](), kernel)
    rejects(AssertionDefect): discard t[0]
    rejects(AssertionDefect): discard t.erase(0)
    rejects(AssertionDefect): discard t.replaceRank(0, 0)
    rejects(AssertionDefect): discard t.insert(-1, 0)
    rejects(AssertionDefect): discard t.insert(1, 0)
    rejects(AssertionDefect): discard t.insert(0, -1)
    rejects(AssertionDefect): discard t.insert(0, 4)
    rejects(AssertionDefect): discard t.rank(-1, 0)
    rejects(AssertionDefect): discard t.rank(1, 0)
    rejects(AssertionDefect): discard t.rank(0, 4)
    rejects(AssertionDefect): discard t.ranks(1)
    rejects(AssertionDefect): discard t.ranksPair(0, 1)
    rejects(AssertionDefect): discard t.rankPair(-1, 0, 0)
    rejects(AssertionDefect): discard t.total(-1)
    rejects(AssertionDefect): discard t.select(4, 0)
    doAssert t.insert(0, 2) == 0
    rejects(AssertionDefect): discard t.replaceRank(-1, 0)
    rejects(AssertionDefect): discard t.replaceRank(1, 0)
    rejects(AssertionDefect): discard t.replaceRank(0, -1)
    rejects(AssertionDefect): discard t.replaceRank(0, 4)
    doAssert t.replaceRank(0, 2) == (2, 0, 0)
    checkVector(t, @[2])

proc checkWideMatrix(w: WideMatrix, a: seq[int], p, width: int) =
    w.validate()
    doAssert w.len == a.len
    let maximum = (1 shl width) - 1
    let position = min(p, a.len)
    var prefix, totals: array[128, int]
    for i, value in a:
        inc totals[value]
        if i < position: inc prefix[value]
    for i in [0, position - 1, position, position + 1, a.len - 1]:
        if 0 <= i and i < a.len: doAssert w[i] == a[i]
    let sample = if position < a.len: a[position] else: 0
    let thresholds = [-1, 0, sample, maximum, maximum + 1]
    for x in thresholds:
        let expectedPrefix = if 0 <= x and x <= maximum: prefix[x] else: 0
        let expectedTotal = if 0 <= x and x <= maximum: totals[x] else: 0
        doAssert w.rank(position, x) == expectedPrefix
        doAssert w.rank(a.len, x) == expectedTotal
    for bounds in [(0, a.len), (max(0, position - 33), min(a.len, position + 34)),
                   (position, position)]:
        let (l, r) = bounds
        var counts: array[128, int]
        for i in l..<r: inc counts[a[i]]
        if l < r:
            for k in [0, (r - l) div 2, r - l - 1]:
                var remaining = k
                var expected = 0
                while remaining >= counts[expected]:
                    remaining -= counts[expected]
                    inc expected
                doAssert w.kth_smallest(l, r, k) == expected
                doAssert w.kth_largest(l, r, r - l - 1 - k) == expected
        for j, x in thresholds:
            let high = thresholds[(j + 1) mod thresholds.len]
            var less, equal, interval: int
            var previous, following: Option[int]
            for value in 0..maximum:
                if value < x: less += counts[value]
                if value == x: equal = counts[value]
                if x <= value and value < high: interval += counts[value]
                if counts[value] > 0:
                    if value < x: previous = some(value)
                    if value >= x and following.isNone: following = some(value)
            doAssert w.count(l, r, x) == equal
            doAssert w.range_lowerbound(l, r, x) == less
            doAssert w.range_freq(l, r, x, high) == interval
            doAssert w.prev_value(l, r, x) == previous
            doAssert w.next_value(l, r, x) == following

proc checkWideMatrixUpdates(kernel: BPlusKernel) =
    # 葉容量を超えるWMで、異なる層の位置移動と境界queryを少数の更新から検査する。
    for width in [5, 7]:
        let maximum = (1 shl width) - 1
        var rng = initRand(5137 + quadTestWords + width)
        var a = newSeq[int](capacity + 5)
        for i in 0..<a.len:
            a[i] = if width == 5: (i * 7 + i div 32) and maximum else: rng.rand(maximum)
        let w = initDynamicQuadWaveletMatrix(a, WideVector, H = width, kernel = kernel)
        let leafBoundary = (a.len + 1) div 2
        checkWideMatrix(w, a, leafBoundary, width)
        for step in 0..<(if defined(dynamicWmFullTest): 48 else: 24):
            let points = [0, 31, 32, 33, 511, 512, 513, 32 * quadPrefixWords - 1,
                32 * quadPrefixWords, 32 * quadPrefixWords + 1,
                leafBoundary - 1, leafBoundary, leafBoundary + 1,
                capacity - 1, capacity, capacity + 1, a.len]
            let kind = step mod 3
            let p = min(points[step mod points.len], a.len - int(kind != 0))
            let value = if step mod 4 == 0: 0 elif step mod 4 == 1: maximum
                else: rng.rand(maximum)
            case kind
            of 0:
                w.insert(p, value)
                a.insert(value, p)
            of 1:
                doAssert w.erase(p) == a[p]
                a.delete(p)
            else:
                w[p] = value
                a[p] = value
            checkWideMatrix(w, a, p, width)

for kernel in [bpkScalar, bpkAvx2, bpkAvx512]:
    if kernelAvailable(kernel):
        checkVectorAssertions(kernel)
        checkVectorStructure(kernel)
        checkWideMatrixUpdates(kernel)
echo "Hello World"
