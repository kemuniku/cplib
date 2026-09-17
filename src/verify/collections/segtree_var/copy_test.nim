# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/segtree_var

let merge = proc(x, y: int): int = x + y
var original = initSegmentTree(@[1, 2, 3, 4], merge, 0)
var copied = original
copied[0] += 10
assert copied.get_all() == 20
assert original.get_all() == 10
assert int(original[0]) == 1
original[1] *= 3
assert original.get_all() == 14
assert copied.get_all() == 20
assert copied.get(0, 2) == 13
copied[2] = 8
copied[2] -= 3
assert copied.get_all() == 22
assert original.get_all() == 14
assert copied.max_right(0, proc(x: int): bool = x <= 13) == 2
assert copied.min_left(4, proc(x: int): bool = x <= 9) == 2

proc makeCopy(): typeof(original) =
    var local = initSegmentTree(@[5, 6], merge, 0)
    result = local
    assert local.get_all() == 11

var returned = makeCopy()
returned[1] += 7
assert returned.get_all() == 18
var trees = @[original, returned]
trees[0][0] += 2
trees[1][1] -= 1
assert trees[0].get_all() == 16
assert trees[1].get_all() == 17
assert original.get_all() == 14
assert returned.get_all() == 18
swap(trees[0], trees[1])
trees[0][0] += 3
assert trees[0].get_all() == 20
assert trees[1].get_all() == 16

var sized = initSegmentTree(3, merge, 0)
var sizedCopy = sized
sizedCopy[2] += 9
assert sizedCopy.get_all() == 9
assert sized.get_all() == 0
