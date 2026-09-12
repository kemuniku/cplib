# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, algorithm
import cplib/collections/bitset_binary_trie
when defined(cpp):
    import cplib/collections/bitset as scalar
    import cplib/collections/staticbitset as fixed
import cplib/collections/bitset_avx2 as avx2
import cplib/collections/bitset_avx512 as avx512
import cplib/collections/staticbitset_avx2 as fixed2
import cplib/collections/staticbitset_avx512 as fixed512

proc compare[T, U](a: T, b: U): int =
    for i in 0..<a.len:
        if a[i] != b[i]:
            return if a[i]: 1 else: -1

proc makeKey[T](sample: T, bits: seq[bool]): T =
    result = sample
    for i in 0..<bits.len:
        result[i] = bits[i]

proc test[T](sample: T) =
    var trie = initBitSetBinaryTrie(sample)
    var explicitTrie = initBitSetBinaryTrie[T](sample.len)
    explicitTrie.incl(sample)
    doAssert explicitTrie.count(sample) == 1
    var expected: seq[seq[bool]]
    var rng = initRand(8247)

    proc checkState(query, mask: T) =
        doAssert trie.len == expected.len
        var expectedCount, lower, upper, xorLower, xorUpper: int
        for key in expected:
            let order = compare(key, query)
            expectedCount += ord(order == 0)
            lower += ord(order < 0)
            upper += ord(order <= 0)
            var xorOrder = 0
            for i in 0..<query.len:
                let bit = key[i] xor mask[i]
                if bit != query[i]:
                    xorOrder = if bit: 1 else: -1
                    break
            xorLower += ord(xorOrder < 0)
            xorUpper += ord(xorOrder <= 0)
        doAssert trie.count(query) == expectedCount
        doAssert (query in trie) == (expectedCount > 0)
        doAssert trie.lowerBound(query) == lower
        doAssert trie.upperBound(query) == upper
        doAssert trie.lowerBound(query, mask) == xorLower
        doAssert trie.upperBound(query, mask) == xorUpper
        var ordered = newSeq[int](expected.len)
        for i in 0..<ordered.len:
            ordered[i] = i
        ordered.sort(proc(a, b: int): int = compare(expected[a], expected[b]))
        for i in 0..<ordered.len:
            doAssert compare(trie[i], expected[ordered[i]]) == 0
        ordered.sort(proc(a, b: int): int =
            for i in 0..<mask.len:
                let abit = expected[a][i] xor mask[i]
                let bbit = expected[b][i] xor mask[i]
                if abit != bbit:
                    return if abit: 1 else: -1)
        for i in 0..<ordered.len:
            doAssert compare(trie.get_kth(i, mask), expected[ordered[i]]) == 0
        var raised = false
        try:
            discard trie.get_kth(expected.len)
        except IndexDefect:
            raised = true
        doAssert raised

    checkState(sample, sample)
    for bit in [0, 63, 64, 255, 256, 511, 512, sample.len - 1]:
        if bit >= 0 and bit < sample.len:
            var key = sample
            key[bit] = true
            trie.incl(key)
            var bits = newSeq[bool](sample.len)
            bits[bit] = true
            expected.add(bits)
            checkState(key, key)
    for step in 0..<120:
        var key = sample
        var mask = sample
        for i in 0..<sample.len:
            key[i] = rng.rand(1) == 1
            mask[i] = rng.rand(1) == 1
        if step mod 3 != 0 or expected.len == 0:
            let copies = rng.rand(2) + 1
            trie.incl(key, copies)
            var bits = newSeq[bool](sample.len)
            for i in 0..<sample.len:
                bits[i] = key[i]
            for j in 0..<copies:
                expected.add(bits)
        else:
            let index = rng.rand(expected.high)
            key = makeKey(sample, expected[index])
            trie.excl(key)
            expected.delete(index)
        checkState(key, mask)
        checkState(mask, mask)
        for invalid in [-1, trie.count(key) + 1]:
            var raised = false
            try:
                trie.excl(key, invalid)
            except ValueError:
                raised = true
            doAssert raised
            checkState(key, mask)
    while expected.len > 0:
        trie.excl(makeKey(sample, expected.pop()))
    checkState(sample, sample)
    trie.incl(sample, 3)
    trie.excl(sample, 3)
    trie.incl(sample)
    doAssert compare(trie[0], sample) == 0
    var inserted = sample
    trie.excl(sample)
    trie.incl(inserted)
    if sample.len > 0:
        inserted[0] = not inserted[0]
        doAssert compare(trie[0], sample) == 0
        var retrieved = trie[0]
        retrieved[0] = not retrieved[0]
        doAssert compare(trie[0], sample) == 0
    trie.excl(sample)
    trie.incl(sample, 0)
    trie.excl(sample, 0)
    doAssert trie.len == 0
    var raised = false
    try:
        trie.incl(sample, -1)
    except ValueError:
        raised = true
    doAssert raised
    trie.incl(sample, high(int))
    raised = false
    try:
        trie.incl(sample)
    except OverflowDefect:
        raised = true
    doAssert raised and trie.len == high(int)
    trie.excl(sample, high(int))
    doAssert trie.len == 0

template testSize(n: static int) =
    when defined(cpp):
        test(scalar.initBitSet(n))
        test(fixed.initBitSet(n))
    test(avx2.initBitSet(n))
    test(avx512.initBitSet(n))
    test(fixed2.initBitSet(n))
    test(fixed512.initBitSet(n))

testSize(0)
testSize(1)
testSize(65)
testSize(513)

block:
    var trie = initBitSetBinaryTrie[avx2.BitSetAvx2](100000)
    var key = avx2.initBitSet(100000)
    key[99999] = true
    for i in 0..<3:
        trie.incl(key)
        doAssert trie.count(key) == 1
        doAssert compare(trie[0], key) == 0
        trie.excl(key)
        doAssert trie.len == 0
    var raised = false
    try:
        trie.incl(avx2.initBitSet(1))
    except ValueError:
        raised = true
    doAssert raised and trie.len == 0
    raised = false
    try:
        discard initBitSetBinaryTrie[avx2.BitSetAvx2](-1)
    except ValueError:
        raised = true
    doAssert raised

echo "Hello World"
