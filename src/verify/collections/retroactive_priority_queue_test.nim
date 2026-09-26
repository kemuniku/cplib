# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, options, random, tables
import cplib/collections/retroactive_priority_queue
import cplib/collections/compressed_retroactive_priority_queue

type
    Operation = tuple[kind: int, value: int64]
    Item = object
        key: int
        label: string

proc `<`(a, b: Item): bool = a.key < b.key

proc replay(ops: seq[Operation], order: SortOrder): seq[int] =
    for t, op in ops:
        if op.kind == 1:
            result.add(t)
        elif op.kind == 2 and result.len > 0:
            var best = 0
            for i in 1..<result.len:
                let a = result[i]
                let b = result[best]
                if (order == Ascending and ops[a].value < ops[b].value) or
                        (order == Descending and ops[b].value < ops[a].value):
                    best = i
            result.delete(best)

proc apply(pq: RetroactivePriorityQueue[int64], t: int, op: Operation): QueueDelta[int, int64] =
    case op.kind
    of 0: pq.erase(t)
    of 1: pq.setPush(t, op.value)
    else: pq.setPop(t)

proc check(pq: RetroactivePriorityQueue[int64], ops: seq[Operation], order: SortOrder,
        delta: QueueDelta[int, int64], previous: var Table[int, int64]) =
    for entry in delta.removed:
        doAssert previous.hasKey(entry.time)
        doAssert previous[entry.time] == entry.value
        previous.del(entry.time)
    for entry in delta.added:
        doAssert not previous.hasKey(entry.time)
        previous[entry.time] = entry.value
    let expected = replay(ops, order)
    doAssert pq.len == expected.len
    doAssert previous.len == expected.len
    var total = 0'i64
    var top = none(int64)
    for t in expected:
        total += ops[t].value
        doAssert previous.hasKey(t) and previous[t] == ops[t].value
        if top.isNone or (order == Ascending and ops[t].value < top.get) or
                (order == Descending and top.get < ops[t].value):
            top = some(ops[t].value)
    doAssert pq.sum == total
    doAssert pq.peek() == top
    for t in 0..<ops.len:
        doAssert pq.isRemaining(t) == (t in expected)

let choices: seq[Operation] = @[(0, 0'i64), (2, 0'i64), (1, -1'i64), (1, 0'i64), (1, 1'i64)]
for order in [Ascending, Descending]:
    for state in 0..<625:
        var pq = initRetroactivePriorityQueue[int64](4, order)
        var ops = newSeq[Operation](4)
        var previous = initTable[int, int64]()
        var code = state
        for t in 0..<4:
            ops[t] = choices[code mod 5]
            code = code div 5
            let delta = pq.apply(t, ops[t])
            pq.check(ops, order, delta, previous)
        for t in 0..<4:
            let old = ops[t]
            for op in choices:
                ops[t] = op
                let delta = pq.apply(t, op)
                pq.check(ops, order, delta, previous)
            ops[t] = old
            let delta = pq.apply(t, old)
            pq.check(ops, order, delta, previous)

var rng = initRand(3631213)
for order in [Ascending, Descending]:
    for trial in 0..<100:
        let n = rng.rand(1..70)
        var pq = initRetroactivePriorityQueue[int64](n, order)
        var ops = newSeq[Operation](n)
        var previous = initTable[int, int64]()
        for step in 0..<500:
            let t = rng.rand(n - 1)
            ops[t] = (rng.rand(2), int64(rng.rand(-20..20)))
            let delta = pq.apply(t, ops[t])
            pq.check(ops, order, delta, previous)

for order in [Ascending, Descending]:
    var pq = initRetroactivePriorityQueue[int64](5, order)
    pq.setPop(0)
    pq.setPop(2)
    pq.setPop(4)
    pq.setPush(3, high(int64))
    doAssert pq.len == 0
    pq.setPush(1, low(int64))
    doAssert pq.len == 0
    pq.erase(4)
    doAssert pq.sum == high(int64)
    pq.setPush(1, high(int64))
    doAssert pq.sum == high(int64)
    pq.erase(3)
    doAssert pq.len == 0
    pq.setPush(3, low(int64))
    doAssert pq.sum == low(int64)
    pq.setPop(3)
    doAssert pq.peek().isNone

block:
    let pq = initRetroactivePriorityQueue[int64](0)
    doAssert pq.len == 0 and pq.sum == 0 and pq.peek().isNone
    let compressed = initCompressedRetroactivePriorityQueue[int, int64](@[])
    doAssert compressed.len == 0 and compressed.sum == 0 and compressed.peek().isNone
    doAssert not compressed.isRemaining(0)

block:
    var pq = initRetroactivePriorityQueue[string](4)
    pq.setPush(0, "same")
    pq.setPush(1, "same")
    pq.setPush(2, "abc")
    pq.setPop(3)
    doAssert pq.peek() == some("same")
    doAssert pq.isRemaining(0) and pq.isRemaining(1)
    pq.setPop(2)
    doAssert pq.len == 0
    let delta = pq.erase(3)
    doAssert delta.added == @[(time: 1, value: "same")]
    doAssert not pq.isRemaining(0) and pq.isRemaining(1)

block:
    type Time = tuple[day, id: int]
    let times: seq[Time] = @[(3, 0), (1, 0), (1, 1), (2, 0), (1, 0)]
    var pq = initCompressedRetroactivePriorityQueue[Time, int64](times, Descending)
    pq.setPop((1, 1))
    pq.setPush((1, 0), 100)
    pq.setPush((2, 0), 20)
    pq.setPush((3, 0), 30)
    doAssert pq.sum == 50 and pq.len == 2 and pq.peek() == some(30'i64)
    doAssert not pq.isRemaining((1, 0)) and not pq.isRemaining((2, 1))
    let delta = pq.erase((1, 1))
    doAssert delta.added == @[(time: (1, 0), value: 100'i64)]
    doAssert pq.sum == 150
    pq.setPop((3, 0))
    doAssert pq.sum == 20 and pq.len == 1

block:
    var times: seq[int]
    for i in 0..<100: times.add(i * 7 - 300)
    rng.shuffle(times)
    var pq = initCompressedRetroactivePriorityQueue[int, int64](times)
    for t in times: pq.setPush(t, int64(t))
    doAssert pq.len == 100 and pq.sum == 4650
    for t in times: pq.erase(t)
    doAssert pq.len == 0 and pq.sum == 0

block:
    var times = @[low(int), high(int)]
    for i in 0..<3000: times.add(i * 7 - 10000)
    rng.shuffle(times)
    let pq = initCompressedRetroactivePriorityQueue[int, int64](times)
    pq.setPop(high(int))
    pq.setPush(low(int), 50)
    doAssert pq.len == 0
    pq.erase(high(int))
    doAssert pq.sum == 50 and pq.isRemaining(low(int))

for order in [Ascending, Descending]:
    type Time = tuple[day, id: int]
    var times: seq[Time]
    for i in 0..<53: times.add((i div 3 - 8, i mod 3))
    var registration = times
    rng.shuffle(registration)
    registration.add(times[0])
    let pq = initCompressedRetroactivePriorityQueue[Time, int64](registration, order)
    var ops = newSeq[Operation](times.len)
    var previous = initTable[Time, int64]()
    for step in 0..<2000:
        let t = rng.rand(times.high)
        ops[t] = (rng.rand(2), int64(rng.rand(-20..20)))
        let delta = case ops[t].kind
            of 0: pq.erase(times[t])
            of 1: pq.setPush(times[t], ops[t].value)
            else: pq.setPop(times[t])
        for entry in delta.removed:
            doAssert previous.hasKey(entry.time) and previous[entry.time] == entry.value
            previous.del(entry.time)
        for entry in delta.added:
            doAssert not previous.hasKey(entry.time)
            previous[entry.time] = entry.value
        let expected = replay(ops, order)
        var total = 0'i64
        for i in expected:
            total += ops[i].value
            doAssert previous.hasKey(times[i]) and previous[times[i]] == ops[i].value
        doAssert pq.sum == total and pq.len == expected.len and previous.len == expected.len
        for i in 0..<times.len:
            doAssert pq.isRemaining(times[i]) == (i in expected)

block:
    let pq = initRetroactivePriorityQueue[Item](3, Descending)
    pq.setPush(1, Item(key: 7, label: "later"))
    pq.setPush(0, Item(key: 7, label: "earlier"))
    pq.setPop(2)
    doAssert pq.peek().get.label == "later"
    doAssert pq.isRemaining(1) and not pq.isRemaining(0)

block:
    let pq = initRetroactivePriorityQueue[uint64](2, Descending)
    pq.setPush(0, high(uint64))
    doAssert pq.sum == high(uint64)
    pq.setPop(1)
    doAssert pq.sum == 0 and pq.peek().isNone
    pq.erase(1)
    doAssert pq.sum == high(uint64)
    let floats = initRetroactivePriorityQueue[float64](3)
    floats.setPush(0, 1.5)
    floats.setPush(1, 2.5)
    floats.setPop(2)
    doAssert floats.sum == 2.5

when compileOption("assertions"):
    template rejects(body: untyped) =
        block:
            var rejected = false
            try:
                body
            except AssertionDefect:
                rejected = true
            doAssert rejected
    rejects:
        discard initRetroactivePriorityQueue[int](-1)
    rejects:
        initRetroactivePriorityQueue[int](0).setPop(0)
    rejects:
        initRetroactivePriorityQueue[int](2).setPush(-1, 0)
    rejects:
        initRetroactivePriorityQueue[int](2).erase(2)
    rejects:
        discard initRetroactivePriorityQueue[int](2).isRemaining(2)
    rejects:
        initCompressedRetroactivePriorityQueue[int, int](@[1, 2]).setPush(3, 0)
    rejects:
        initCompressedRetroactivePriorityQueue[int, int](@[1, 2]).setPop(0)
    rejects:
        initCompressedRetroactivePriorityQueue[int, int](@[1, 2]).erase(3)

echo "Hello World"
