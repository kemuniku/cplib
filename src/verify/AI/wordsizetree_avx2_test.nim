# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
# AVX2対応のCPUが必要です。
import cplib/collections/wordsizetree_avx2
import algorithm, random
for n in [0, 1, 31, 32, 33, 63, 64, 65, 95, 96, 97, 127, 128, 129, 4095, 4096, 4097, 262143, 262144, 262145, 16777216]:
    for pattern in 0..2:
        var v = newSeq[bool](n)
        for i in 0..<n:
            v[i] = pattern == 1 or (pattern == 2 and i mod 67 == 0)
        var tree = initWordsizeTree(v)
        for i in 0..<n:
            doAssert tree[i] == v[i]
        if n > 0:
            tree.incl(n - 1)
            doAssert tree.ge(n - 1) == n - 1
            doAssert tree.le(n - 1) == n - 1
            tree.excl(n - 1)
            doAssert not tree[n - 1]

for n in 1..256:
    var v = newSeq[bool](n)
    for i in 0..<n: v[i] = (i * 37 + n * 13) mod 101 < 49
    var tree = initWordsizeTree(v)
    for i in 0..<n:
        var lo = -1
        var hi = -1
        for j in 0..i:
            if v[j]: lo = j
        for j in countdown(n - 1, i):
            if v[j]: hi = j
        doAssert tree.le(i) == lo
        doAssert tree.ge(i) == hi

var tree = initWordsizeTree()
var reference: seq[int]
var rng = initRand(12345)
for step in 0..<30000:
    let x = rng.rand(WordsizeTreeAvx2Capacity - 1)
    let pos = reference.lowerBound(x)
    case step mod 4
    of 0:
        tree.incl(x)
        tree.incl(x)
        if pos == reference.len or reference[pos] != x: reference.insert(x, pos)
    of 1:
        tree.excl(x)
        if pos < reference.len and reference[pos] == x: reference.delete(pos)
        if reference.len > 0:
            let index = rng.rand(reference.high)
            tree.excl(reference[index])
            reference.delete(index)
    else: discard
    let hi = reference.lowerBound(x)
    let lo = reference.upperBound(x) - 1
    doAssert tree.ge(x) == (if hi == reference.len: -1 else: reference[hi])
    doAssert tree.le(x) == (if lo < 0: -1 else: reference[lo])
for x in reference: tree.excl(x)
doAssert tree.ge(0) == -1
doAssert tree.le(WordsizeTreeAvx2Capacity - 1) == -1
for x in [0, 63, 64, 255, 256, 65535, 65536, WordsizeTreeAvx2Capacity - 1]:
    tree.incl(x)
    doAssert tree.ge(x) == x
    doAssert tree.le(x) == x
    tree.excl(x)
    doAssert tree.ge(0) == -1
doAssert tree.le(-1) == -1
doAssert tree.ge(WordsizeTreeAvx2Capacity) == -1
echo "Hello World"
