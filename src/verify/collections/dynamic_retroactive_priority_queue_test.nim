# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, options, random, tables
import cplib/collections/dynamic_retroactive_priority_queue
import cplib/collections/retroactive_priority_queue

type
    Operation = tuple[kind: int, value: int64]
    Time = tuple[day, id: int]
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
            for j in 1..<result.len:
                let a = ops[result[j]].value
                let b = ops[result[best]].value
                if (order == Ascending and a < b) or (order == Descending and b < a):
                    best = j
            result.delete(best)

proc apply(pq: DynamicRetroactivePriorityQueue[int, int64], t: int,
        op: Operation): QueueDelta[int, int64] =
    case op.kind
    of 0: pq.erase(t)
    of 1: pq.setPush(t, op.value)
    else: pq.setPop(t)

proc check(pq: DynamicRetroactivePriorityQueue[int, int64], times: seq[int],
        ops: seq[Operation], order: SortOrder, delta: QueueDelta[int, int64],
        previous: var Table[int, int64]) =
    for entry in delta.removed:
        doAssert previous.hasKey(entry.time) and previous[entry.time] == entry.value
        previous.del(entry.time)
    for entry in delta.added:
        doAssert not previous.hasKey(entry.time)
        previous[entry.time] = entry.value
    let expected = replay(ops, order)
    doAssert pq.len == expected.len and previous.len == expected.len
    var total = 0'i64
    var top = none(int64)
    for t in expected:
        total += ops[t].value
        doAssert previous.hasKey(times[t]) and previous[times[t]] == ops[t].value
        if top.isNone or (order == Ascending and ops[t].value < top.get) or
                (order == Descending and top.get < ops[t].value):
            top = some(ops[t].value)
    doAssert pq.sum == total and pq.peek() == top
    for t in 0..<ops.len:
        doAssert pq.isRemaining(times[t]) == (t in expected)

let choices: seq[Operation] = @[(0, 0'i64), (2, 0'i64), (1, -1'i64), (1, 0'i64), (1, 1'i64)]
let tinyTimes = @[low(int), -1, 0, high(int)]
for order in [Ascending, Descending]:
    for state in 0..<625:
        let pq = initDynamicRetroactivePriorityQueue[int, int64](order)
        var ops = newSeq[Operation](4)
        var previous = initTable[int, int64]()
        var code = state
        for t in 0..<4:
            ops[t] = choices[code mod 5]
            code = code div 5
            pq.check(tinyTimes, ops, order, pq.apply(tinyTimes[t], ops[t]), previous)
        for t in 0..<4:
            let old = ops[t]
            for op in choices:
                ops[t] = op
                pq.check(tinyTimes, ops, order, pq.apply(tinyTimes[t], op), previous)
            ops[t] = old
            pq.check(tinyTimes, ops, order, pq.apply(tinyTimes[t], old), previous)

var rng = initRand(3631213)
for order in [Ascending, Descending]:
    for trial in 0..<100:
        let n = rng.rand(1..80)
        let pq = initDynamicRetroactivePriorityQueue[int, int64](order)
        var times = newSeq[int](n)
        for i in 0..<n: times[i] = i * 17 - 600
        var ops = newSeq[Operation](n)
        var previous = initTable[int, int64]()
        for step in 0..<500:
            let t = rng.rand(n - 1)
            ops[t] = (rng.rand(2), int64(rng.rand(-20..20)))
            pq.check(times, ops, order, pq.apply(times[t], ops[t]), previous)
        for t in countdown(n - 1, 0):
            ops[t] = (0, 0'i64)
            pq.check(times, ops, order, pq.erase(times[t]), previous)

block:
    let pq = initDynamicRetroactivePriorityQueue[string, Item](Descending)
    pq.setPop("z")
    pq.setPush("b", Item(key: 7, label: "later"))
    pq.setPush("a", Item(key: 7, label: "earlier"))
    doAssert pq.peek().get.label == "later"
    doAssert not pq.isRemaining("a") and pq.isRemaining("b")
    let delta = pq.erase("z")
    doAssert delta.added.len == 1 and delta.added[0].time == "a"
    doAssert pq.peek().get.label == "earlier"
    pq.erase("a")
    pq.erase("b")
    doAssert pq.peek().isNone and pq.len == 0
    doAssert pq.erase("missing").removed.len == 0

block:
    let pq = initDynamicRetroactivePriorityQueue[int, uint64]()
    pq.setPop(high(int))
    pq.setPush(low(int), high(uint64))
    doAssert pq.sum == 0
    pq.erase(high(int))
    doAssert pq.sum == high(uint64)
    let floats = initDynamicRetroactivePriorityQueue[int, float64]()
    floats.setPush(1, 1.5)
    floats.setPush(2, 2.5)
    floats.setPop(3)
    doAssert floats.sum == 2.5

for trial in 0..<100:
    let n = rng.rand(1..8)
    let pq = initDynamicRetroactivePriorityQueue[Time, int64](Descending)
    var d = newSeq[int](n)
    var p = newSeq[int64](n)
    var total = 0'i64
    for day in 1..n: pq.setPop((n - day, n))
    for i in 0..<n:
        d[i] = rng.rand(1..n)
        p[i] = int64(rng.rand(1..100))
        pq.setPush((n - d[i], i), p[i])
        total += p[i]
    for step in 0..<100:
        let c = rng.rand(n - 1)
        pq.erase((n - d[c], c))
        total -= p[c]
        d[c] = rng.rand(1..n)
        p[c] = int64(rng.rand(1..100))
        total += p[c]
        pq.setPush((n - d[c], c), p[c])
        var best = 0'i64
        for mask in 0..<(1 shl n):
            var deadlines: seq[int]
            var reward = 0'i64
            for i in 0..<n:
                if (mask and (1 shl i)) != 0:
                    deadlines.add(d[i])
                    reward += p[i]
            deadlines.sort()
            var valid = true
            for i, deadline in deadlines:
                if deadline < i + 1: valid = false
            if valid: best = max(best, reward)
        doAssert total - pq.sum == best

block:
    let pq = initDynamicRetroactivePriorityQueue[int, int64]()
    const n = 20000
    for i in 0..<n: pq.setPush(i, int64(i))
    doAssert pq.len == n and pq.sum == int64(n) * (n - 1) div 2
    for i in 0..<n: pq.erase(i)
    doAssert pq.len == 0 and pq.peek().isNone
    for i in countdown(n - 1, 0): pq.setPop(i)
    for i in countdown(n - 1, 0): pq.setPush(i, int64(i))
    doAssert pq.len == n and pq.sum == int64(n) * (n - 1) div 2
    for i in countdown(n - 1, 0): pq.erase(i)
    doAssert pq.len == 0

echo "Hello World"
