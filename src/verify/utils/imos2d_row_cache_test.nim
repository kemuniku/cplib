# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sequtils
import cplib/utils/imos2d

proc check(h, w: int, seed: int) =
    var rng = initRand(seed)
    let imos = initImos2D(h, w)
    var expected = newSeqWith(h, newSeq[int](w))
    doAssert imos.build() == expected
    for trial in 0..<80:
        let ia = rng.rand(h)
        let ib = rng.rand(h)
        let ja = rng.rand(w)
        let jb = rng.rand(w)
        let il = min(ia, ib)
        let ir = max(ia, ib)
        let jl = min(ja, jb)
        let jr = max(ja, jb)
        let x = rng.rand(-1000000..1000000)
        imos.rectangle_add(il, ir, jl, jr, x)
        for i in il..<ir:
            for j in jl..<jr:
                expected[i][j] += x
        doAssert imos.build() == expected
        doAssert imos.build() == expected
    var first = imos.build()
    if h > 0 and w > 0:
        first[0][0] = high(int)
        doAssert imos.build() == expected

for h in 0..12:
    for w in 0..12:
        check(h, w, 20261005 + h * 13 + w)
for x in [0, 1, -1, high(int), -high(int)]:
    let imos = initImos2D(1, 1)
    imos.rectangle_add(0, 1, 0, 1, x)
    doAssert imos.build() == @[@[x]]
for h in 1..3:
    for w in 1..3:
        for il in 0..h:
            for ir in il..h:
                for jl in 0..w:
                    for jr in jl..w:
                        let imos = initImos2D(h, w)
                        imos.rectangle_add(il, ir, jl, jr, 17)
                        var expected = newSeqWith(h, newSeq[int](w))
                        for i in il..<ir:
                            for j in jl..<jr:
                                expected[i][j] = 17
                        doAssert imos.build() == expected
check(1000, 1, 31)
check(1, 1000, 32)
echo "Hello World"
