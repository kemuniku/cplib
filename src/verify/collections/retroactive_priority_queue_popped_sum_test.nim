# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random
import cplib/collections/retroactive_priority_queue
import cplib/collections/compressed_retroactive_priority_queue
import cplib/collections/dynamic_retroactive_priority_queue

var rng = initRand(36328)
for order in [Ascending, Descending]:
    let fixed = initRetroactivePriorityQueue[int64](40, order)
    var times: seq[int]
    for i in 0..<40: times.add(i * 17 - 500)
    let compressed = initCompressedRetroactivePriorityQueue[int, int64](times, order)
    let dynamic = initDynamicRetroactivePriorityQueue[int, int64](order)
    var kind = newSeq[int](40)
    var values = newSeq[int64](40)
    doAssert fixed.poppedSum == 0 and compressed.poppedSum == 0 and dynamic.poppedSum == 0
    for step in 0..<5000:
        let i = rng.rand(39)
        kind[i] = rng.rand(2)
        values[i] = int64(rng.rand(-100..100))
        case kind[i]
        of 0:
            fixed.erase(i)
            compressed.erase(times[i])
            dynamic.erase(times[i])
        of 1:
            fixed.setPush(i, values[i])
            compressed.setPush(times[i], values[i])
            dynamic.setPush(times[i], values[i])
        else:
            fixed.setPop(i)
            compressed.setPop(times[i])
            dynamic.setPop(times[i])
        var heap: seq[int64]
        var popped = 0'i64
        for t in 0..<40:
            if kind[t] == 1: heap.add(values[t])
            elif kind[t] == 2 and heap.len > 0:
                heap.sort(order)
                popped += heap[0]
                heap.delete(0)
        var remaining = 0'i64
        for x in heap: remaining += x
        doAssert fixed.poppedSum == popped
        doAssert compressed.poppedSum == popped
        doAssert dynamic.poppedSum == popped
        doAssert fixed.sum == remaining and compressed.sum == remaining and dynamic.sum == remaining
    for i in 0..<40:
        fixed.erase(i)
        compressed.erase(times[i])
        dynamic.erase(times[i])
    doAssert fixed.poppedSum == 0 and compressed.poppedSum == 0 and dynamic.poppedSum == 0

template extreme(pq: untyped, T: typedesc) =
    let queue = pq
    queue.setPop(1)
    queue.setPush(0, high(T))
    queue.setPush(2, high(T))
    doAssert queue.sum == high(T) and queue.poppedSum == high(T)
    queue.erase(0)
    doAssert queue.poppedSum == 0
    queue.erase(2)
    when T is SomeSignedInt:
        queue.setPush(0, low(T))
        queue.setPush(2, low(T))
        doAssert queue.sum == low(T) and queue.poppedSum == low(T)

extreme(initRetroactivePriorityQueue[int64](3), int64)
extreme(initDynamicRetroactivePriorityQueue[int, int64](), int64)
extreme(initRetroactivePriorityQueue[uint64](3), uint64)
extreme(initDynamicRetroactivePriorityQueue[int, uint64](), uint64)

block:
    let queue = initRetroactivePriorityQueue[float64](3)
    queue.setPush(0, 1.5)
    queue.setPush(1, 2.5)
    queue.setPop(2)
    doAssert queue.poppedSum == 1.5 and queue.sum == 2.5
    queue.erase(2)
    doAssert queue.poppedSum == 0

echo "Hello World"
