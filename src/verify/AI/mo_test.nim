# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/utils/mo

let a = @[1, 2, 3, 4, 5]
var solver = initMo(a.len, 3, 2)
solver.insert(0, 3)
solver.insert(1, 5)
solver.insert(2, 4)

var cur = 0
var ans = newSeq[int](3)
solver.run(
  proc(i: int) = cur += a[i],
  proc(i: int) = cur += a[i],
  proc(i: int) = cur -= a[i],
  proc(i: int) = cur -= a[i],
  proc(idx: int) = ans[idx] = cur
)

assert ans == @[6, 14, 7]
