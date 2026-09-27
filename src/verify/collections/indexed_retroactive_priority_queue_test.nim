# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, options, random
import cplib/collections/indexed_retroactive_priority_queue
import cplib/collections/retroactive_priority_queue

type
    Operation = tuple[push: bool, value: int64]
    Item = object
        priority: int
        label: string
proc `<`(a, b: Item): bool = a.priority < b.priority

proc check(pq: IndexedRetroactivePriorityQueue[int64], ops: seq[Operation], order: SortOrder) =
    var live, pushes, pops: seq[int]
    var taken = 0'i64
    var timeline: seq[QueueDebugEntry[int, int64]]
    for t, op in ops:
        var entry = QueueDebugEntry[int, int64](time: t)
        if op.push:
            entry.kind = qdkPush
            entry.value = some(op.value)
            live.add(t)
            pushes.add(t)
        else:
            entry.kind = qdkPop
            pops.add(t)
            if live.len > 0:
                var best = 0
                for j in 1..<live.len:
                    let a = ops[live[j]].value
                    let b = ops[live[best]].value
                    if (order == Ascending and a < b) or (order == Descending and b < a): best = j
                let source = live[best]
                taken += ops[source].value
                entry.popped = some((time: source, value: ops[source].value))
                live.delete(best)
        timeline.add(entry)
    doAssert pq.operationCount == ops.len and pq.pushCount == pushes.len and pq.popCount == pops.len
    for k, t in pushes: doAssert pq.pushIndex(k) == t
    for k, t in pops: doAssert pq.popIndex(k) == t
    doAssert pq.debugTimeline() == timeline
    for i in 0..<ops.len: doAssert pq.isRemaining(i) == (i in live)
    var total = 0'i64
    var top = none(int64)
    for i in live:
        total += ops[i].value
        if top.isNone or (order == Ascending and ops[i].value < top.get) or
                (order == Descending and top.get < ops[i].value): top = some(ops[i].value)
    doAssert pq.sum == total and pq.poppedSum == taken and pq.len == live.len and pq.peek() == top

var rng = initRand(36329)
for order in [Ascending, Descending]:
    for trial in 0..<40:
        let pq = initIndexedRetroactivePriorityQueue[int64](order)
        var ops: seq[Operation]
        pq.check(ops, order)
        for step in 0..<1000:
            let action = if ops.len == 0: rng.rand(1) else: rng.rand(6)
            let value = int64(rng.rand(-3..3))
            if ops.len > 80:
                let i = rng.rand(ops.high)
                pq.erase(i)
                ops.delete(i)
            elif action <= 1:
                let i = rng.rand(ops.len)
                if action == 0: pq.insertPush(i, value)
                else: pq.insertPop(i)
                ops.insert((action == 0, value), i)
            elif action == 2:
                let i = rng.rand(ops.high)
                pq.erase(i)
                ops.delete(i)
            elif action == 3:
                let i = rng.rand(ops.high)
                pq.setPush(i, value)
                ops[i] = (true, value)
            elif action == 4:
                let i = rng.rand(ops.high)
                pq.setPop(i)
                ops[i] = (false, 0'i64)
            elif action == 5:
                var indices: seq[int]
                for i, op in ops:
                    if not op.push: indices.add(i)
                if indices.len > 0:
                    let k = rng.rand(indices.high)
                    pq.insertPushBeforePop(k, value)
                    ops.insert((true, value), indices[k])
            else:
                var indices: seq[int]
                for i, op in ops:
                    if op.push: indices.add(i)
                if indices.len > 0:
                    let k = rng.rand(indices.high)
                    pq.insertPopBeforePush(k)
                    ops.insert((false, 0'i64), indices[k])
            pq.check(ops, order)
        while ops.len > 0:
            let i = rng.rand(ops.high)
            pq.erase(i)
            ops.delete(i)
            pq.check(ops, order)

block:
    let pq = initIndexedRetroactivePriorityQueue[Item]()
    pq.insertPop(0)
    pq.insertPushBeforePop(0, Item(priority: 1, label: "old"))
    pq.insertPush(0, Item(priority: 1, label: "first"))
    doAssert pq.peek().get.label == "old"
    pq.insertPopBeforePush(1)
    doAssert pq.peek().isNone
    let timeline = pq.debugTimeline()
    doAssert timeline[1].popped.get.value.label == "first"
    doAssert timeline[3].popped.get.value.label == "old"
    pq.erase(1)
    doAssert pq.peek().get.label == "old"

block:
    let pq = initIndexedRetroactivePriorityQueue[int64]()
    const n = 20000
    for i in 0..<n: pq.insertPop(pq.operationCount)
    for i in 0..<n: pq.insertPushBeforePop(i, 1)
    doAssert pq.popCount == n and pq.pushCount == n and pq.poppedSum == n and pq.len == 0
    for i in countdown(n - 1, 0):
        doAssert pq.popIndex(i) == 2 * i + 1
        pq.erase(pq.popIndex(i))
    doAssert pq.sum == n and pq.poppedSum == 0
    for i in 0..<n: pq.erase(0)
    doAssert pq.operationCount == 0
    for i in 0..<n: pq.insertPush(0, 1)
    for i in 0..<n: pq.insertPopBeforePush(i)
    doAssert pq.poppedSum == n - 1 and pq.sum == 1

for order in [Ascending, Descending]:
    let pq = initIndexedRetroactivePriorityQueue[int64](order)
    var ops: seq[Operation]
    var ids: seq[int]
    var nextId = 0
    for step in 0..<2500:
        let action = if ids.len == 0: 0 else: rng.rand(4)
        if action == 0 and ids.len < 60:
            let pos = rng.rand(ids.len)
            let value = int64(rng.rand(-10..10))
            let push = rng.rand(1) == 0
            let id = if push: pq.insertPush(pos, value) else: pq.insertPop(pos)
            doAssert id == nextId
            inc nextId
            ids.insert(id, pos)
            ops.insert((push, value), pos)
        elif action == 1 and ids.len > 0:
            let pos = rng.rand(ids.high)
            let id = ids[pos]
            pq.eraseById(id)
            ids.delete(pos)
            ops.delete(pos)
            doAssert pq.indexOf(id) == -1
            pq.eraseById(id)
        elif action == 2 and ids.len > 0:
            let pos = rng.rand(ids.high)
            let id = ids[pos]
            pq.erase(pos)
            ids.delete(pos)
            ops.delete(pos)
            doAssert pq.indexOf(id) == -1
        elif ids.len > 0:
            let pos = rng.rand(ids.high)
            if action == 3:
                pq.setPush(pos, 7)
                ops[pos] = (true, 7'i64)
            else:
                pq.setPop(pos)
                ops[pos] = (false, 0'i64)
        for pos, id in ids: doAssert pq.indexOf(id) == pos
        doAssert pq.indexOf(-1) == -1 and pq.indexOf(nextId) == -1
        pq.eraseById(nextId)
        pq.check(ops, order)

block:
    let pq = initIndexedRetroactivePriorityQueue[int]()
    let popId = pq.insertPop(0)
    let pushId = pq.insertPushBeforePop(0, 10)
    let emptyPopId = pq.insertPopBeforePush(0)
    doAssert popId == 0 and pushId == 1 and emptyPopId == 2
    doAssert pq.indexOf(popId) == 2 and pq.indexOf(pushId) == 1
    pq.eraseById(emptyPopId)
    pq.eraseById(pushId)
    doAssert pq.poppedSum == 0 and pq.operationCount == 1
    let newId = pq.insertPushBeforePop(0, 20)
    doAssert newId == 3 and pq.indexOf(pushId) == -1
    pq.eraseById(pushId)
    doAssert pq.poppedSum == 20
    pq.eraseById(popId)
    doAssert pq.sum == 20

when compileOption("assertions"):
    template rejects(body: untyped) =
        block:
            var rejected = false
            try: body
            except AssertionDefect: rejected = true
            doAssert rejected
    let pq = initIndexedRetroactivePriorityQueue[int]()
    rejects: pq.insertPushBeforePop(0, 1)
    rejects: pq.insertPopBeforePush(0)
    rejects: pq.insertPop(-1)
    rejects: pq.insertPush(1, 1)
    rejects: pq.setPush(0, 1)
    rejects: pq.setPop(0)
    rejects: pq.erase(0)
    pq.insertPop(0)
    rejects: pq.insertPushBeforePop(1, 1)
    rejects: discard pq.popIndex(-1)
    rejects: discard pq.pushIndex(0)

echo "Hello World"
