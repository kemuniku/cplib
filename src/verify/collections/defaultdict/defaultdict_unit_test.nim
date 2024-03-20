# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"
import tables, hashes
import cplib/collections/defaultdict

var d1 = @[(0, 0), (1, 1), (2, 2)].toDefaultDict(0)
var d2 = initDefaultDict[int, int](0)
assert d2[0] == 0
d2[1] = 1
d2[2] = 2
assert d1 == d2
d1.clear
assert d1[1] == 0
d2.del(1)
var x: int
assert d2.pop(2, x)
assert x == 2
assert d2.take(0, x)
assert x == 0
assert d2[1] == 0
assert hash(d1) == hash(d1)
assert 1 in d1
assert 2 notin d1
for k, v in d1:
    assert k == 1 and v == 0
assert ($d1) == "{1: 0}"
