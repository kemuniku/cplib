# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/utils/seqidx

let xs = @[3, 1, 4, 1, 5]
assert xs.allItidx(idx >= 0 and it > 0)
assert xs.anyItIdx(idx == 2 and it == 4)
assert xs.findItIdx(it == 1 and idx > 0) == 1
assert xs.mapItIdx(it + idx) == @[3, 2, 6, 4, 9]
assert newSeqWithIdx(4, idx * idx) == @[0, 1, 4, 9]
