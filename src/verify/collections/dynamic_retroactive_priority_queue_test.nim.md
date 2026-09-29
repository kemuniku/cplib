---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dynamic_retroactive_priority_queue.nim
    title: cplib/collections/dynamic_retroactive_priority_queue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dynamic_retroactive_priority_queue.nim
    title: cplib/collections/dynamic_retroactive_priority_queue.nim
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
    import algorithm, options, random, tables\nimport cplib/collections/dynamic_retroactive_priority_queue\n\
    import cplib/collections/retroactive_priority_queue\n\ntype\n    Operation = tuple[kind:\
    \ int, value: int64]\n    Time = tuple[day, id: int]\n    Item = object\n    \
    \    key: int\n        label: string\n\nproc `<`(a, b: Item): bool = a.key < b.key\n\
    \nproc replay(ops: seq[Operation], order: SortOrder): seq[int] =\n    for t, op\
    \ in ops:\n        if op.kind == 1:\n            result.add(t)\n        elif op.kind\
    \ == 2 and result.len > 0:\n            var best = 0\n            for j in 1..<result.len:\n\
    \                let a = ops[result[j]].value\n                let b = ops[result[best]].value\n\
    \                if (order == Ascending and a < b) or (order == Descending and\
    \ b < a):\n                    best = j\n            result.delete(best)\n\nproc\
    \ apply(pq: DynamicRetroactivePriorityQueue[int, int64], t: int,\n        op:\
    \ Operation): QueueDelta[int, int64] =\n    case op.kind\n    of 0: pq.erase(t)\n\
    \    of 1: pq.setPush(t, op.value)\n    else: pq.setPop(t)\n\nproc check(pq: DynamicRetroactivePriorityQueue[int,\
    \ int64], times: seq[int],\n        ops: seq[Operation], order: SortOrder, delta:\
    \ QueueDelta[int, int64],\n        previous: var Table[int, int64]) =\n    for\
    \ entry in delta.removed:\n        doAssert previous.hasKey(entry.time) and previous[entry.time]\
    \ == entry.value\n        previous.del(entry.time)\n    for entry in delta.added:\n\
    \        doAssert not previous.hasKey(entry.time)\n        previous[entry.time]\
    \ = entry.value\n    let expected = replay(ops, order)\n    doAssert pq.len ==\
    \ expected.len and previous.len == expected.len\n    var total = 0'i64\n    var\
    \ top = none(int64)\n    for t in expected:\n        total += ops[t].value\n \
    \       doAssert previous.hasKey(times[t]) and previous[times[t]] == ops[t].value\n\
    \        if top.isNone or (order == Ascending and ops[t].value < top.get) or\n\
    \                (order == Descending and top.get < ops[t].value):\n         \
    \   top = some(ops[t].value)\n    doAssert pq.sum == total and pq.peek() == top\n\
    \    for t in 0..<ops.len:\n        doAssert pq.isRemaining(times[t]) == (t in\
    \ expected)\n\nlet choices: seq[Operation] = @[(0, 0'i64), (2, 0'i64), (1, -1'i64),\
    \ (1, 0'i64), (1, 1'i64)]\nlet tinyTimes = @[low(int), -1, 0, high(int)]\nfor\
    \ order in [Ascending, Descending]:\n    for state in 0..<625:\n        let pq\
    \ = initDynamicRetroactivePriorityQueue[int, int64](order)\n        var ops =\
    \ newSeq[Operation](4)\n        var previous = initTable[int, int64]()\n     \
    \   var code = state\n        for t in 0..<4:\n            ops[t] = choices[code\
    \ mod 5]\n            code = code div 5\n            pq.check(tinyTimes, ops,\
    \ order, pq.apply(tinyTimes[t], ops[t]), previous)\n        for t in 0..<4:\n\
    \            let old = ops[t]\n            for op in choices:\n              \
    \  ops[t] = op\n                pq.check(tinyTimes, ops, order, pq.apply(tinyTimes[t],\
    \ op), previous)\n            ops[t] = old\n            pq.check(tinyTimes, ops,\
    \ order, pq.apply(tinyTimes[t], old), previous)\n\nvar rng = initRand(3631213)\n\
    for order in [Ascending, Descending]:\n    for trial in 0..<100:\n        let\
    \ n = rng.rand(1..80)\n        let pq = initDynamicRetroactivePriorityQueue[int,\
    \ int64](order)\n        var times = newSeq[int](n)\n        for i in 0..<n: times[i]\
    \ = i * 17 - 600\n        var ops = newSeq[Operation](n)\n        var previous\
    \ = initTable[int, int64]()\n        for step in 0..<500:\n            let t =\
    \ rng.rand(n - 1)\n            ops[t] = (rng.rand(2), int64(rng.rand(-20..20)))\n\
    \            pq.check(times, ops, order, pq.apply(times[t], ops[t]), previous)\n\
    \        for t in countdown(n - 1, 0):\n            ops[t] = (0, 0'i64)\n    \
    \        pq.check(times, ops, order, pq.erase(times[t]), previous)\n\nblock:\n\
    \    let pq = initDynamicRetroactivePriorityQueue[string, Item](Descending)\n\
    \    pq.setPop(\"z\")\n    pq.setPush(\"b\", Item(key: 7, label: \"later\"))\n\
    \    pq.setPush(\"a\", Item(key: 7, label: \"earlier\"))\n    doAssert pq.peek().get.label\
    \ == \"later\"\n    doAssert not pq.isRemaining(\"a\") and pq.isRemaining(\"b\"\
    )\n    let delta = pq.erase(\"z\")\n    doAssert delta.added.len == 1 and delta.added[0].time\
    \ == \"a\"\n    doAssert pq.peek().get.label == \"earlier\"\n    pq.erase(\"a\"\
    )\n    pq.erase(\"b\")\n    doAssert pq.peek().isNone and pq.len == 0\n    doAssert\
    \ pq.erase(\"missing\").removed.len == 0\n\nblock:\n    let pq = initDynamicRetroactivePriorityQueue[int,\
    \ uint64]()\n    pq.setPop(high(int))\n    pq.setPush(low(int), high(uint64))\n\
    \    doAssert pq.sum == 0\n    pq.erase(high(int))\n    doAssert pq.sum == high(uint64)\n\
    \    let floats = initDynamicRetroactivePriorityQueue[int, float64]()\n    floats.setPush(1,\
    \ 1.5)\n    floats.setPush(2, 2.5)\n    floats.setPop(3)\n    doAssert floats.sum\
    \ == 2.5\n\nfor trial in 0..<100:\n    let n = rng.rand(1..8)\n    let pq = initDynamicRetroactivePriorityQueue[Time,\
    \ int64](Descending)\n    var d = newSeq[int](n)\n    var p = newSeq[int64](n)\n\
    \    var total = 0'i64\n    for day in 1..n: pq.setPop((n - day, n))\n    for\
    \ i in 0..<n:\n        d[i] = rng.rand(1..n)\n        p[i] = int64(rng.rand(1..100))\n\
    \        pq.setPush((n - d[i], i), p[i])\n        total += p[i]\n    for step\
    \ in 0..<100:\n        let c = rng.rand(n - 1)\n        pq.erase((n - d[c], c))\n\
    \        total -= p[c]\n        d[c] = rng.rand(1..n)\n        p[c] = int64(rng.rand(1..100))\n\
    \        total += p[c]\n        pq.setPush((n - d[c], c), p[c])\n        var best\
    \ = 0'i64\n        for mask in 0..<(1 shl n):\n            var deadlines: seq[int]\n\
    \            var reward = 0'i64\n            for i in 0..<n:\n               \
    \ if (mask and (1 shl i)) != 0:\n                    deadlines.add(d[i])\n   \
    \                 reward += p[i]\n            deadlines.sort()\n            var\
    \ valid = true\n            for i, deadline in deadlines:\n                if\
    \ deadline < i + 1: valid = false\n            if valid: best = max(best, reward)\n\
    \        doAssert total - pq.sum == best\n\nblock:\n    let pq = initDynamicRetroactivePriorityQueue[int,\
    \ int64]()\n    const n = 20000\n    for i in 0..<n: pq.setPush(i, int64(i))\n\
    \    doAssert pq.len == n and pq.sum == int64(n) * (n - 1) div 2\n    for i in\
    \ 0..<n: pq.erase(i)\n    doAssert pq.len == 0 and pq.peek().isNone\n    for i\
    \ in countdown(n - 1, 0): pq.setPop(i)\n    for i in countdown(n - 1, 0): pq.setPush(i,\
    \ int64(i))\n    doAssert pq.len == n and pq.sum == int64(n) * (n - 1) div 2\n\
    \    for i in countdown(n - 1, 0): pq.erase(i)\n    doAssert pq.len == 0\n\necho\
    \ \"Hello World\"\n"
  dependsOn:
  - cplib/collections/retroactive_priority_queue.nim
  - cplib/collections/dynamic_retroactive_priority_queue.nim
  - cplib/collections/retroactive_priority_queue.nim
  - cplib/collections/dynamic_retroactive_priority_queue.nim
  isVerificationFile: true
  path: verify/collections/dynamic_retroactive_priority_queue_test.nim
  requiredBy: []
  timestamp: '2026-09-28 01:13:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/dynamic_retroactive_priority_queue_test.nim
layout: document
redirect_from:
- /verify/verify/collections/dynamic_retroactive_priority_queue_test.nim
- /verify/verify/collections/dynamic_retroactive_priority_queue_test.nim.html
title: verify/collections/dynamic_retroactive_priority_queue_test.nim
---
