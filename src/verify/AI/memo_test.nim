# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/utils/memo

var calls = 0

proc fib(n: int): int {.memo.} =
  calls += 1
  if n <= 1:
    n
  else:
    fib(n - 1) + fib(n - 2)

assert fib(10) == 55
let callsAfterFirst = calls
assert fib(10) == 55
assert calls == callsAfterFirst

proc addPair(a, b: int): int {.memo.} =
  calls += 1
  a + b

let beforePair = calls
assert addPair(2, 3) == 5
assert addPair(2, 3) == 5
assert calls == beforePair + 1
