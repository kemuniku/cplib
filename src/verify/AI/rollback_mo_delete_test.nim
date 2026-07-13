# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/utils/rollback_mo_delete

let a = @[3, 1, 4, 1, 5, 9, 2, 6]
let ranges = @[(0, 2), (1, 7), (2, 5), (0, 8), (4, 4), (5, 8)]
var solver = initRollbackMoDelete(a.len, ranges.len, 3)
for (l, r) in ranges:
    solver.insert(l, r)

var
    sum = 31
    history: seq[int]
    ans = newSeq[int](ranges.len)

proc deleteItem(i: int) =
    history.add(sum)
    sum -= a[i]

proc snapshot(): int = history.len

proc rollback(state: int) =
    while history.len > state:
        sum = history.pop()

proc rem(idx: int) = ans[idx] = sum

solver.run(deleteItem, snapshot, rollback, rem)

for i, query in ranges:
    var expected = 0
    for j in query[0]..<query[1]:
        expected += a[j]
    assert ans[i] == expected

assert history.len == 0
assert sum == 31
