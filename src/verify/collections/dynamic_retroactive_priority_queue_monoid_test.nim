# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, options, random, tables
import cplib/collections/dynamic_retroactive_priority_queue_monoid

type
    Item = object
        priority: int
        label: string
    Operation = tuple[kind: int, value: Item]

proc `<`(a, b: Item): bool = a.priority < b.priority
proc concat(a, b: string): string = a & b
proc label(x: Item): string = x.label

proc replay(ops: seq[Operation], order: SortOrder): seq[int] =
    for t, op in ops:
        if op.kind == 1: result.add(t)
        elif op.kind == 2 and result.len > 0:
            var best = 0
            for j in 1..<result.len:
                let a = ops[result[j]].value.priority
                let b = ops[result[best]].value.priority
                if (order == Ascending and a < b) or (order == Descending and b < a): best = j
            result.delete(best)

var rng = initRand(36390)
for order in [Ascending, Descending]:
    for trial in 0..<40:
        let pq = initDynamicRetroactivePriorityQueueMonoid[int, Item, string](concat, "", label, order)
        doAssert pq.fold() == "" and pq.len == 0 and pq.peek().isNone
        var ops = newSeq[Operation](40)
        var previous = initTable[int, Item]()
        for step in 0..<500:
            let t = rng.rand(39)
            ops[t] = (rng.rand(2), Item(priority: rng.rand(-3..3), label: $step & ","))
            let delta = case ops[t].kind
                of 0: pq.erase(t * 17 - 500)
                of 1: pq.setPush(t * 17 - 500, ops[t].value)
                else: pq.setPop(t * 17 - 500)
            for entry in delta.removed:
                doAssert previous.hasKey(entry.time) and previous[entry.time] == entry.value
                previous.del(entry.time)
            for entry in delta.added:
                doAssert not previous.hasKey(entry.time)
                previous[entry.time] = entry.value
            let expected = replay(ops, order)
            var joined = ""
            var top = none(Item)
            for i in expected:
                joined.add(ops[i].value.label)
                doAssert previous[i * 17 - 500] == ops[i].value
                if top.isNone or (order == Ascending and ops[i].value < top.get) or
                        (order == Descending and top.get < ops[i].value): top = some(ops[i].value)
            doAssert pq.fold() == joined and pq.get_all() == joined
            doAssert pq.len == expected.len and previous.len == expected.len
            doAssert pq.peek() == top
            for i in 0..<ops.len: doAssert pq.isRemaining(i * 17 - 500) == (i in expected)
        for t in 0..<ops.len: pq.erase(t * 17 - 500)
        doAssert pq.fold() == "" and pq.len == 0
        pq.setPush(low(int), Item(priority: 1, label: "a"))
        pq.setPush(high(int), Item(priority: 1, label: "b"))
        doAssert pq.fold() == "ab"

block:
    let pq = initDynamicRetroactivePriorityQueueMonoid[int, uint64, uint64](
        proc(a, b: uint64): uint64 = max(a, b), 0'u64, proc(x: uint64): uint64 = x)
    pq.setPush(1, high(uint64))
    pq.setPush(2, high(uint64))
    doAssert pq.fold() == high(uint64)
    pq.setPop(3)
    doAssert pq.fold() == high(uint64)
    pq.setPop(4)
    doAssert pq.fold() == 0
    pq.erase(3)
    doAssert pq.fold() == high(uint64)

block:
    type Affine = tuple[a, b: int64]
    const modulus = 998244353'i64
    proc compose(x, y: Affine): Affine =
        ((x.a * y.a) mod modulus, (x.b * y.a + y.b) mod modulus)
    proc lift(x: int): Affine = (int64(x + 2), int64(x + 1))
    let pq = initDynamicRetroactivePriorityQueueMonoid[int, int, Affine](compose, (1'i64, 0'i64), lift)
    var vals = initTable[int, int]()
    for i in 0..<3000:
        let t = rng.rand(-10000..10000)
        let value = rng.rand(100)
        pq.setPush(t, value)
        vals[t] = value
    var times: seq[int]
    for t in vals.keys: times.add(t)
    times.sort()
    var expected: Affine = (1'i64, 0'i64)
    for t in times: expected = compose(expected, lift(vals[t]))
    doAssert pq.fold() == expected
    rng.shuffle(times)
    for i, t in times:
        pq.erase(t)
        vals.del(t)
        if i mod 100 == 0:
            var sortedTimes: seq[int]
            for key in vals.keys: sortedTimes.add(key)
            sortedTimes.sort()
            expected = (1'i64, 0'i64)
            for key in sortedTimes: expected = compose(expected, lift(vals[key]))
            doAssert pq.fold() == expected
    doAssert pq.fold() == (1'i64, 0'i64)

block:
    let factor = 3
    let pq = initDynamicRetroactivePriorityQueueMonoid[string, int, int](
        proc(a, b: int): int = a + b, 0, proc(x: int): int = x * factor)
    pq.setPop("z")
    pq.setPush("a", 2)
    pq.setPush("b", 5)
    doAssert pq.fold() == 15
    pq.setPush("b", 1)
    doAssert pq.fold() == 6
    pq.erase("z")
    doAssert pq.fold() == 9

echo "Hello World"
