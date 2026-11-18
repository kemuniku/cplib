# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/dynamic_quaternary_kernels
import cplib/collections/dynamic_bplus_kernels
import algorithm, random

const maxDigits = 16385
const wordGuard = 0xa54ff53a5f1d36f1'u64
const countGuard = 0x23456789'i32
type Counts = array[4, int]

proc addPosition(points: var seq[int], p, n: int) =
    if 0 <= p and p <= n and p notin points: points.add(p)

proc boundaryPositions(n: int): seq[int] =
    for p in [0, 1, 31, 32, 33, 63, 64, 65, 127, 128, 129,
              255, 256, 257, 511, 512, 513, 1023, 1024, 1025,
              4095, 4096, 4097, 8191, 8192, 8193, 16383, 16384,
              16385, n div 2 - 1, n div 2, n div 2 + 1, n - 1, n]:
        result.addPosition(p, n)
    result.sort()

proc pack(values: seq[int], capacity: int): seq[uint64] =
    doAssert capacity >= values.len
    let words = (max(1, capacity) + 31) div 32 + 1
    result = newSeq[uint64](words + 2)
    result[0] = wordGuard
    result[^1] = wordGuard
    for i, digit in values:
        result[1 + i div 32] = result[1 + i div 32] or
            (uint64(digit) shl (2 * (i mod 32)))

proc checkStorage(storage: seq[uint64], values: seq[int]) =
    doAssert storage[0] == wordGuard and storage[^1] == wordGuard
    for word in 0..<storage.len - 2:
        var expected = 0'u64
        for j in 0..<32:
            let p = word * 32 + j
            if p < values.len:
                expected = expected or (uint64(values[p]) shl (2 * j))
        doAssert storage[1 + word] == expected

proc checkRankVariants(storage: var seq[uint64], p: int, expected: Counts, mode: cint) =
    var legacy, base, fast: array[6, cint]
    for i in 0..5:
        legacy[i] = cint(countGuard)
        base[i] = cint(countGuard)
        fast[i] = cint(countGuard)
    quadRanksRaw(addr storage[1], cint(p), addr legacy[1])
    quadRanksBaseRaw(addr storage[1], cint(p), addr base[1])
    quadRanksFastRaw(addr storage[1], cint(p), addr fast[1])
    for d in 0..3:
        doAssert quadRankRaw(addr storage[1], cint(p), cint(d), mode) == cint(expected[d])
        doAssert quadRankBaseRaw(addr storage[1], cint(p), cint(d), mode) == cint(expected[d])
        doAssert quadRankFastRaw(addr storage[1], cint(p), cint(d), mode) == cint(expected[d])
        doAssert legacy[d + 1] == cint(expected[d])
        doAssert base[d + 1] == cint(expected[d])
        doAssert fast[d + 1] == cint(expected[d])
    for i in [0, 5]:
        doAssert legacy[i] == cint(countGuard)
        doAssert base[i] == cint(countGuard)
        doAssert fast[i] == cint(countGuard)

proc checkTotal(storage: var seq[uint64], values: seq[int], mode: cint) =
    var expected: Counts
    for d in values: inc expected[d]
    checkRankVariants(storage, values.len, expected, mode)

proc checkPrefixKernels(kernel: BPlusKernel) =
    let mode = cint(ord(kernel) + 1)
    var rng = initRand(752091)
    for n in 0..32:
        var padded: array[34, int32]
        padded[0] = countGuard
        padded[^1] = countGuard
        var total = 0
        for i in 0..<32:
            total += rng.rand(3)
            padded[i+1] = if i < n: int32(total) else: int32(rng.rand(200)-100)
        for x in -1..total+1:
            var expected = 0
            while expected < n and padded[expected+1] <= int32(x): inc expected
            doAssert quadPrefixFind32Raw(addr padded[1], cint(n), cint(x), mode) == cint(expected)
        doAssert padded[0] == countGuard and padded[^1] == countGuard
    var lengths = @[0, 1, 7, 8, 9, 15, 16, 17, 31, 32, 33, 63, 64, 65, 127, 128, 129]
    when defined(dynamicWmFullTest):
        lengths.setLen(0)
        for n in 0..129: lengths.add(n)
    for n in lengths:
        for pattern in 0..3:
            var a = newSeq[int32](n + 2)
            var b = newSeq[int32](n + 2)
            a[0] = countGuard
            a[^1] = countGuard
            b[0] = -countGuard
            b[^1] = -countGuard
            var total = 0
            for i in 0..<n:
                total += (if pattern == 0: 0 elif pattern == 1: 1
                          elif pattern == 2: i mod 4 else: rng.rand(5))
                a[i + 1] = int32(total)
                b[i + 1] = int32(1000 + total * 2)
            var targets = @[-1, 0, total, total + 1]
            when defined(dynamicWmFullTest):
                targets.setLen(0)
                for x in -1..total + 1: targets.add(x)
            else:
                for p in boundaryPositions(n):
                    if p < n:
                        targets.add(int(a[p + 1]) - 1)
                        targets.add(int(a[p + 1]))
            for x in targets:
                var expected = 0
                while expected < n and a[expected + 1] <= int32(x): inc expected
                doAssert quadPrefixFindRaw(addr a[1], cint(n), cint(x), mode) == cint(expected)
            var starts = @[0, n div 2, n]
            when defined(dynamicWmFullTest):
                starts.setLen(0)
                for p in 0..n: starts.add(p)
            for first in starts:
                for delta in [-1, 1]:
                    var oldA = newSeq[int32](a.len)
                    var oldB = newSeq[int32](b.len)
                    for i in 0..<a.len:
                        oldA[i] = a[i]
                        oldB[i] = b[i]
                    quadPrefixAddPairRaw(addr a[first + 1], addr b[first + 1],
                        cint(n - first), cint(delta), mode)
                    for i in 0..<a.len:
                        let change = if first + 1 <= i and i <= n: int32(delta) else: 0'i32
                        doAssert a[i] == oldA[i] + change
                        doAssert b[i] == oldB[i] + change
    var extremes = @[countGuard, int32.low, -1'i32, 0'i32, int32.high, countGuard]
    for x in [int32.low, -1'i32, 0'i32, int32.high]:
        var expected = 0
        while expected < 4 and extremes[expected + 1] <= x: inc expected
        doAssert quadPrefixFindRaw(addr extremes[1], 4, cint(x), mode) == cint(expected)
    doAssert extremes[0] == countGuard and extremes[^1] == countGuard

proc checkPackedRanks(kernel: BPlusKernel) =
    let mode = cint(ord(kernel) + 1)
    var rng = initRand(9451307)
    var positions = boundaryPositions(maxDigits)
    # SIMDへの切替えと4/8ワード走査の全端数を通す。
    for words in 0..17:
        for delta in [-1, 0, 1, 31]: positions.addPosition(words * 32 + delta, maxDigits)
    positions.sort()
    when defined(dynamicWmFullTest):
        positions.setLen(0)
        for p in 0..maxDigits: positions.add(p)
    for pattern in 0..4:
        var values = newSeq[int](maxDigits)
        var prefix = newSeq[Counts](maxDigits + 1)
        for i in 0..<maxDigits:
            values[i] = if pattern < 4: pattern else: rng.rand(3)
            prefix[i + 1] = prefix[i]
            inc prefix[i + 1][values[i]]
        var storage = pack(values, maxDigits)
        # 有効桁より上を汚して、末尾maskと境界wordの読取りを検査する。
        storage[1 + maxDigits div 32] = storage[1 + maxDigits div 32] or (not 3'u64)
        storage[^2] = not 0'u64
        for p in positions:
            checkRankVariants(storage, p, prefix[p], mode)
            var left, right: array[4, cint]
            let l = p div 2
            quadRanksPairRaw(addr storage[1], cint(l), cint(p), addr left[0], addr right[0])
            for d in 0..3:
                doAssert left[d] == cint(prefix[l][d])
                doAssert right[d] == cint(prefix[p][d])
        doAssert storage[0] == wordGuard and storage[^1] == wordGuard

proc checkPackedEdits(kernel: BPlusKernel) =
    let mode = cint(ord(kernel) + 1)
    var rng = initRand(391022)
    var lengths = @[0, 1, 31, 32, 33, 255, 256, 257, 8192, 16384, 16385]
    when defined(dynamicWmFullTest):
        lengths = @[0, 1, 31, 32, 33, 127, 128, 129, 255, 256, 257,
            4095, 4096, 4097, 8191, 8192, 8193, 16383, 16384, 16385]
    for n in lengths:
        var positions = @[0, n div 2, n]
        when defined(dynamicWmFullTest):
            positions = boundaryPositions(n)
            if n <= 257:
                positions.setLen(0)
                for p in 0..n: positions.add(p)
            for words in [0, 1, 3, 4, 5, 7, 8, 9, 15, 16, 17]:
                for delta in -1..1: positions.addPosition((n div 32 - words) * 32 + delta, n)
        else:
            for p in [31, 32, 33, n - 1]: positions.addPosition(p, n)
        for pattern in 0..(if defined(dynamicWmFullTest): 4 else: 1):
            var values = newSeq[int](n)
            for i in 0..<n:
                values[i] = if pattern == 0: 3 elif pattern == 1: rng.rand(3) else: pattern - 2
            for p in positions:
                if n < maxDigits:
                    for d in 0..(if defined(dynamicWmFullTest): 3 else: 0):
                        var storage = pack(values, n + 1)
                        var expected = newSeq[int](n + 1)
                        for i in 0..<p: expected[i] = values[i]
                        expected[p] = d
                        for i in p..<n: expected[i + 1] = values[i]
                        quadInsertRaw(addr storage[1], cint(n), cint(p), cint(d), mode)
                        checkStorage(storage, expected)
                        checkTotal(storage, expected, mode)
                        quadEraseRaw(addr storage[1], cint(n + 1), cint(p), mode)
                        checkStorage(storage, values)
                if p < n:
                    var storage = pack(values, n)
                    var expected = newSeq[int](n - 1)
                    for i in 0..<p: expected[i] = values[i]
                    for i in p + 1..<n: expected[i - 1] = values[i]
                    quadEraseRaw(addr storage[1], cint(n), cint(p), mode)
                    checkStorage(storage, expected)
                    checkTotal(storage, expected, mode)

proc checkPlaneEdits(kernel: BPlusKernel) =
    let mode = cint(ord(kernel)+1)
    var rng = initRand(512343)
    for n in [0, 1, 63, 64, 65, 447, 448, 449, 511, 512, 513,
              575, 576, 577, 1023, 1024, 1025, 8191, 8192, 8193, 16384]:
        let words = (n+1+63) div 64+1
        for pattern in 0..(if defined(dynamicWmFullTest): 4 else: 1):
            var values = newSeq[int](n)
            for i in 0..<n:
                values[i] = if pattern == 0: 3 elif pattern == 1: rng.rand(3) else: pattern-2
            var positions = boundaryPositions(n)
            for k in 0..17:
                for delta in -1..1:
                    positions.addPosition((n div 64-k)*64+delta, n)
            proc packed(): tuple[low, high: seq[uint64], prefix: seq[uint16]] =
                result.low = newSeq[uint64](words+2)
                result.high = newSeq[uint64](words+2)
                result.prefix = newSeq[uint16](4*(words+2))
                result.low[0] = wordGuard
                result.low[^1] = wordGuard
                result.high[0] = wordGuard
                result.high[^1] = wordGuard
                for d in 0..3:
                    result.prefix[d] = 0x6aed'u16
                    result.prefix[result.prefix.len-4+d] = 0x6aed'u16
                var counts: array[4, uint16]
                for i, d in values:
                    if i mod 64 == 0:
                        for k in 0..3: result.prefix[4*(1+i div 64)+k] = counts[k]
                    result.low[1+i div 64] = result.low[1+i div 64] or (uint64(d and 1) shl (i mod 64))
                    result.high[1+i div 64] = result.high[1+i div 64] or (uint64(d shr 1) shl (i mod 64))
                    inc counts[d]
                if n mod 64 == 0:
                    for d in 0..3: result.prefix[4*(1+n div 64)+d] = counts[d]
            proc check(low, high: seq[uint64], prefix: seq[uint16], expected: seq[int]) =
                doAssert low[0] == wordGuard and low[^1] == wordGuard
                doAssert high[0] == wordGuard and high[^1] == wordGuard
                for d in 0..3:
                    doAssert prefix[d] == 0x6aed'u16
                    doAssert prefix[prefix.len-4+d] == 0x6aed'u16
                var counts: array[4, uint16]
                for w in 0..<words:
                    if w*64 < expected.len:
                        for d in 0..3: doAssert prefix[4*(1+w)+d] == counts[d]
                    var a, b: uint64
                    for j in 0..<64:
                        let p = w*64+j
                        if p < expected.len:
                            let d = expected[p]
                            a = a or (uint64(d and 1) shl j)
                            b = b or (uint64(d shr 1) shl j)
                            inc counts[d]
                    doAssert low[1+w] == a and high[1+w] == b
            for p in positions:
                for d in 0..3:
                    var storage = packed()
                    var expected = newSeq[int](n+1)
                    for i in 0..<p: expected[i] = values[i]
                    expected[p] = d
                    for i in p..<n: expected[i+1] = values[i]
                    quadPlaneInsertRaw(addr storage.low[1], addr storage.high[1], addr storage.prefix[4],
                        cint(n), cint(p), cint(d), mode)
                    check(storage.low, storage.high, storage.prefix, expected)
                if p < n:
                    var storage = packed()
                    var expected = newSeq[int](n-1)
                    for i in 0..<p: expected[i] = values[i]
                    for i in p+1..<n: expected[i-1] = values[i]
                    quadPlaneEraseRaw(addr storage.low[1], addr storage.high[1], addr storage.prefix[4],
                        cint(n), cint(p), cint(values[p]), mode)
                    check(storage.low, storage.high, storage.prefix, expected)

var checked: set[BPlusKernel]
for requested in [bpkScalar, bpkAvx2, bpkAvx512, bpkAuto]:
    let kernel = resolveKernel(requested)
    doAssert kernelAvailable(kernel)
    if requested == bpkAuto or not kernelAvailable(requested):
        doAssert kernel == bpkScalar
    else:
        doAssert kernel == requested
    # Rawには解決済みmodeだけを渡し、未対応ISAを強制実行しない。
    if kernel notin checked:
        checked.incl(kernel)
        checkPrefixKernels(kernel)
        checkPackedRanks(kernel)
        checkPackedEdits(kernel)
        checkPlaneEdits(kernel)
echo "Hello World"
