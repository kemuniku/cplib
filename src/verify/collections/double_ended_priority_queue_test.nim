# verification-helper: PROBLEM https://judge.yosupo.jp/problem/double_ended_priority_queue
include cplib/tmpl/fastio
import cplib/collections/double_ended_priority_queue

let n = input(int)
let q = input(int)
var heap = input(n, int).toDoubleEndedPriorityQueue()
for _ in 0..<q:
    case input(int)
    of 0: heap.push(input(int))
    of 1: print(heap.popMin())
    else: print(heap.popMax())
