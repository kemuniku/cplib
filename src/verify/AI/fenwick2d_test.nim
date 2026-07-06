# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/fenwick2d

let fw = initFenwick2D(@[@[1, 4], @[2], @[1, 3]])
fw.add(0, 1, 5)
fw.add(0, 4, 2)
fw.add(1, 2, 7)
fw.add(2, 3, 11)
assert fw.prefix(3, 10) == 25
assert fw.getLess(0, 2, 3) == 12
assert fw.get(0, 3, 2, 4) == 18
assert fw.get(2, 3, 0, 2) == 0
