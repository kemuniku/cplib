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
    import algorithm, options, random, tables\nimport cplib/collections/retroactive_priority_queue\n\
    import cplib/collections/compressed_retroactive_priority_queue\n\ntype\n    Operation\
    \ = tuple[kind: int, value: int64]\n    Item = object\n        key: int\n    \
    \    label: string\n\nproc `<`(a, b: Item): bool = a.key < b.key\n\nproc replay(ops:\
    \ seq[Operation], order: SortOrder): seq[int] =\n    for t, op in ops:\n     \
    \   if op.kind == 1:\n            result.add(t)\n        elif op.kind == 2 and\
    \ result.len > 0:\n            var best = 0\n            for i in 1..<result.len:\n\
    \                let a = result[i]\n                let b = result[best]\n   \
    \             if (order == Ascending and ops[a].value < ops[b].value) or\n   \
    \                     (order == Descending and ops[b].value < ops[a].value):\n\
    \                    best = i\n            result.delete(best)\n\nproc apply(pq:\
    \ RetroactivePriorityQueue[int64], t: int, op: Operation): QueueDelta[int, int64]\
    \ =\n    case op.kind\n    of 0: pq.erase(t)\n    of 1: pq.setPush(t, op.value)\n\
    \    else: pq.setPop(t)\n\nproc check(pq: RetroactivePriorityQueue[int64], ops:\
    \ seq[Operation], order: SortOrder,\n        delta: QueueDelta[int, int64], previous:\
    \ var Table[int, int64]) =\n    for entry in delta.removed:\n        doAssert\
    \ previous.hasKey(entry.time)\n        doAssert previous[entry.time] == entry.value\n\
    \        previous.del(entry.time)\n    for entry in delta.added:\n        doAssert\
    \ not previous.hasKey(entry.time)\n        previous[entry.time] = entry.value\n\
    \    let expected = replay(ops, order)\n    doAssert pq.len == expected.len\n\
    \    doAssert previous.len == expected.len\n    var total = 0'i64\n    var top\
    \ = none(int64)\n    for t in expected:\n        total += ops[t].value\n     \
    \   doAssert previous.hasKey(t) and previous[t] == ops[t].value\n        if top.isNone\
    \ or (order == Ascending and ops[t].value < top.get) or\n                (order\
    \ == Descending and top.get < ops[t].value):\n            top = some(ops[t].value)\n\
    \    doAssert pq.sum == total\n    doAssert pq.peek() == top\n    for t in 0..<ops.len:\n\
    \        doAssert pq.isRemaining(t) == (t in expected)\n\nlet choices: seq[Operation]\
    \ = @[(0, 0'i64), (2, 0'i64), (1, -1'i64), (1, 0'i64), (1, 1'i64)]\nfor order\
    \ in [Ascending, Descending]:\n    for state in 0..<625:\n        var pq = initRetroactivePriorityQueue[int64](4,\
    \ order)\n        var ops = newSeq[Operation](4)\n        var previous = initTable[int,\
    \ int64]()\n        var code = state\n        for t in 0..<4:\n            ops[t]\
    \ = choices[code mod 5]\n            code = code div 5\n            let delta\
    \ = pq.apply(t, ops[t])\n            pq.check(ops, order, delta, previous)\n \
    \       for t in 0..<4:\n            let old = ops[t]\n            for op in choices:\n\
    \                ops[t] = op\n                let delta = pq.apply(t, op)\n  \
    \              pq.check(ops, order, delta, previous)\n            ops[t] = old\n\
    \            let delta = pq.apply(t, old)\n            pq.check(ops, order, delta,\
    \ previous)\n\nvar rng = initRand(3631213)\nfor order in [Ascending, Descending]:\n\
    \    for trial in 0..<100:\n        let n = rng.rand(1..70)\n        var pq =\
    \ initRetroactivePriorityQueue[int64](n, order)\n        var ops = newSeq[Operation](n)\n\
    \        var previous = initTable[int, int64]()\n        for step in 0..<500:\n\
    \            let t = rng.rand(n - 1)\n            ops[t] = (rng.rand(2), int64(rng.rand(-20..20)))\n\
    \            let delta = pq.apply(t, ops[t])\n            pq.check(ops, order,\
    \ delta, previous)\n\nfor order in [Ascending, Descending]:\n    var pq = initRetroactivePriorityQueue[int64](5,\
    \ order)\n    pq.setPop(0)\n    pq.setPop(2)\n    pq.setPop(4)\n    pq.setPush(3,\
    \ high(int64))\n    doAssert pq.len == 0\n    pq.setPush(1, low(int64))\n    doAssert\
    \ pq.len == 0\n    pq.erase(4)\n    doAssert pq.sum == high(int64)\n    pq.setPush(1,\
    \ high(int64))\n    doAssert pq.sum == high(int64)\n    pq.erase(3)\n    doAssert\
    \ pq.len == 0\n    pq.setPush(3, low(int64))\n    doAssert pq.sum == low(int64)\n\
    \    pq.setPop(3)\n    doAssert pq.peek().isNone\n\nblock:\n    let pq = initRetroactivePriorityQueue[int64](0)\n\
    \    doAssert pq.len == 0 and pq.sum == 0 and pq.peek().isNone\n    let compressed\
    \ = initCompressedRetroactivePriorityQueue[int, int64](@[])\n    doAssert compressed.len\
    \ == 0 and compressed.sum == 0 and compressed.peek().isNone\n    doAssert not\
    \ compressed.isRemaining(0)\n\nblock:\n    var pq = initRetroactivePriorityQueue[string](4)\n\
    \    pq.setPush(0, \"same\")\n    pq.setPush(1, \"same\")\n    pq.setPush(2, \"\
    abc\")\n    pq.setPop(3)\n    doAssert pq.peek() == some(\"same\")\n    doAssert\
    \ pq.isRemaining(0) and pq.isRemaining(1)\n    pq.setPop(2)\n    doAssert pq.len\
    \ == 0\n    let delta = pq.erase(3)\n    doAssert delta.added == @[(time: 1, value:\
    \ \"same\")]\n    doAssert not pq.isRemaining(0) and pq.isRemaining(1)\n\nblock:\n\
    \    type Time = tuple[day, id: int]\n    let times: seq[Time] = @[(3, 0), (1,\
    \ 0), (1, 1), (2, 0), (1, 0)]\n    var pq = initCompressedRetroactivePriorityQueue[Time,\
    \ int64](times, Descending)\n    pq.setPop((1, 1))\n    pq.setPush((1, 0), 100)\n\
    \    pq.setPush((2, 0), 20)\n    pq.setPush((3, 0), 30)\n    doAssert pq.sum ==\
    \ 50 and pq.len == 2 and pq.peek() == some(30'i64)\n    doAssert not pq.isRemaining((1,\
    \ 0)) and not pq.isRemaining((2, 1))\n    let delta = pq.erase((1, 1))\n    doAssert\
    \ delta.added == @[(time: (1, 0), value: 100'i64)]\n    doAssert pq.sum == 150\n\
    \    pq.setPop((3, 0))\n    doAssert pq.sum == 20 and pq.len == 1\n\nblock:\n\
    \    var times: seq[int]\n    for i in 0..<100: times.add(i * 7 - 300)\n    rng.shuffle(times)\n\
    \    var pq = initCompressedRetroactivePriorityQueue[int, int64](times)\n    for\
    \ t in times: pq.setPush(t, int64(t))\n    doAssert pq.len == 100 and pq.sum ==\
    \ 4650\n    for t in times: pq.erase(t)\n    doAssert pq.len == 0 and pq.sum ==\
    \ 0\n\nblock:\n    var times = @[low(int), high(int)]\n    for i in 0..<3000:\
    \ times.add(i * 7 - 10000)\n    rng.shuffle(times)\n    let pq = initCompressedRetroactivePriorityQueue[int,\
    \ int64](times)\n    pq.setPop(high(int))\n    pq.setPush(low(int), 50)\n    doAssert\
    \ pq.len == 0\n    pq.erase(high(int))\n    doAssert pq.sum == 50 and pq.isRemaining(low(int))\n\
    \nfor order in [Ascending, Descending]:\n    type Time = tuple[day, id: int]\n\
    \    var times: seq[Time]\n    for i in 0..<53: times.add((i div 3 - 8, i mod\
    \ 3))\n    var registration = times\n    rng.shuffle(registration)\n    registration.add(times[0])\n\
    \    let pq = initCompressedRetroactivePriorityQueue[Time, int64](registration,\
    \ order)\n    var ops = newSeq[Operation](times.len)\n    var previous = initTable[Time,\
    \ int64]()\n    for step in 0..<2000:\n        let t = rng.rand(times.high)\n\
    \        ops[t] = (rng.rand(2), int64(rng.rand(-20..20)))\n        let delta =\
    \ case ops[t].kind\n            of 0: pq.erase(times[t])\n            of 1: pq.setPush(times[t],\
    \ ops[t].value)\n            else: pq.setPop(times[t])\n        for entry in delta.removed:\n\
    \            doAssert previous.hasKey(entry.time) and previous[entry.time] ==\
    \ entry.value\n            previous.del(entry.time)\n        for entry in delta.added:\n\
    \            doAssert not previous.hasKey(entry.time)\n            previous[entry.time]\
    \ = entry.value\n        let expected = replay(ops, order)\n        var total\
    \ = 0'i64\n        for i in expected:\n            total += ops[i].value\n   \
    \         doAssert previous.hasKey(times[i]) and previous[times[i]] == ops[i].value\n\
    \        doAssert pq.sum == total and pq.len == expected.len and previous.len\
    \ == expected.len\n        for i in 0..<times.len:\n            doAssert pq.isRemaining(times[i])\
    \ == (i in expected)\n\nblock:\n    let pq = initRetroactivePriorityQueue[Item](3,\
    \ Descending)\n    pq.setPush(1, Item(key: 7, label: \"later\"))\n    pq.setPush(0,\
    \ Item(key: 7, label: \"earlier\"))\n    pq.setPop(2)\n    doAssert pq.peek().get.label\
    \ == \"later\"\n    doAssert pq.isRemaining(1) and not pq.isRemaining(0)\n\nblock:\n\
    \    let pq = initRetroactivePriorityQueue[uint64](2, Descending)\n    pq.setPush(0,\
    \ high(uint64))\n    doAssert pq.sum == high(uint64)\n    pq.setPop(1)\n    doAssert\
    \ pq.sum == 0 and pq.peek().isNone\n    pq.erase(1)\n    doAssert pq.sum == high(uint64)\n\
    \    let floats = initRetroactivePriorityQueue[float64](3)\n    floats.setPush(0,\
    \ 1.5)\n    floats.setPush(1, 2.5)\n    floats.setPop(2)\n    doAssert floats.sum\
    \ == 2.5\n\nwhen compileOption(\"assertions\"):\n    template rejects(body: untyped)\
    \ =\n        block:\n            var rejected = false\n            try:\n    \
    \            body\n            except AssertionDefect:\n                rejected\
    \ = true\n            doAssert rejected\n    rejects:\n        discard initRetroactivePriorityQueue[int](-1)\n\
    \    rejects:\n        initRetroactivePriorityQueue[int](0).setPop(0)\n    rejects:\n\
    \        initRetroactivePriorityQueue[int](2).setPush(-1, 0)\n    rejects:\n \
    \       initRetroactivePriorityQueue[int](2).erase(2)\n    rejects:\n        discard\
    \ initRetroactivePriorityQueue[int](2).isRemaining(2)\n    rejects:\n        initCompressedRetroactivePriorityQueue[int,\
    \ int](@[1, 2]).setPush(3, 0)\n    rejects:\n        initCompressedRetroactivePriorityQueue[int,\
    \ int](@[1, 2]).setPop(0)\n    rejects:\n        initCompressedRetroactivePriorityQueue[int,\
    \ int](@[1, 2]).erase(3)\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/retroactive_priority_queue.nim
  - cplib/collections/compressed_retroactive_priority_queue.nim
  - cplib/collections/compressed_coordinates_internal.nim
  - cplib/collections/compressed_coordinates_internal.nim
  - cplib/collections/compressed_retroactive_priority_queue.nim
  - cplib/collections/retroactive_priority_queue.nim
  isVerificationFile: true
  path: verify/collections/retroactive_priority_queue_test.nim
  requiredBy: []
  timestamp: '2026-09-28 01:13:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/retroactive_priority_queue_test.nim
layout: document
redirect_from:
- /verify/verify/collections/retroactive_priority_queue_test.nim
- /verify/verify/collections/retroactive_priority_queue_test.nim.html
title: verify/collections/retroactive_priority_queue_test.nim
---
