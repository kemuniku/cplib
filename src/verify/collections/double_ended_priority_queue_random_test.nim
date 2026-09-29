# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random
import cplib/collections/double_ended_priority_queue

proc check(heap: DoubleEndedPriorityQueue[int], values: seq[int]) =
    doAssert heap.len == values.len
    doAssert heap.isEmpty == (values.len == 0)
    if values.len > 0:
        doAssert heap.min == values.min
        doAssert heap.max == values.max

proc drain(values: seq[int]) =
    let sorted = values.sorted()
    for mode in 0..2:
        var heap = values.toDoubleEndedPriorityQueue()
        var left = 0
        var right = sorted.len - 1
        while left <= right:
            doAssert heap.min == sorted[left]
            doAssert heap.max == sorted[right]
            if mode == 0 or (mode == 2 and heap.len mod 2 == 0):
                doAssert heap.popMin() == sorted[left]
                inc left
            else:
                doAssert heap.popMax() == sorted[right]
                dec right
        doAssert heap.isEmpty

block:
    var heap: DoubleEndedPriorityQueue[int]
    heap.check(@[])
    heap.clear()
    heap.push(42)
    heap.check(@[42])
    doAssert heap.popMax() == 42
    heap.push(17)
    doAssert heap.popMin() == 17
    heap.check(@[])
    let values = @[low(int), high(int), 0, -1, 1, low(int), high(int)]
    drain(values)
    for x in values: heap.push(x)
    heap.check(values)
    var copied = heap
    doAssert copied.popMin() == low(int)
    doAssert copied.popMax() == high(int)
    heap.check(values)
    copied.clear()
    copied.push(2)
    heap.check(values)
    doAssert copied.popMin() == 2
    heap.clear()
    heap.check(@[])

block:
    var heap = ["abc", "xyz", "abc", ""].toDoubleEndedPriorityQueue()
    doAssert heap.popMin() == ""
    doAssert heap.popMax() == "xyz"
    heap.push("def")
    doAssert heap.popMax() == "def"
    doAssert heap.popMin() == "abc"
    doAssert heap.popMax() == "abc"
    var pairs = [(1, 9), (2, 0), (1, 10)].toDoubleEndedPriorityQueue()
    doAssert pairs.popMin() == (1, 9)
    doAssert pairs.popMax() == (2, 0)
    doAssert pairs.popMin() == (1, 10)
    var unsigned = [0'u64, high(uint64), 1'u64].toDoubleEndedPriorityQueue()
    doAssert unsigned.popMax() == high(uint64)
    doAssert unsigned.popMin() == 0'u64

type Job = object
    priority: int
    name: string

proc `<`(a, b: Job): bool = a.priority < b.priority
proc `==`(a, b: Job): bool {.error: "比較には < のみを使用する".}

block:
    var jobs = initDoubleEndedPriorityQueue[Job]()
    for i in countdown(100, 0):
        jobs.push(Job(priority: i mod 7, name: $i))
    var seen: array[101, bool]
    var previous = -1
    while not jobs.isEmpty:
        let job = jobs.popMin()
        doAssert previous <= job.priority
        previous = job.priority
        for i in 0..100:
            if job.name == $i:
                doAssert not seen[i]
                seen[i] = true
    for found in seen: doAssert found
    var heap = [Job(priority: 1), Job(priority: 3), Job(priority: 2)].toDoubleEndedPriorityQueue()
    doAssert heap.popMax().priority == 3
    doAssert heap.popMin().priority == 1

for n in 0..7:
    var count = 1
    for _ in 0..<n: count *= 3
    for code in 0..<count:
        var values = newSeq[int](n)
        var state = code
        for x in values.mitems:
            x = state mod 3 - 1
            state = state div 3
        drain(values)

var rng = initRand(20260930)
for trial in 0..<100:
    var values = newSeq[int](rng.rand(0..300))
    for x in values.mitems: x = rng.rand(-100..100)
    drain(values)
    var heap = values.toDoubleEndedPriorityQueue()
    for step in 0..<1000:
        case rng.rand(0..9)
        of 0..4:
            let x = rng.rand(-100..100)
            heap.push(x)
            values.add(x)
        of 5, 6:
            if values.len > 0:
                let x = values.min
                doAssert heap.popMin() == x
                values.delete(values.find(x))
        of 7, 8:
            if values.len > 0:
                let x = values.max
                doAssert heap.popMax() == x
                values.delete(values.find(x))
        else:
            if step mod 2 == 0:
                heap = values.toDoubleEndedPriorityQueue()
            else:
                heap.clear()
                values.setLen(0)
        heap.check(values)
    for x in values.sorted(): doAssert heap.popMin() == x
    doAssert heap.isEmpty

block:
    const n = 100000
    for reverse in [false, true]:
        var heap = initDoubleEndedPriorityQueue[int]()
        for i in 0..<n: heap.push(if reverse: n - i - 1 else: i)
        for i in 0..<n div 2:
            doAssert heap.popMin() == i
            doAssert heap.popMax() == n - i - 1
        doAssert heap.isEmpty

echo "Hello World"
