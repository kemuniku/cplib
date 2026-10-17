# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/xor_segtree
import cplib/collections/segtree
import random, sequtils

proc sumValues(x, y: int): int = x + y
proc concatenateTokens(x, y: string): string = x & y
proc smaller(x, y: int): int = min(x, y)
type Affine = tuple[a, b: int]
const modulus = 101
proc compose(x, y: Affine): Affine =
    ((x.a * y.a) mod modulus, (x.b * y.a + y.b) mod modulus)

template expectInvalid(body: untyped) =
    block:
        var rejected = false
        try:
            body
        except ValueError:
            rejected = true
        doAssert rejected

for n in [-1, 0, 3, 6, high(int)]:
    expectInvalid:
        discard initXORSegmentTree(n, sumValues, 0)
for n in [0, 3, 6]:
    let v = newSeq[int](n)
    expectInvalid:
        discard initXORSegmentTree(v, sumValues, 0)
    expectInvalid:
        discard initStaticXORSegmentTree(v, sumValues, 0)

block:
    let identity = initXORSegmentTree(8, smaller, high(int))
    doAssert identity.get_all() == high(int)
    doAssert identity.get(3, 3, 7) == high(int)
    identity[6] = -19
    doAssert identity.get(0, 1, 6) == -19
    doAssert identity.get(0, 1, 0) == high(int)
    var source = @[1, 2, 3, 4]
    let copied = initStaticXORSegmentTree(source, sumValues, 0)
    let dynamic = initXORSegmentTree(source, sumValues, 0)
    source[0] = 100
    doAssert copied[0] == 1
    doAssert copied.get_all() == 10
    doAssert dynamic[0] == 1
    doAssert dynamic.get_all() == 10

proc checkSums(v: seq[int], tree: XORSegmentTree[int]) =
    let ordinary = initSegmentTree(v, sumValues, 0)
    doAssert tree.len == v.len
    for mask in 0..<v.len:
        for l in 0..v.len:
            var expected = 0
            for r in l..v.len:
                if r > l: expected += v[(r - 1) xor mask]
                doAssert tree.get(l, r, mask) == expected
                if mask == 0:
                    doAssert tree.get(l, r) == ordinary.get(l, r)
        doAssert tree.get_all(mask) == v.foldl(a + b, 0)
    for i in 0..<v.len: doAssert tree[i] == v[i]

for bits in 0..4:
    let n = 1 shl bits
    var v = newSeq[int](n)
    for i in 0..<n: v[i] = i * 3 - 7
    let tree = initXORSegmentTree(v, sumValues, 0)
    checkSums(v, tree)
    for i in 0..<n:
        v[i] = -v[i] - 1
        tree.update(i, v[i])
        checkSums(v, tree)
        v[i] = 0
        tree[i] = 0
        checkSums(v, tree)

    let identityTree = initXORSegmentTree(n, sumValues, 0)
    doAssert identityTree.get_all() == 0
    identityTree[n - 1] = 19
    doAssert identityTree.get(0, 1, n - 1) == 19

    var strings = newSeq[string](n)
    var functions = newSeq[Affine](n)
    for i in 0..<n:
        strings[i] = "[" & $i & "]"
        functions[i] = (i mod 5, (i * 7 + 3) mod modulus)
    let ordered = initStaticXORSegmentTree(strings, concatenateTokens, "")
    let affine = initStaticXORSegmentTree(functions, compose, (1, 0))
    doAssert ordered.len == n
    for i in 0..<n:
        doAssert ordered[i] == strings[i]
        doAssert affine[i] == functions[i]
    for mask in 0..<n:
        for l in 0..n:
            var expected = ""
            for r in l..n:
                if r > l: expected &= strings[(r - 1) xor mask]
                doAssert ordered.get(l, r, mask) == expected
                let f = affine.get(l, r, mask)
                for x in [0, 1, 43, 100]:
                    var y = x
                    for i in l..<r:
                        let g = functions[i xor mask]
                        y = (g.a * y + g.b) mod modulus
                    doAssert (f.a * x + f.b) mod modulus == y
                if mask == 0:
                    doAssert ordered.get(l, r) == expected
        doAssert ordered.get_all(mask) == ordered.get(0, n, mask)
        doAssert affine.get_all(mask) == affine.get(0, n, mask)
    doAssert ordered.get_all() == ordered.get(0, n)

block:
    let v = @[1, 2, 3, 4]
    let dynamic = initXORSegmentTree(v, sumValues, 0)
    let immutable = initStaticXORSegmentTree(v, sumValues, 0)
    for range in [(-1, 0, 0), (0, -1, 0), (3, 2, 0), (0, 5, 0),
                  (0, 4, -1), (0, 4, 4), (4, 4, 4)]:
        expectInvalid:
            discard dynamic.get(range[0], range[1], range[2])
        expectInvalid:
            discard immutable.get(range[0], range[1], range[2])
    for i in [-1, 4]:
        expectInvalid:
            discard dynamic[i]
        expectInvalid:
            discard immutable[i]
        expectInvalid:
            dynamic.update(i, 0)
    for mask in [-1, 4]:
        expectInvalid:
            discard dynamic.get_all(mask)
        expectInvalid:
            discard immutable.get_all(mask)
    doAssert dynamic.get_all() == 10
    static:
        doAssert not compiles(immutable.update(0, 1))
        doAssert not compiles(immutable[0] = 1)

var rng = initRand(577)
for bits in [5, 8, 10]:
    let n = 1 shl bits
    var v = newSeq[int](n)
    var f = newSeq[Affine](n)
    for i in 0..<n:
        v[i] = rng.rand(-1000..1000)
        f[i] = (rng.rand(0..100), rng.rand(0..100))
    let tree = initXORSegmentTree(v, sumValues, 0)
    let ordered = initStaticXORSegmentTree(f, compose, (1, 0))
    for iteration in 0..<1500:
        if iteration mod 3 == 0:
            let i = rng.rand(n - 1)
            v[i] = rng.rand(-1000..1000)
            tree[i] = v[i]
        let l = rng.rand(n)
        let r = rng.rand(l..n)
        let mask = rng.rand(n - 1)
        var total = 0
        var y = 37
        for i in l..<r:
            total += v[i xor mask]
            let g = f[i xor mask]
            y = (g.a * y + g.b) mod modulus
        doAssert tree.get(l, r, mask) == total
        let g = ordered.get(l, r, mask)
        doAssert (g.a * 37 + g.b) mod modulus == y

block:
    var calls = 0
    proc counted(x, y: int): int =
        inc calls
        x + y
    const bits = 15
    const n = 1 shl bits
    var v = newSeq[int](n)
    for i in 0..<n: v[i] = 1
    let tree = initXORSegmentTree(v, counted, 0)
    doAssert calls == n - 1
    calls = 0
    let ordered = initStaticXORSegmentTree(v, counted, 0)
    doAssert calls == n * bits
    calls = 0
    tree[n - 1] = 2
    doAssert calls == bits
    for mask in [0, 1, n div 2, n - 1, 21845]:
        for range in [(0, n), (0, 0), (n, n), (1, n - 1), (37, 21846)]:
            calls = 0
            let got = tree.get(range[0], range[1], mask)
            let changed = (n - 1) xor mask
            let extra = int(range[0] <= changed and changed < range[1])
            doAssert got == range[1] - range[0] + extra
            doAssert calls <= 2 * bits + 1
            calls = 0
            doAssert ordered.get(range[0], range[1], mask) == range[1] - range[0]
            doAssert calls <= 2 * bits + 1
        calls = 0
        doAssert tree.get_all(mask) == n + 1
        doAssert ordered.get_all(mask) == n
        doAssert calls == 0

echo "Hello World"
