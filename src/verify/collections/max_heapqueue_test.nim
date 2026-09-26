# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, heapqueue, random
import cplib/collections/max_heapqueue

proc check(heap: MaxHeapQueue[int], values: seq[int]) =
    doAssert heap.len == values.len
    var actual: seq[int]
    for x in heap:
        doAssert x == heap[actual.len]
        actual.add(x)
    doAssert actual.sorted() == values.sorted()
    for i in 1..<heap.len:
        doAssert heap[i] <= heap[(i - 1) div 2]
    if values.len > 0:
        doAssert heap[0] == values.max

block:
    var heap: MaxHeapQueue[int]
    doAssert heap.len == 0
    doAssert $heap == "[]"
    doAssert heap.find(0) == -1
    doAssert 0 notin heap
    doAssert heap.pushpop(5) == 5
    doAssert heap.len == 0
    heap.clear()
    heap.push(low(int))
    doAssert heap[0] == low(int)
    doAssert heap.replace(high(int)) == low(int)
    doAssert heap.replace(0) == high(int)
    doAssert heap.pushpop(high(int)) == high(int)
    doAssert heap[0] == 0
    doAssert heap.pushpop(low(int)) == 0
    doAssert heap.pop() == low(int)
    doAssert heap.len == 0
    heap.push(1)
    heap.del(0)
    doAssert heap.len == 0

block:
    let empty: seq[int] = @[]
    var heap = empty.toMaxHeapQueue()
    doAssert heap.len == 0
    let values = @[low(int), high(int), 0, -1, 1, high(int), low(int)]
    heap = values.toMaxHeapQueue()
    heap.check(values)
    for x in values.sorted(Descending):
        doAssert heap.pop() == x
    doAssert heap.len == 0

block:
    var heap = [10, 5, 9, 1, 2, 8, 7].toMaxHeapQueue()
    doAssert heap[3] == 1
    heap.del(3)
    heap.check(@[10, 5, 9, 2, 8, 7])
    for x in [10, 9, 8, 7, 5, 2]:
        doAssert heap.pop() == x

block:
    var heap = [3, 1, 2].toMaxHeapQueue()
    var copy = heap
    doAssert copy.pop() == 3
    copy.push(4)
    heap.check(@[1, 2, 3])
    copy.check(@[1, 2, 4])
    heap.clear()
    heap.push(5)
    doAssert heap.pop() == 5
    copy.check(@[1, 2, 4])

block:
    var heap = ["abc", "xyz", "abc"].toMaxHeapQueue()
    doAssert heap.pop() == "xyz"
    doAssert heap.find("abc") >= 0
    doAssert "missing" notin heap
    doAssert heap.pop() == "abc"
    doAssert heap.pop() == "abc"
    doAssert $["b", "a"].toMaxHeapQueue() == "[\"b\", \"a\"]"
    doAssert $['\n'].toMaxHeapQueue() == $['\n'].toHeapQueue()
    doAssert $[2, 1].toMaxHeapQueue() == "[2, 1]"

block:
    var heap = [(1, 9), (2, 0), (1, 10)].toMaxHeapQueue()
    doAssert heap.pop() == (2, 0)
    doAssert heap.pop() == (1, 10)
    doAssert heap.pop() == (1, 9)

type Job = object
    priority: int
    name: string

proc `<`(a, b: Job): bool = a.priority < b.priority
proc `==`(a, b: Job): bool = a.name == b.name

block:
    let low = Job(priority: 1, name: "low")
    let middle = Job(priority: 2, name: "middle")
    let high = Job(priority: 3, name: "high")
    var heap = [middle, low].toMaxHeapQueue()
    heap.push(high)
    doAssert heap[0].name == "high"
    doAssert Job(priority: -1, name: "middle") in heap
    doAssert heap[heap.find(low)].name == "low"
    doAssert heap.replace(middle).name == "high"
    doAssert heap.pushpop(high).name == "high"
    doAssert heap.pushpop(low).name == "middle"
    heap.del(heap.find(middle))
    doAssert heap.pop().name == "low"
    doAssert heap.pop().name == "low"
    doAssert heap.len == 0

block:
    var minimum = initHeapQueue[int]()
    var maximum = initMaxHeapQueue[int]()
    for x in [3, 1, 2]:
        minimum.push(x)
        maximum.push(x)
    doAssert minimum.pop() == 1
    doAssert maximum.pop() == 3

var rng = initRand(20260926)
for trial in 0..<100:
    var values: seq[int]
    for i in 0..<rng.rand(100):
        values.add(rng.rand(-30..30))
    var heap = values.toMaxHeapQueue()
    heap.check(values)
    for step in 0..<300:
        let x = rng.rand(-30..30)
        case rng.rand(0..9)
        of 0, 1, 2:
            heap.push(x)
            values.add(x)
        of 3:
            if values.len > 0:
                let expected = values.max
                doAssert heap.pop() == expected
                values.delete(values.find(expected))
        of 4:
            if values.len > 0:
                let index = rng.rand(heap.len - 1)
                let removed = heap[index]
                heap.del(index)
                values.delete(values.find(removed))
        of 5:
            if values.len > 0:
                let expected = values.max
                doAssert heap.replace(x) == expected
                values.delete(values.find(expected))
                values.add(x)
        of 6:
            values.add(x)
            let expected = values.max
            doAssert heap.pushpop(x) == expected
            values.delete(values.find(expected))
        of 7:
            heap.clear()
            values.setLen(0)
        of 8:
            let index = heap.find(x)
            doAssert (index >= 0) == (x in values)
            doAssert (x in heap) == (x in values)
            if index >= 0:
                doAssert heap[index] == x
                for i in 0..<index:
                    doAssert heap[i] != x
        else:
            heap = values.toMaxHeapQueue()
        heap.check(values)
    for x in values.sorted(Descending):
        doAssert heap.pop() == x
    doAssert heap.len == 0

echo "Hello World"
