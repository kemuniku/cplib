# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import algorithm
import cplib/math/sqrt_heuristic_for_floor_sum

let parts = sqrt_heuristic_for_floor_sum(3, 1, 10, 7)
var got: seq[(int, int)]
for part in parts:
  for t in 0..<part.n:
    got.add((part.x + part.dx * t, part.y + part.dy * t))
got.sort()
var expected: seq[(int, int)]
for k in 0..<10:
  expected.add((k, (3 * k + 1) mod 7))
assert got == expected
