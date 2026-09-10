# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/matrix/[matrix_mod2, static_matrix_mod2]
import std/options

var a = initMatrixMod2(@[@[1, 0, 1], @[0, 1, 1]])
let b = initMatrixMod2(@[@[1, 0], @[0, 1], @[1, 1]])
assert a.h == 2 and a.w == 3
assert a * b == initMatrixMod2(@[@[0, 1], @[1, 0]])
assert a.rank == 2
a[0, 1] = true
assert a[0, 1]
a.setRowBits(0, "101")
assert a.rowBits(0) == "101"
assert a.rowBits(0, 2) == "10"

let d = initMatrixMod2(@[@[1, 1, 0], @[1, 0, 1], @[0, 1, 1]])
assert not d.determinant
let e = initMatrixMod2(@[@[1, 1, 0], @[0, 1, 1], @[1, 1, 1]])
assert e.determinant
assert e.inverse.isSome
assert e * e.inverse.get == identityMatrixMod2(3)

let sa = initStaticMatrixMod2([[1, 0, 1], [0, 1, 1]])
let sb = initStaticMatrixMod2([[1, 0], [0, 1], [1, 1]])
assert sa.h == 2 and sa.w == 3
assert sa * sb == initStaticMatrixMod2([[0, 1], [1, 0]])
assert sa.rank == 2
let se = initStaticMatrixMod2([[1, 1, 0], [0, 1, 1], [1, 1, 1]])
assert se.determinant
assert se.inverse.isSome
assert se * se.inverse.get == identityStaticMatrixMod2[3]()

# Cross the 64-bit word boundary in storage and elimination.
var wide = initMatrixMod2(65, 65)
for i in 0..<65: wide[i, i] = true
wide[0, 64] = true
wide[64, 1] = true
assert wide.rank == 65
assert wide.inverse.isSome
assert wide * wide.inverse.get == identityMatrixMod2(65)

let zeroWidthProduct = initMatrixMod2(40, 64) * initMatrixMod2(64, 0)
assert zeroWidthProduct.h == 40 and zeroWidthProduct.w == 0

assert initMatrixMod2(0, 0).rank == 0
assert initMatrixMod2(0, 1 shl 24).rank == 0
assert initMatrixMod2(1000, 0).rank == 0

import random, strutils
var rng = initRand(401279)
for (h, m, w) in [(3, 65, 7), (39, 64, 65), (40, 64, 65), (41, 73, 129)]:
    var left = initMatrixMod2(h, m)
    var right = initMatrixMod2(m, w)
    for i in 0..<h:
        for j in 0..<m: left[i, j] = rng.rand(1) == 1
    for i in 0..<m:
        for j in 0..<w: right[i, j] = rng.rand(1) == 1
    let savedLeft = left
    let savedRight = right
    let product = left * right
    for i in 0..<h:
        for j in 0..<w:
            var expected = false
            for k in 0..<m: expected = expected xor (left[i, k] and right[k, j])
            assert product[i, j] == expected
    assert left == savedLeft and right == savedRight
    var copied = left
    copied.setRowBits(0, "1")
    assert copied.rowBits(0) == "1" & repeat('0', m - 1)
    assert left == savedLeft
    assert copied.rowBits(1) == left.rowBits(1)

block:
    const N = 1 shl 24
    var tall = initMatrixMod2(N, 1)
    tall[N-1, 0] = true
    assert tall.rank == 1
    assert tall[N-1, 0] and not tall[0, 0]

for n in [0, 1, 2, 63, 64, 65, 127, 128, 129]:
    var a = identityMatrixMod2(n)
    for i in 0..<n:
        for j in 0..<i:
            if rng.rand(1) == 1:
                for k in 0..<n: a[i,k] = a[i,k] xor a[j,k]
    for i in 0..<n div 2:
        let other = n-1-i
        for j in 0..<n:
            let value = a[i,j]
            a[i,j] = a[other,j]
            a[other,j] = value
    let before = a
    let inverse = a.inverse
    assert inverse.isSome
    assert a * inverse.get == identityMatrixMod2(n)
    assert inverse.get * a == identityMatrixMod2(n)
    assert inverse.get.inverse.get == a
    assert a == before
    if n > 0:
        a.setRowBits(n-1, "")
        assert a.inverse.isNone
