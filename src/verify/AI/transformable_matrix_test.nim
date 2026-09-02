# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import cplib/matrix/transformable_matrix

proc rotated[T](a: seq[seq[T]]): seq[seq[T]] =
    if a.len == 0: return @[]
    result = newSeq[seq[T]](a[0].len)
    for i in 0..<result.len:
        result[i].setLen(a.len)
        for j in 0..<a.len:
            result[i][j] = a[a.len - 1 - j][i]

proc transposed[T](a: seq[seq[T]]): seq[seq[T]] =
    if a.len == 0: return @[]
    result = newSeq[seq[T]](a[0].len)
    for i in 0..<result.len:
        result[i].setLen(a.len)
        for j in 0..<a.len:
            result[i][j] = a[j][i]

var expected = @[@[0, 1, 2], @[3, 4, 5]]
var matrix = expected.toTransformableMatrix

assert matrix.h == 2 and matrix.w == 3
assert matrix.toSeq == expected

matrix.swapRows(0, 1)
swap(expected[0], expected[1])
assert matrix.toSeq == expected

matrix.swapColumns(0, 2)
for row in expected.mitems: swap(row[0], row[2])
assert matrix.toSeq == expected

matrix.transpose
expected = expected.transposed
assert matrix.h == expected.len and matrix.w == expected[0].len
assert matrix.toSeq == expected

matrix.rotate
expected = expected.rotated
assert matrix.toSeq == expected

matrix.swapRows(0, 1)
swap(expected[0], expected[1])
matrix.swapColumns(0, 2)
for row in expected.mitems: swap(row[0], row[2])
assert matrix.toSeq == expected

matrix.rotate(-1)
for _ in 0..<3: expected = expected.rotated
assert matrix.toSeq == expected

matrix[0, 1] = 100
expected[0][1] = 100
assert matrix[0, 1] == 100
assert matrix.toSeq == expected

var zeroWidth = initTransformableMatrix(@[newSeq[int](0), newSeq[int](0)])
assert zeroWidth.h == 2 and zeroWidth.w == 0
zeroWidth.transpose
assert zeroWidth.h == 0 and zeroWidth.w == 2

echo "Hello World"
