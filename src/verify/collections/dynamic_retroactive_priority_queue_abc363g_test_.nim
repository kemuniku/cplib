# verification-helper: PROBLEM https://atcoder.jp/contests/abc363/tasks/abc363_g
import algorithm
include cplib/tmpl/fastio
import cplib/collections/dynamic_retroactive_priority_queue

type Time = tuple[day, id: int]

let n = input(int)
let q = input(int)
var d = newSeq[int](n)
var p = newSeq[int64](n)
for i in 0..<n: d[i] = input(int)
for i in 0..<n: p[i] = input(int64)
let pq = initDynamicRetroactivePriorityQueue[Time, int64](Descending)
for day in 1..n: pq.setPop((n - day, n))
var total = 0'i64
for i in 0..<n:
    pq.setPush((n - d[i], i), p[i])
    total += p[i]
for _ in 0..<q:
    let c = input(int) - 1
    let x = input(int)
    let y = input(int64)
    pq.erase((n - d[c], c))
    pq.setPush((n - x, c), y)
    total += y - p[c]
    d[c] = x
    p[c] = y
    echo total - pq.sum
