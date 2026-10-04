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
    import algorithm, options, random, tables\nimport cplib/collections/dynamic_retroactive_priority_queue_monoid\n\
    \ntype\n    Item = object\n        priority: int\n        label: string\n    Operation\
    \ = tuple[kind: int, value: Item]\n\nproc `<`(a, b: Item): bool = a.priority <\
    \ b.priority\nproc concat(a, b: string): string = a & b\nproc label(x: Item):\
    \ string = x.label\n\nproc replay(ops: seq[Operation], order: SortOrder): seq[int]\
    \ =\n    for t, op in ops:\n        if op.kind == 1: result.add(t)\n        elif\
    \ op.kind == 2 and result.len > 0:\n            var best = 0\n            for\
    \ j in 1..<result.len:\n                let a = ops[result[j]].value.priority\n\
    \                let b = ops[result[best]].value.priority\n                if\
    \ (order == Ascending and a < b) or (order == Descending and b < a): best = j\n\
    \            result.delete(best)\n\nvar rng = initRand(36390)\nfor order in [Ascending,\
    \ Descending]:\n    for trial in 0..<40:\n        let pq = initDynamicRetroactivePriorityQueueMonoid[int,\
    \ Item, string](concat, \"\", label, order)\n        doAssert pq.fold() == \"\"\
    \ and pq.len == 0 and pq.peek().isNone\n        var ops = newSeq[Operation](40)\n\
    \        var previous = initTable[int, Item]()\n        for step in 0..<500:\n\
    \            let t = rng.rand(39)\n            ops[t] = (rng.rand(2), Item(priority:\
    \ rng.rand(-3..3), label: $step & \",\"))\n            let delta = case ops[t].kind\n\
    \                of 0: pq.erase(t * 17 - 500)\n                of 1: pq.setPush(t\
    \ * 17 - 500, ops[t].value)\n                else: pq.setPop(t * 17 - 500)\n \
    \           for entry in delta.removed:\n                doAssert previous.hasKey(entry.time)\
    \ and previous[entry.time] == entry.value\n                previous.del(entry.time)\n\
    \            for entry in delta.added:\n                doAssert not previous.hasKey(entry.time)\n\
    \                previous[entry.time] = entry.value\n            let expected\
    \ = replay(ops, order)\n            var joined = \"\"\n            var top = none(Item)\n\
    \            for i in expected:\n                joined.add(ops[i].value.label)\n\
    \                doAssert previous[i * 17 - 500] == ops[i].value\n           \
    \     if top.isNone or (order == Ascending and ops[i].value < top.get) or\n  \
    \                      (order == Descending and top.get < ops[i].value): top =\
    \ some(ops[i].value)\n            doAssert pq.fold() == joined and pq.get_all()\
    \ == joined\n            doAssert pq.len == expected.len and previous.len == expected.len\n\
    \            doAssert pq.peek() == top\n            for i in 0..<ops.len: doAssert\
    \ pq.isRemaining(i * 17 - 500) == (i in expected)\n        for t in 0..<ops.len:\
    \ pq.erase(t * 17 - 500)\n        doAssert pq.fold() == \"\" and pq.len == 0\n\
    \        pq.setPush(low(int), Item(priority: 1, label: \"a\"))\n        pq.setPush(high(int),\
    \ Item(priority: 1, label: \"b\"))\n        doAssert pq.fold() == \"ab\"\n\nblock:\n\
    \    let pq = initDynamicRetroactivePriorityQueueMonoid[int, uint64, uint64](\n\
    \        proc(a, b: uint64): uint64 = max(a, b), 0'u64, proc(x: uint64): uint64\
    \ = x)\n    pq.setPush(1, high(uint64))\n    pq.setPush(2, high(uint64))\n   \
    \ doAssert pq.fold() == high(uint64)\n    pq.setPop(3)\n    doAssert pq.fold()\
    \ == high(uint64)\n    pq.setPop(4)\n    doAssert pq.fold() == 0\n    pq.erase(3)\n\
    \    doAssert pq.fold() == high(uint64)\n\nblock:\n    type Affine = tuple[a,\
    \ b: int64]\n    const modulus = 998244353'i64\n    proc compose(x, y: Affine):\
    \ Affine =\n        ((x.a * y.a) mod modulus, (x.b * y.a + y.b) mod modulus)\n\
    \    proc lift(x: int): Affine = (int64(x + 2), int64(x + 1))\n    let pq = initDynamicRetroactivePriorityQueueMonoid[int,\
    \ int, Affine](compose, (1'i64, 0'i64), lift)\n    var vals = initTable[int, int]()\n\
    \    for i in 0..<3000:\n        let t = rng.rand(-10000..10000)\n        let\
    \ value = rng.rand(100)\n        pq.setPush(t, value)\n        vals[t] = value\n\
    \    var times: seq[int]\n    for t in vals.keys: times.add(t)\n    times.sort()\n\
    \    var expected: Affine = (1'i64, 0'i64)\n    for t in times: expected = compose(expected,\
    \ lift(vals[t]))\n    doAssert pq.fold() == expected\n    rng.shuffle(times)\n\
    \    for i, t in times:\n        pq.erase(t)\n        vals.del(t)\n        if\
    \ i mod 100 == 0:\n            var sortedTimes: seq[int]\n            for key\
    \ in vals.keys: sortedTimes.add(key)\n            sortedTimes.sort()\n       \
    \     expected = (1'i64, 0'i64)\n            for key in sortedTimes: expected\
    \ = compose(expected, lift(vals[key]))\n            doAssert pq.fold() == expected\n\
    \    doAssert pq.fold() == (1'i64, 0'i64)\n\nblock:\n    let factor = 3\n    let\
    \ pq = initDynamicRetroactivePriorityQueueMonoid[string, int, int](\n        proc(a,\
    \ b: int): int = a + b, 0, proc(x: int): int = x * factor)\n    pq.setPop(\"z\"\
    )\n    pq.setPush(\"a\", 2)\n    pq.setPush(\"b\", 5)\n    doAssert pq.fold()\
    \ == 15\n    pq.setPush(\"b\", 1)\n    doAssert pq.fold() == 6\n    pq.erase(\"\
    z\")\n    doAssert pq.fold() == 9\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/retroactive_priority_queue.nim
  - cplib/collections/dynamic_retroactive_priority_queue_monoid.nim
  - cplib/collections/dynamic_retroactive_priority_queue.nim
  - cplib/collections/dynamic_retroactive_priority_queue.nim
  - cplib/collections/retroactive_priority_queue.nim
  - cplib/collections/dynamic_retroactive_priority_queue_monoid.nim
  isVerificationFile: true
  path: verify/collections/dynamic_retroactive_priority_queue_monoid_test.nim
  requiredBy: []
  timestamp: '2026-09-28 01:13:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/dynamic_retroactive_priority_queue_monoid_test.nim
layout: document
redirect_from:
- /verify/verify/collections/dynamic_retroactive_priority_queue_monoid_test.nim
- /verify/verify/collections/dynamic_retroactive_priority_queue_monoid_test.nim.html
title: verify/collections/dynamic_retroactive_priority_queue_monoid_test.nim
---
