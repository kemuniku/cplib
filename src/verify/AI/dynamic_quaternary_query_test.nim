# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/dynamic_quaternary_waveletmatrix
import cplib/collections/dynamic_quaternary_vector
import cplib/collections/dynamic_quaternary_kernels
import cplib/collections/dynamic_bplus_kernels
import random, options

type Counts = array[4, int]
var rawChecks, pairChecks, replacementChecks, neighbourChecks: int

proc checkRawPairs() =
    var words: array[4, uint64]
    var prefix: array[129, Counts]
    for i in 0..<128:
        let digit = (i * i + i div 3) mod 4
        words[i shr 5] = words[i shr 5] or (uint64(digit) shl (2 * (i and 31)))
        prefix[i + 1] = prefix[i]
        inc prefix[i + 1][digit]
    for n in [0, 1, 31, 32, 33, 63, 64, 65, 95, 96, 97, 127, 128]:
        for l in 0..n:
            for r in l..n:
                var left, right: array[4, cint]
                quadRanksPairRaw(addr words[0], cint(l), cint(r), addr left[0], addr right[0])
                for d in 0..3:
                    doAssert int(left[d]) == prefix[l][d]
                    doAssert int(right[d]) == prefix[r][d]
                inc rawChecks

proc prefixOf(a: seq[int], p: int): Counts =
    for i in 0..<p: inc result[a[i]]

proc checkVector[B, W](t: QuadVector[B, W], a: seq[int]) =
    t.validate()
    doAssert t.len == a.len
    var prefix = newSeq[Counts](a.len + 1)
    for i, digit in a:
        prefix[i + 1] = prefix[i]
        inc prefix[i + 1][digit]
    var selected = newSeq[bool](a.len + 1)
    proc mark(p: int) =
        if p >= 0 and p <= a.len: selected[p] = true
    for p in [0, 1, 31, 32, 33, 63, 64, 65, W * 16, W * 32,
              W * 64, a.len div 2, a.len - 1, a.len]:
        for delta in -1..1: mark(p + delta)
    let leaves = max(1, (a.len + W * 32 - 1) div (W * 32))
    var boundary = 0
    for leaf in 0..<leaves:
        boundary += a.len div leaves + int(leaf < a.len mod leaves)
        for delta in -1..1: mark(boundary + delta)
    var points: seq[int]
    var ranks: seq[Counts]
    for p in 0..a.len:
        if selected[p]:
            points.add(p)
            ranks.add(t.ranks(p))
            doAssert ranks[^1] == prefix[p]
            if p < a.len: doAssert t[p] == a[p]
    for i, l in points:
        for j in i..<points.len:
            let r = points[j]
            let pair = t.ranksPair(l, r)
            doAssert pair.left == prefix[l] and pair.right == prefix[r]
            doAssert pair.left == ranks[i] and pair.right == ranks[j]
            inc pairChecks
    for d in 0..3:
        doAssert t.total(d) == prefix[^1][d]
        if t.total(d) > 0:
            let first = t.select(d, 0)
            let last = t.select(d, t.total(d) - 1)
            doAssert a[first] == d and prefix[first][d] == 0
            doAssert a[last] == d and prefix[last][d] == t.total(d) - 1

proc runVector[B, W](T: typedesc[QuadVector[B, W]], kernel: BPlusKernel) =
    var rng = initRand(632019 + B + W)
    for n in [0, 1, 31, 32, 33, W * 32 - 1, W * 32, W * 32 + 1,
              W * 64, (B + 1) * W * 32 + 3]:
        var a = newSeq[int](n)
        for x in a.mitems: x = rng.rand(3)
        let t = initQuadVector(T, a, kernel)
        doAssert t.activeKernel == (if kernelAvailable(kernel): kernel else: bpkScalar)
        checkVector(t, a)
        for step in 0..<(if defined(dynamicWmFullTest): 120 else: 36):
            let kind = if a.len == 0: 0 else: step mod 4
            let endPos = a.len - int(kind != 0)
            let p = case step mod 6
                of 0: 0
                of 1: endPos
                of 2: a.len div 2
                of 3: min(32, endPos)
                of 4: min(W * 32, endPos)
                else: rng.rand(endPos)
            let before = prefixOf(a, p)
            case kind
            of 0:
                let digit = rng.rand(3)
                doAssert t.insert(p, digit) == before[digit]
                a.insert(digit, p)
            of 1:
                doAssert t.erase(p) == (before[a[p]], a[p])
                a.delete(p)
            else:
                let oldDigit = a[p]
                let digit = if kind == 3: oldDigit else: (oldDigit + 1 + step mod 3) mod 4
                let replaced = t.replaceRank(p, digit)
                doAssert replaced.oldDigit == oldDigit
                doAssert replaced.oldRank == before[oldDigit]
                doAssert replaced.newRank == before[digit]
                a[p] = digit
                doAssert t[p] == digit
                inc replacementChecks
            if step mod 12 == 11: checkVector(t, a)
        checkVector(t, a)
    for n in [1, W * 32 + 1]:
        for digit in 0..3:
            var a = newSeq[int](n)
            for x in a.mitems: x = digit
            let t = initQuadVector(T, a, kernel)
            checkVector(t, a)
            for p in [0, n div 2, n - 1]:
                doAssert t.replaceRank(p, digit) == (digit, p, p)
                let other = (digit + 1) mod 4
                doAssert t.replaceRank(p, other) == (digit, p, 0)
                a[p] = other
                checkVector(t, a)
                doAssert t.replaceRank(p, digit) == (other, 0, p)
                a[p] = digit
                doAssert t.replaceRank(p, digit) == (digit, p, p)
                checkVector(t, a)
                replacementChecks += 4
    when W == 1:
        var a: seq[int]
        let t = initQuadVector(T, a, kernel)
        for i in 0..<513:
            let p = if i mod 2 == 0: 0 else: a.len
            discard t.insert(p, i mod 4)
            a.insert(i mod 4, p)
            if a.len in [1, 31, 32, 33, 63, 64, 65, 127, 128, 129, 513]: checkVector(t, a)
        while a.len > 0:
            let p = if a.len mod 2 == 0: 0 else: a.len - 1
            discard t.erase(p)
            a.delete(p)
            if a.len in [0, 1, 31, 32, 33, 63, 64, 65, 127, 128, 129]: checkVector(t, a)

proc checkNeighbours[QV](w: DynamicQuadWaveletMatrix[QV], a: seq[int], thresholds: seq[int]) =
    w.validate()
    for l in 0..a.len:
        for r in l..a.len:
            for x in thresholds:
                var previous, next: Option[int]
                for i in l..<r:
                    let y = a[i]
                    if y < x and (previous.isNone or y > previous.get()): previous = some(y)
                    if y >= x and (next.isNone or y < next.get()): next = some(y)
                doAssert w.prev_value(l, r, x) == previous
                doAssert w.next_value(l, r, x) == next
                neighbourChecks += 2

proc runNeighbours(kernel: BPlusKernel) =
    for signed in [false, true]:
        for width in 0..3:
            if signed and width == 0: continue
            let low = if signed: -(1 shl (width - 1)) else: 0
            let count = 1 shl width
            var thresholds: seq[int]
            for x in low - 1..low + count: thresholds.add(x)
            for n in 0..(if defined(dynamicWmFullTest): 4 else: 3):
                for state in 0..<(1 shl (width * n)):
                    var code = state
                    var a = newSeq[int](n)
                    for x in a.mitems:
                        x = low + (code and (count - 1))
                        code = code shr width
                    let w = initDynamicQuadWaveletMatrix(a, H = width, signedValues = signed, kernel = kernel)
                    checkNeighbours(w, a, thresholds)
        for width in [0, 1, 3, 5, 7, 17, 31, 59, 63, 64]:
            if (signed and width == 0) or (not signed and width == 64): continue
            let low = if not signed: 0 elif width == 64: int.low else: -(1 shl (width - 1))
            let high = if width == 64 or (not signed and width == 63): int.high
                elif signed: (1 shl (width - 1)) - 1 else: (1 shl width) - 1
            var alphabet = @[low, high, 0]
            if low < high:
                alphabet.add(low + 1)
                alphabet.add(high - 1)
            if low <= -1: alphabet.add(-1)
            if high >= 1: alphabet.add(1)
            alphabet.add(low div 2)
            alphabet.add(high div 2)
            var thresholds = @[int.low, int.high]
            for value in alphabet:
                thresholds.add(value)
                if value > int.low: thresholds.add(value - 1)
                if value < int.high: thresholds.add(value + 1)
            var a = alphabet
            a.add(high)
            a.add(low)
            let w = initDynamicQuadWaveletMatrix(a, H = width, signedValues = signed, kernel = kernel)
            checkNeighbours(w, a, thresholds)
            for step in 0..<(if defined(dynamicWmFullTest): 60 else: 20):
                let value = alphabet[step mod alphabet.len]
                case step mod 3
                of 0:
                    let p = (step * 7) mod (a.len + 1)
                    w.insert(p, value)
                    a.insert(value, p)
                of 1:
                    let p = (step * 11) mod a.len
                    doAssert w.erase(p) == a[p]
                    a.delete(p)
                else:
                    let p = (step * 13) mod a.len
                    w[p] = value
                    a[p] = value
                if step mod 10 == 9: checkNeighbours(w, a, thresholds)
            while a.len > 0:
                discard w.erase(0)
                a.delete(0)
            checkNeighbours(w, a, thresholds)

checkRawPairs()
for kernel in [bpkScalar, bpkAvx2, bpkAvx512]:
    runVector(QuadVector[4, 1], kernel)
    runVector(QuadVector[16, 64], kernel)
    runVector(QuadVector[24, 64], kernel)
    runVector(QuadVector[32, 128], kernel)
    runNeighbours(kernel)
when defined(dynamicWmFullTest):
    echo "quad focused passed: raw=", rawChecks, " pairs=", pairChecks,
        " replacements=", replacementChecks, " neighbours=", neighbourChecks
echo "Hello World"
