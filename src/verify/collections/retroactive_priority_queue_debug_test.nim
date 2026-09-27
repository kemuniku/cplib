# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, options, random
import cplib/collections/retroactive_priority_queue
import cplib/collections/compressed_retroactive_priority_queue
import cplib/collections/dynamic_retroactive_priority_queue
import cplib/collections/dynamic_retroactive_priority_queue_monoid

type
    Item = object
        priority: int
        label: string
    Time = tuple[day, id: int]
    Operation = tuple[kind: int, value: Item]

proc `<`(a, b: Item): bool = a.priority < b.priority

proc replay(ops: seq[Operation], order: SortOrder): seq[QueueDebugEntry[int, Item]] =
    var live: seq[int]
    for t, op in ops:
        var entry = QueueDebugEntry[int, Item](time: t, kind: QueueDebugKind(op.kind))
        if op.kind == 1:
            entry.value = some(op.value)
            live.add(t)
        elif op.kind == 2 and live.len > 0:
            var best = 0
            for j in 1..<live.len:
                let a = ops[live[j]].value
                let b = ops[live[best]].value
                if (order == Ascending and a < b) or (order == Descending and b < a): best = j
            let source = live[best]
            entry.popped = some((time: source, value: ops[source].value))
            live.delete(best)
        result.add(entry)

var rng = initRand(3632026)
for order in [Ascending, Descending]:
    for trial in 0..<20:
        let n = rng.rand(1..40)
        var times: seq[Time]
        for i in 0..<n: times.add((i div 3 - 10, i mod 3))
        var registration = times
        rng.shuffle(registration)
        let fixed = initRetroactivePriorityQueue[Item](n, order)
        let compressed = initCompressedRetroactivePriorityQueue[Time, Item](registration, order)
        let dynamic = initDynamicRetroactivePriorityQueue[Time, Item](order)
        let monoid = initDynamicRetroactivePriorityQueueMonoid[Time, Item, string](
            proc(a, b: string): string = a & b, "", proc(x: Item): string = x.label, order)
        var ops = newSeq[Operation](n)
        for step in 0..<150:
            let t = rng.rand(n - 1)
            ops[t] = (rng.rand(2), Item(priority: rng.rand(-2..2), label: $step & ","))
            case ops[t].kind
            of 0:
                fixed.erase(t)
                compressed.erase(times[t])
                dynamic.erase(times[t])
                monoid.erase(times[t])
            of 1:
                fixed.setPush(t, ops[t].value)
                compressed.setPush(times[t], ops[t].value)
                dynamic.setPush(times[t], ops[t].value)
                monoid.setPush(times[t], ops[t].value)
            else:
                fixed.setPop(t)
                compressed.setPop(times[t])
                dynamic.setPop(times[t])
                monoid.setPop(times[t])
            let expected = replay(ops, order)
            var mapped, active: seq[QueueDebugEntry[Time, Item]]
            for entry in expected:
                var converted = QueueDebugEntry[Time, Item](time: times[entry.time], kind: entry.kind, value: entry.value)
                if entry.popped.isSome:
                    let popped = entry.popped.get
                    converted.popped = some((time: times[popped.time], value: popped.value))
                mapped.add(converted)
                if entry.kind != qdkNone: active.add(converted)
            let savedFold = monoid.fold()
            let savedLen = dynamic.len
            let savedPeek = dynamic.peek()
            doAssert fixed.debugTimeline() == expected
            doAssert compressed.debugTimeline() == mapped
            doAssert dynamic.debugTimeline() == active
            doAssert monoid.debugTimeline() == active
            var simpleExpected = expected
            var simpleMapped = mapped
            var simpleActive = active
            for entry in simpleExpected.mitems: entry.popped = none(tuple[time: int, value: Item])
            for entry in simpleMapped.mitems: entry.popped = none(tuple[time: Time, value: Item])
            for entry in simpleActive.mitems: entry.popped = none(tuple[time: Time, value: Item])
            doAssert fixed.debugOperations() == simpleExpected
            doAssert compressed.debugOperations() == simpleMapped
            doAssert dynamic.debugOperations() == simpleActive
            doAssert monoid.debugOperations() == simpleActive
            doAssert monoid.fold() == savedFold and dynamic.len == savedLen and dynamic.peek() == savedPeek
            doAssert fixed.len == savedLen and compressed.len == savedLen and monoid.len == savedLen
            doAssert fixed.peek() == savedPeek and compressed.peek() == savedPeek and monoid.peek() == savedPeek
            for i in 0..<n:
                doAssert fixed.isRemaining(i) == dynamic.isRemaining(times[i])
                doAssert compressed.isRemaining(times[i]) == monoid.isRemaining(times[i])
            doAssert dynamic.debugTimeline() == active

block:
    doAssert initRetroactivePriorityQueue[int](0).debugTimeline().len == 0
    doAssert initCompressedRetroactivePriorityQueue[int, int](@[]).debugOperations().len == 0
    doAssert initDynamicRetroactivePriorityQueue[int, int]().debugTimeline().len == 0
    let pq = initDynamicRetroactivePriorityQueue[int, int]()
    pq.setPush(low(int), 1)
    pq.setPop(-1)
    pq.setPush(0, 5)
    pq.setPop(high(int))
    let entries = pq.debugTimeline()
    doAssert entries[1].popped.get == (time: low(int), value: 1)
    doAssert entries[3].popped.get == (time: 0, value: 5)
    doAssert pq.sum == 0
    pq.erase(-1)
    doAssert pq.debugTimeline()[2].popped.get == (time: low(int), value: 1)
    doAssert pq.sum == 5
    pq.erase(low(int))
    pq.erase(0)
    pq.erase(high(int))
    doAssert pq.debugTimeline().len == 0
    pq.setPop(3)
    doAssert pq.debugTimeline()[0].popped.isNone

block:
    let pq = initRetroactivePriorityQueue[int](4)
    pq.setPush(0, 2)
    pq.setPush(1, 2)
    pq.setPop(2)
    pq.setPop(3)
    var snapshot = pq.debugTimeline()
    doAssert snapshot[2].popped.get.time == 0
    doAssert snapshot[3].popped.get.time == 1
    snapshot[0].value = some(99)
    doAssert pq.debugTimeline()[0].value.get == 2

block:
    let pq = initRetroactivePriorityQueue[int](6)
    pq.setPush(1, 4)
    pq.setPop(2)
    pq.setPop(3)
    pq.setPush(4, 9)
    doAssert pq.debugDump() == "0: noop\n1: push(4)\n2: pop -> 4 (push at 1)\n3: pop -> empty\n4: push(9)\n5: noop"
    let compressed = initCompressedRetroactivePriorityQueue[int, int](@[30, 10, 20])
    compressed.setPush(10, 7)
    compressed.setPop(30)
    doAssert compressed.debugDump() == "10: push(7)\n20: noop\n30: pop -> 7 (push at 10)"
    let dynamic = initDynamicRetroactivePriorityQueue[int, int]()
    dynamic.setPush(10, 7)
    dynamic.setPop(30)
    doAssert dynamic.debugDump() == "10: push(7)\n30: pop -> 7 (push at 10)"
    let monoid = initDynamicRetroactivePriorityQueueMonoid[int, int, int](
        proc(a, b: int): int = max(a, b), low(int), proc(x: int): int = x)
    monoid.setPush(10, 7)
    monoid.setPop(30)
    doAssert monoid.debugDump() == dynamic.debugDump()
    doAssert initDynamicRetroactivePriorityQueue[int, int]().debugDump() == ""

echo "Hello World"
