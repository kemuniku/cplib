---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_coordinates_internal.nim
    title: cplib/collections/compressed_coordinates_internal.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_coordinates_internal.nim
    title: cplib/collections/compressed_coordinates_internal.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_retroactive_priority_queue.nim
    title: cplib/collections/compressed_retroactive_priority_queue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_retroactive_priority_queue.nim
    title: cplib/collections/compressed_retroactive_priority_queue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dynamic_retroactive_priority_queue.nim
    title: cplib/collections/dynamic_retroactive_priority_queue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dynamic_retroactive_priority_queue.nim
    title: cplib/collections/dynamic_retroactive_priority_queue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dynamic_retroactive_priority_queue_monoid.nim
    title: cplib/collections/dynamic_retroactive_priority_queue_monoid.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dynamic_retroactive_priority_queue_monoid.nim
    title: cplib/collections/dynamic_retroactive_priority_queue_monoid.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/retroactive_priority_queue.nim
    title: cplib/collections/retroactive_priority_queue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/retroactive_priority_queue.nim
    title: cplib/collections/retroactive_priority_queue.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    import algorithm, options, random\nimport cplib/collections/retroactive_priority_queue\n\
    import cplib/collections/compressed_retroactive_priority_queue\nimport cplib/collections/dynamic_retroactive_priority_queue\n\
    import cplib/collections/dynamic_retroactive_priority_queue_monoid\n\ntype\n \
    \   Item = object\n        priority: int\n        label: string\n    Time = tuple[day,\
    \ id: int]\n    Operation = tuple[kind: int, value: Item]\n\nproc `<`(a, b: Item):\
    \ bool = a.priority < b.priority\n\nproc replay(ops: seq[Operation], order: SortOrder):\
    \ seq[QueueDebugEntry[int, Item]] =\n    var live: seq[int]\n    for t, op in\
    \ ops:\n        var entry = QueueDebugEntry[int, Item](time: t, kind: QueueDebugKind(op.kind))\n\
    \        if op.kind == 1:\n            entry.value = some(op.value)\n        \
    \    live.add(t)\n        elif op.kind == 2 and live.len > 0:\n            var\
    \ best = 0\n            for j in 1..<live.len:\n                let a = ops[live[j]].value\n\
    \                let b = ops[live[best]].value\n                if (order == Ascending\
    \ and a < b) or (order == Descending and b < a): best = j\n            let source\
    \ = live[best]\n            entry.popped = some((time: source, value: ops[source].value))\n\
    \            live.delete(best)\n        result.add(entry)\n\nvar rng = initRand(3632026)\n\
    for order in [Ascending, Descending]:\n    for trial in 0..<20:\n        let n\
    \ = rng.rand(1..40)\n        var times: seq[Time]\n        for i in 0..<n: times.add((i\
    \ div 3 - 10, i mod 3))\n        var registration = times\n        rng.shuffle(registration)\n\
    \        let fixed = initRetroactivePriorityQueue[Item](n, order)\n        let\
    \ compressed = initCompressedRetroactivePriorityQueue[Time, Item](registration,\
    \ order)\n        let dynamic = initDynamicRetroactivePriorityQueue[Time, Item](order)\n\
    \        let monoid = initDynamicRetroactivePriorityQueueMonoid[Time, Item, string](\n\
    \            proc(a, b: string): string = a & b, \"\", proc(x: Item): string =\
    \ x.label, order)\n        var ops = newSeq[Operation](n)\n        for step in\
    \ 0..<150:\n            let t = rng.rand(n - 1)\n            ops[t] = (rng.rand(2),\
    \ Item(priority: rng.rand(-2..2), label: $step & \",\"))\n            case ops[t].kind\n\
    \            of 0:\n                fixed.erase(t)\n                compressed.erase(times[t])\n\
    \                dynamic.erase(times[t])\n                monoid.erase(times[t])\n\
    \            of 1:\n                fixed.setPush(t, ops[t].value)\n         \
    \       compressed.setPush(times[t], ops[t].value)\n                dynamic.setPush(times[t],\
    \ ops[t].value)\n                monoid.setPush(times[t], ops[t].value)\n    \
    \        else:\n                fixed.setPop(t)\n                compressed.setPop(times[t])\n\
    \                dynamic.setPop(times[t])\n                monoid.setPop(times[t])\n\
    \            let expected = replay(ops, order)\n            var mapped, active:\
    \ seq[QueueDebugEntry[Time, Item]]\n            for entry in expected:\n     \
    \           var converted = QueueDebugEntry[Time, Item](time: times[entry.time],\
    \ kind: entry.kind, value: entry.value)\n                if entry.popped.isSome:\n\
    \                    let popped = entry.popped.get\n                    converted.popped\
    \ = some((time: times[popped.time], value: popped.value))\n                mapped.add(converted)\n\
    \                if entry.kind != qdkNone: active.add(converted)\n           \
    \ let savedFold = monoid.fold()\n            let savedLen = dynamic.len\n    \
    \        let savedPeek = dynamic.peek()\n            doAssert fixed.debugTimeline()\
    \ == expected\n            doAssert compressed.debugTimeline() == mapped\n   \
    \         doAssert dynamic.debugTimeline() == active\n            doAssert monoid.debugTimeline()\
    \ == active\n            var simpleExpected = expected\n            var simpleMapped\
    \ = mapped\n            var simpleActive = active\n            for entry in simpleExpected.mitems:\
    \ entry.popped = none(tuple[time: int, value: Item])\n            for entry in\
    \ simpleMapped.mitems: entry.popped = none(tuple[time: Time, value: Item])\n \
    \           for entry in simpleActive.mitems: entry.popped = none(tuple[time:\
    \ Time, value: Item])\n            doAssert fixed.debugOperations() == simpleExpected\n\
    \            doAssert compressed.debugOperations() == simpleMapped\n         \
    \   doAssert dynamic.debugOperations() == simpleActive\n            doAssert monoid.debugOperations()\
    \ == simpleActive\n            doAssert monoid.fold() == savedFold and dynamic.len\
    \ == savedLen and dynamic.peek() == savedPeek\n            doAssert fixed.len\
    \ == savedLen and compressed.len == savedLen and monoid.len == savedLen\n    \
    \        doAssert fixed.peek() == savedPeek and compressed.peek() == savedPeek\
    \ and monoid.peek() == savedPeek\n            for i in 0..<n:\n              \
    \  doAssert fixed.isRemaining(i) == dynamic.isRemaining(times[i])\n          \
    \      doAssert compressed.isRemaining(times[i]) == monoid.isRemaining(times[i])\n\
    \            doAssert dynamic.debugTimeline() == active\n\nblock:\n    doAssert\
    \ initRetroactivePriorityQueue[int](0).debugTimeline().len == 0\n    doAssert\
    \ initCompressedRetroactivePriorityQueue[int, int](@[]).debugOperations().len\
    \ == 0\n    doAssert initDynamicRetroactivePriorityQueue[int, int]().debugTimeline().len\
    \ == 0\n    let pq = initDynamicRetroactivePriorityQueue[int, int]()\n    pq.setPush(low(int),\
    \ 1)\n    pq.setPop(-1)\n    pq.setPush(0, 5)\n    pq.setPop(high(int))\n    let\
    \ entries = pq.debugTimeline()\n    doAssert entries[1].popped.get == (time: low(int),\
    \ value: 1)\n    doAssert entries[3].popped.get == (time: 0, value: 5)\n    doAssert\
    \ pq.sum == 0\n    pq.erase(-1)\n    doAssert pq.debugTimeline()[2].popped.get\
    \ == (time: low(int), value: 1)\n    doAssert pq.sum == 5\n    pq.erase(low(int))\n\
    \    pq.erase(0)\n    pq.erase(high(int))\n    doAssert pq.debugTimeline().len\
    \ == 0\n    pq.setPop(3)\n    doAssert pq.debugTimeline()[0].popped.isNone\n\n\
    block:\n    let pq = initRetroactivePriorityQueue[int](4)\n    pq.setPush(0, 2)\n\
    \    pq.setPush(1, 2)\n    pq.setPop(2)\n    pq.setPop(3)\n    var snapshot =\
    \ pq.debugTimeline()\n    doAssert snapshot[2].popped.get.time == 0\n    doAssert\
    \ snapshot[3].popped.get.time == 1\n    snapshot[0].value = some(99)\n    doAssert\
    \ pq.debugTimeline()[0].value.get == 2\n\nblock:\n    let pq = initRetroactivePriorityQueue[int](6)\n\
    \    pq.setPush(1, 4)\n    pq.setPop(2)\n    pq.setPop(3)\n    pq.setPush(4, 9)\n\
    \    doAssert pq.debugDump() == \"0: noop\\n1: push(4)\\n2: pop -> 4 (push at\
    \ 1)\\n3: pop -> empty\\n4: push(9)\\n5: noop\"\n    let compressed = initCompressedRetroactivePriorityQueue[int,\
    \ int](@[30, 10, 20])\n    compressed.setPush(10, 7)\n    compressed.setPop(30)\n\
    \    doAssert compressed.debugDump() == \"10: push(7)\\n20: noop\\n30: pop ->\
    \ 7 (push at 10)\"\n    let dynamic = initDynamicRetroactivePriorityQueue[int,\
    \ int]()\n    dynamic.setPush(10, 7)\n    dynamic.setPop(30)\n    doAssert dynamic.debugDump()\
    \ == \"10: push(7)\\n30: pop -> 7 (push at 10)\"\n    let monoid = initDynamicRetroactivePriorityQueueMonoid[int,\
    \ int, int](\n        proc(a, b: int): int = max(a, b), low(int), proc(x: int):\
    \ int = x)\n    monoid.setPush(10, 7)\n    monoid.setPop(30)\n    doAssert monoid.debugDump()\
    \ == dynamic.debugDump()\n    doAssert initDynamicRetroactivePriorityQueue[int,\
    \ int]().debugDump() == \"\"\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/dynamic_retroactive_priority_queue.nim
  - cplib/collections/retroactive_priority_queue.nim
  - cplib/collections/retroactive_priority_queue.nim
  - cplib/collections/compressed_coordinates_internal.nim
  - cplib/collections/dynamic_retroactive_priority_queue_monoid.nim
  - cplib/collections/dynamic_retroactive_priority_queue.nim
  - cplib/collections/compressed_retroactive_priority_queue.nim
  - cplib/collections/compressed_coordinates_internal.nim
  - cplib/collections/dynamic_retroactive_priority_queue_monoid.nim
  - cplib/collections/compressed_retroactive_priority_queue.nim
  isVerificationFile: true
  path: verify/collections/retroactive_priority_queue_debug_test.nim
  requiredBy: []
  timestamp: '2026-09-28 01:13:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/retroactive_priority_queue_debug_test.nim
layout: document
redirect_from:
- /verify/verify/collections/retroactive_priority_queue_debug_test.nim
- /verify/verify/collections/retroactive_priority_queue_debug_test.nim.html
title: verify/collections/retroactive_priority_queue_debug_test.nim
---
