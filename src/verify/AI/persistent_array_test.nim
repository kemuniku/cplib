# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/persistent_array

let pa = initPersistentArray(@[10, 20, 30, 40], 2)
assert pa[0] == 10
assert pa[3] == 40
assert pa.toseq == @[10, 20, 30, 40]
let pb = pa.change_value(1, 99)
assert pa.toseq == @[10, 20, 30, 40]
assert pb.toseq == @[10, 99, 30, 40]
