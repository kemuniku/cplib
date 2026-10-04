---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/indexed_retroactive_priority_queue.nim
    title: cplib/collections/indexed_retroactive_priority_queue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/indexed_retroactive_priority_queue.nim
    title: cplib/collections/indexed_retroactive_priority_queue.nim
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
    import algorithm, options, random\nimport cplib/collections/indexed_retroactive_priority_queue\n\
    import cplib/collections/retroactive_priority_queue\n\ntype\n    Operation = tuple[push:\
    \ bool, value: int64]\n    Item = object\n        priority: int\n        label:\
    \ string\nproc `<`(a, b: Item): bool = a.priority < b.priority\n\nproc check(pq:\
    \ IndexedRetroactivePriorityQueue[int64], ops: seq[Operation], order: SortOrder)\
    \ =\n    var live, pushes, pops: seq[int]\n    var taken = 0'i64\n    var timeline:\
    \ seq[QueueDebugEntry[int, int64]]\n    for t, op in ops:\n        var entry =\
    \ QueueDebugEntry[int, int64](time: t)\n        if op.push:\n            entry.kind\
    \ = qdkPush\n            entry.value = some(op.value)\n            live.add(t)\n\
    \            pushes.add(t)\n        else:\n            entry.kind = qdkPop\n \
    \           pops.add(t)\n            if live.len > 0:\n                var best\
    \ = 0\n                for j in 1..<live.len:\n                    let a = ops[live[j]].value\n\
    \                    let b = ops[live[best]].value\n                    if (order\
    \ == Ascending and a < b) or (order == Descending and b < a): best = j\n     \
    \           let source = live[best]\n                taken += ops[source].value\n\
    \                entry.popped = some((time: source, value: ops[source].value))\n\
    \                live.delete(best)\n        timeline.add(entry)\n    doAssert\
    \ pq.operationCount == ops.len and pq.pushCount == pushes.len and pq.popCount\
    \ == pops.len\n    for k, t in pushes: doAssert pq.pushIndex(k) == t\n    for\
    \ k, t in pops: doAssert pq.popIndex(k) == t\n    doAssert pq.debugTimeline()\
    \ == timeline\n    for i in 0..<ops.len: doAssert pq.isRemaining(i) == (i in live)\n\
    \    var total = 0'i64\n    var top = none(int64)\n    for i in live:\n      \
    \  total += ops[i].value\n        if top.isNone or (order == Ascending and ops[i].value\
    \ < top.get) or\n                (order == Descending and top.get < ops[i].value):\
    \ top = some(ops[i].value)\n    doAssert pq.sum == total and pq.poppedSum == taken\
    \ and pq.len == live.len and pq.peek() == top\n\nvar rng = initRand(36329)\nfor\
    \ order in [Ascending, Descending]:\n    for trial in 0..<40:\n        let pq\
    \ = initIndexedRetroactivePriorityQueue[int64](order)\n        var ops: seq[Operation]\n\
    \        pq.check(ops, order)\n        for step in 0..<1000:\n            let\
    \ action = if ops.len == 0: rng.rand(1) else: rng.rand(6)\n            let value\
    \ = int64(rng.rand(-3..3))\n            if ops.len > 80:\n                let\
    \ i = rng.rand(ops.high)\n                pq.erase(i)\n                ops.delete(i)\n\
    \            elif action <= 1:\n                let i = rng.rand(ops.len)\n  \
    \              if action == 0: pq.insertPush(i, value)\n                else:\
    \ pq.insertPop(i)\n                ops.insert((action == 0, value), i)\n     \
    \       elif action == 2:\n                let i = rng.rand(ops.high)\n      \
    \          pq.erase(i)\n                ops.delete(i)\n            elif action\
    \ == 3:\n                let i = rng.rand(ops.high)\n                pq.setPush(i,\
    \ value)\n                ops[i] = (true, value)\n            elif action == 4:\n\
    \                let i = rng.rand(ops.high)\n                pq.setPop(i)\n  \
    \              ops[i] = (false, 0'i64)\n            elif action == 5:\n      \
    \          var indices: seq[int]\n                for i, op in ops:\n        \
    \            if not op.push: indices.add(i)\n                if indices.len >\
    \ 0:\n                    let k = rng.rand(indices.high)\n                   \
    \ pq.insertPushBeforePop(k, value)\n                    ops.insert((true, value),\
    \ indices[k])\n            else:\n                var indices: seq[int]\n    \
    \            for i, op in ops:\n                    if op.push: indices.add(i)\n\
    \                if indices.len > 0:\n                    let k = rng.rand(indices.high)\n\
    \                    pq.insertPopBeforePush(k)\n                    ops.insert((false,\
    \ 0'i64), indices[k])\n            pq.check(ops, order)\n        while ops.len\
    \ > 0:\n            let i = rng.rand(ops.high)\n            pq.erase(i)\n    \
    \        ops.delete(i)\n            pq.check(ops, order)\n\nblock:\n    let pq\
    \ = initIndexedRetroactivePriorityQueue[Item]()\n    pq.insertPop(0)\n    pq.insertPushBeforePop(0,\
    \ Item(priority: 1, label: \"old\"))\n    pq.insertPush(0, Item(priority: 1, label:\
    \ \"first\"))\n    doAssert pq.peek().get.label == \"old\"\n    pq.insertPopBeforePush(1)\n\
    \    doAssert pq.peek().isNone\n    let timeline = pq.debugTimeline()\n    doAssert\
    \ timeline[1].popped.get.value.label == \"first\"\n    doAssert timeline[3].popped.get.value.label\
    \ == \"old\"\n    pq.erase(1)\n    doAssert pq.peek().get.label == \"old\"\n\n\
    block:\n    let pq = initIndexedRetroactivePriorityQueue[int64]()\n    const n\
    \ = 20000\n    for i in 0..<n: pq.insertPop(pq.operationCount)\n    for i in 0..<n:\
    \ pq.insertPushBeforePop(i, 1)\n    doAssert pq.popCount == n and pq.pushCount\
    \ == n and pq.poppedSum == n and pq.len == 0\n    for i in countdown(n - 1, 0):\n\
    \        doAssert pq.popIndex(i) == 2 * i + 1\n        pq.erase(pq.popIndex(i))\n\
    \    doAssert pq.sum == n and pq.poppedSum == 0\n    for i in 0..<n: pq.erase(0)\n\
    \    doAssert pq.operationCount == 0\n    for i in 0..<n: pq.insertPush(0, 1)\n\
    \    for i in 0..<n: pq.insertPopBeforePush(i)\n    doAssert pq.poppedSum == n\
    \ - 1 and pq.sum == 1\n\nfor order in [Ascending, Descending]:\n    let pq = initIndexedRetroactivePriorityQueue[int64](order)\n\
    \    var ops: seq[Operation]\n    var ids: seq[int]\n    var nextId = 0\n    for\
    \ step in 0..<2500:\n        let action = if ids.len == 0: 0 else: rng.rand(4)\n\
    \        if action == 0 and ids.len < 60:\n            let pos = rng.rand(ids.len)\n\
    \            let value = int64(rng.rand(-10..10))\n            let push = rng.rand(1)\
    \ == 0\n            let id = if push: pq.insertPush(pos, value) else: pq.insertPop(pos)\n\
    \            doAssert id == nextId\n            inc nextId\n            ids.insert(id,\
    \ pos)\n            ops.insert((push, value), pos)\n        elif action == 1 and\
    \ ids.len > 0:\n            let pos = rng.rand(ids.high)\n            let id =\
    \ ids[pos]\n            pq.eraseById(id)\n            ids.delete(pos)\n      \
    \      ops.delete(pos)\n            doAssert pq.indexOf(id) == -1\n          \
    \  pq.eraseById(id)\n        elif action == 2 and ids.len > 0:\n            let\
    \ pos = rng.rand(ids.high)\n            let id = ids[pos]\n            pq.erase(pos)\n\
    \            ids.delete(pos)\n            ops.delete(pos)\n            doAssert\
    \ pq.indexOf(id) == -1\n        elif ids.len > 0:\n            let pos = rng.rand(ids.high)\n\
    \            if action == 3:\n                pq.setPush(pos, 7)\n           \
    \     ops[pos] = (true, 7'i64)\n            else:\n                pq.setPop(pos)\n\
    \                ops[pos] = (false, 0'i64)\n        for pos, id in ids: doAssert\
    \ pq.indexOf(id) == pos\n        doAssert pq.indexOf(-1) == -1 and pq.indexOf(nextId)\
    \ == -1\n        pq.eraseById(nextId)\n        pq.check(ops, order)\n\nblock:\n\
    \    let pq = initIndexedRetroactivePriorityQueue[int]()\n    let popId = pq.insertPop(0)\n\
    \    let pushId = pq.insertPushBeforePop(0, 10)\n    let emptyPopId = pq.insertPopBeforePush(0)\n\
    \    doAssert popId == 0 and pushId == 1 and emptyPopId == 2\n    doAssert pq.indexOf(popId)\
    \ == 2 and pq.indexOf(pushId) == 1\n    pq.eraseById(emptyPopId)\n    pq.eraseById(pushId)\n\
    \    doAssert pq.poppedSum == 0 and pq.operationCount == 1\n    let newId = pq.insertPushBeforePop(0,\
    \ 20)\n    doAssert newId == 3 and pq.indexOf(pushId) == -1\n    pq.eraseById(pushId)\n\
    \    doAssert pq.poppedSum == 20\n    pq.eraseById(popId)\n    doAssert pq.sum\
    \ == 20\n\nwhen compileOption(\"assertions\"):\n    template rejects(body: untyped)\
    \ =\n        block:\n            var rejected = false\n            try: body\n\
    \            except AssertionDefect: rejected = true\n            doAssert rejected\n\
    \    let pq = initIndexedRetroactivePriorityQueue[int]()\n    rejects: pq.insertPushBeforePop(0,\
    \ 1)\n    rejects: pq.insertPopBeforePush(0)\n    rejects: pq.insertPop(-1)\n\
    \    rejects: pq.insertPush(1, 1)\n    rejects: pq.setPush(0, 1)\n    rejects:\
    \ pq.setPop(0)\n    rejects: pq.erase(0)\n    pq.insertPop(0)\n    rejects: pq.insertPushBeforePop(1,\
    \ 1)\n    rejects: discard pq.popIndex(-1)\n    rejects: discard pq.pushIndex(0)\n\
    \necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/indexed_retroactive_priority_queue.nim
  - cplib/collections/retroactive_priority_queue.nim
  - cplib/collections/indexed_retroactive_priority_queue.nim
  - cplib/collections/retroactive_priority_queue.nim
  isVerificationFile: true
  path: verify/collections/indexed_retroactive_priority_queue_test.nim
  requiredBy: []
  timestamp: '2026-09-28 02:12:34+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/indexed_retroactive_priority_queue_test.nim
layout: document
redirect_from:
- /verify/verify/collections/indexed_retroactive_priority_queue_test.nim
- /verify/verify/collections/indexed_retroactive_priority_queue_test.nim.html
title: verify/collections/indexed_retroactive_priority_queue_test.nim
---
