# verification-helper: PROBLEM https://atcoder.jp/contests/abc363/tasks/abc363_g
import algorithm
include cplib/tmpl/fastio
import cplib/collections/compressed_retroactive_priority_queue

type
    Time = tuple[day, id: int]
    Query = tuple[c, x: int, y: int64]

let n = input(int)
let q = input(int)
var d = newSeq[int](n)
var p = newSeq[int64](n)
for i in 0..<n: d[i] = input(int)
for i in 0..<n: p[i] = input(int64)
var times: seq[Time]
for day in 1..n: times.add((n - day, n))
for i in 0..<n: times.add((n - d[i], i))
var queries = newSeq[Query](q)
for query in queries.mitems:
    query = (input(int) - 1, input(int), input(int64))
    times.add((n - query.x, query.c))

var pq = initCompressedRetroactivePriorityQueue[Time, int64](times, Descending)
for day in 1..n: pq.setPop((n - day, n))
var total = 0'i64
for i in 0..<n:
    pq.setPush((n - d[i], i), p[i])
    total += p[i]
for (c, x, y) in queries:
    pq.erase((n - d[c], c))
    pq.setPush((n - x, c), y)
    total += y - p[c]
    d[c] = x
    p[c] = y
    echo total - pq.sum
