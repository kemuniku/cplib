# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"
import sequtils
import cplib/collections/range_reverse_array

var empty = initRangeReverseArray(newSeq[int]())
empty.reverse(0, 0)
assert empty.len == 0
assert empty.toSeq == newSeq[int]()

var a = initRangeReverseArray((0..<10).toSeq)
assert a.len == 10
assert a.toSeq == (0..<10).toSeq

a.reverse(2, 7)
assert a.toSeq == @[0, 1, 6, 5, 4, 3, 2, 7, 8, 9]
assert a[0] == 0
assert a[2] == 6
assert a[^1] == 9

a.reverse(0..<0)
a.reverse(3, 3)
assert a.toSeq == @[0, 1, 6, 5, 4, 3, 2, 7, 8, 9]

a.reverse(0..9)
assert a.toSeq == @[9, 8, 7, 2, 3, 4, 5, 6, 1, 0]
a.update(3, 100)
assert a.toSeq == @[9, 8, 7, 100, 3, 4, 5, 6, 1, 0]
a[^1] = -1
assert a.toSeq == @[9, 8, 7, 100, 3, 4, 5, 6, 1, -1]

var b = initRangeReverseArray(["a", "b", "c", "d"])
b.reverse(1, 4)
assert b[1] == "d"
b[2] = "x"
assert b.toSeq == @["a", "d", "x", "b"]
assert $b == "a d x b"

var c = initRangeReverseArray((0..<12).toSeq)
var expected = (0..<12).toSeq
for l in 0..12:
    for r in l..12:
        c.reverse(l, r)
        var i = l
        var j = r - 1
        while i < j:
            let tmp = expected[i]
            expected[i] = expected[j]
            expected[j] = tmp
            i += 1
            j -= 1
        for k in 0..<12:
            assert c[k] == expected[k]
        assert c.toSeq == expected
