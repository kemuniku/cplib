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

import cplib/modint/modint

block:
  type Mint = modint998244353_barrett
  var mo = initMo(5, 3)
  mo.insert(0, 5)
  mo.insert(1, 4)
  mo.insert(2, 2)
  var total = init(Mint, 0)
  var answers = newSeq[int](3)
  proc addValue(i: int) = total += i + 1
  proc deleteValue(i: int) = total -= i + 1
  proc recordAnswer(i: int) = answers[i] = total.val
  mo.run(addValue, addValue, deleteValue, deleteValue, remember = recordAnswer)
  doAssert answers == @[15, 9, 0]

proc checkClosureCallbacks() =
  var mo = initMo(3, 1)
  mo.insert(1, 3)
  var total, factories, answer: int
  proc makeCallback(sign: int): proc(i: int) {.closure.} =
    inc factories
    result = proc(i: int) = total += sign * (i + 1)
  proc recordAnswer(i: int) = answer = total
  mo.run(makeCallback(1), makeCallback(1),
         makeCallback(-1), makeCallback(-1), recordAnswer)
  doAssert factories == 4
  doAssert answer == 5

checkClosureCallbacks()

block:
  let queries = @[(5, 0), (3, -1), (0, 5), (0, -1), (5, 5), (2, 1)]
  var solver = initMo(5, queries.len, 2)
  for (l, r) in queries:
    solver.insert(l, r)
  var l = 0
  var r = 0
  var visited = newSeq[int](queries.len)
  solver.run(
    proc(i: int) =
      doAssert i == l - 1
      l = i,
    proc(i: int) =
      doAssert i == r
      r = i + 1,
    proc(i: int) =
      doAssert i == l
      l = i + 1,
    proc(i: int) =
      doAssert i == r - 1
      r = i,
    proc(idx: int) =
      doAssert (l, r) == queries[idx]
      inc visited[idx]
  )
  doAssert visited == @[1, 1, 1, 1, 1, 1]
