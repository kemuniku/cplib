# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/math/int128
import cplib/collections/private/convex_hull_trick_impl

proc checkStart(left, right: CHTLine) =
    let start = chtStart(left, right)
    let numerator = to_Int128(right.b) - to_Int128(left.b)
    let denominator = to_Int128(left.a) - to_Int128(right.a)
    doAssert start * denominator >= numerator
    doAssert (start - to_Int128(1)) * denominator < numerator

let extremes = [low(int), low(int) + 1, -1, 0, 1, high(int) - 1, high(int)]
for a in extremes:
    for c in extremes:
        if a <= c: continue
        for b in extremes:
            for d in extremes:
                checkStart(CHTLine(a: a, b: b), CHTLine(a: c, b: d))

for a in -20..20:
    for c in -20..<a:
        for b in -20..20:
            for d in -20..20:
                checkStart(CHTLine(a: a, b: b), CHTLine(a: c, b: d))

echo "Hello World"
