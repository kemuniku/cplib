# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import algorithm, sequtils
import cplib/math/primitive_root

let g = primitive_root(17)
var seen: seq[int]
var cur = 1
for _ in 0..<16:
  seen.add(cur)
  cur = (cur * g) mod 17
assert seen.sorted == (1..16).toSeq
