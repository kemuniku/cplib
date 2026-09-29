---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/double_ended_priority_queue.nim
    title: cplib/collections/double_ended_priority_queue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/double_ended_priority_queue.nim
    title: cplib/collections/double_ended_priority_queue.nim
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
    import algorithm, random\nimport cplib/collections/double_ended_priority_queue\n\
    \nproc check(heap: DoubleEndedPriorityQueue[int], values: seq[int]) =\n    doAssert\
    \ heap.len == values.len\n    doAssert heap.isEmpty == (values.len == 0)\n   \
    \ if values.len > 0:\n        doAssert heap.min == values.min\n        doAssert\
    \ heap.max == values.max\n\nproc drain(values: seq[int]) =\n    let sorted = values.sorted()\n\
    \    for mode in 0..2:\n        var heap = values.toDoubleEndedPriorityQueue()\n\
    \        var left = 0\n        var right = sorted.len - 1\n        while left\
    \ <= right:\n            doAssert heap.min == sorted[left]\n            doAssert\
    \ heap.max == sorted[right]\n            if mode == 0 or (mode == 2 and heap.len\
    \ mod 2 == 0):\n                doAssert heap.popMin() == sorted[left]\n     \
    \           inc left\n            else:\n                doAssert heap.popMax()\
    \ == sorted[right]\n                dec right\n        doAssert heap.isEmpty\n\
    \nblock:\n    var heap: DoubleEndedPriorityQueue[int]\n    heap.check(@[])\n \
    \   heap.clear()\n    heap.push(42)\n    heap.check(@[42])\n    doAssert heap.popMax()\
    \ == 42\n    heap.push(17)\n    doAssert heap.popMin() == 17\n    heap.check(@[])\n\
    \    let values = @[low(int), high(int), 0, -1, 1, low(int), high(int)]\n    drain(values)\n\
    \    for x in values: heap.push(x)\n    heap.check(values)\n    var copied = heap\n\
    \    doAssert copied.popMin() == low(int)\n    doAssert copied.popMax() == high(int)\n\
    \    heap.check(values)\n    copied.clear()\n    copied.push(2)\n    heap.check(values)\n\
    \    doAssert copied.popMin() == 2\n    heap.clear()\n    heap.check(@[])\n\n\
    block:\n    var heap = [\"abc\", \"xyz\", \"abc\", \"\"].toDoubleEndedPriorityQueue()\n\
    \    doAssert heap.popMin() == \"\"\n    doAssert heap.popMax() == \"xyz\"\n \
    \   heap.push(\"def\")\n    doAssert heap.popMax() == \"def\"\n    doAssert heap.popMin()\
    \ == \"abc\"\n    doAssert heap.popMax() == \"abc\"\n    var pairs = [(1, 9),\
    \ (2, 0), (1, 10)].toDoubleEndedPriorityQueue()\n    doAssert pairs.popMin() ==\
    \ (1, 9)\n    doAssert pairs.popMax() == (2, 0)\n    doAssert pairs.popMin() ==\
    \ (1, 10)\n    var unsigned = [0'u64, high(uint64), 1'u64].toDoubleEndedPriorityQueue()\n\
    \    doAssert unsigned.popMax() == high(uint64)\n    doAssert unsigned.popMin()\
    \ == 0'u64\n\ntype Job = object\n    priority: int\n    name: string\n\nproc `<`(a,\
    \ b: Job): bool = a.priority < b.priority\nproc `==`(a, b: Job): bool {.error:\
    \ \"\u6BD4\u8F03\u306B\u306F < \u306E\u307F\u3092\u4F7F\u7528\u3059\u308B\".}\n\
    \nblock:\n    var jobs = initDoubleEndedPriorityQueue[Job]()\n    for i in countdown(100,\
    \ 0):\n        jobs.push(Job(priority: i mod 7, name: $i))\n    var seen: array[101,\
    \ bool]\n    var previous = -1\n    while not jobs.isEmpty:\n        let job =\
    \ jobs.popMin()\n        doAssert previous <= job.priority\n        previous =\
    \ job.priority\n        for i in 0..100:\n            if job.name == $i:\n   \
    \             doAssert not seen[i]\n                seen[i] = true\n    for found\
    \ in seen: doAssert found\n    var heap = [Job(priority: 1), Job(priority: 3),\
    \ Job(priority: 2)].toDoubleEndedPriorityQueue()\n    doAssert heap.popMax().priority\
    \ == 3\n    doAssert heap.popMin().priority == 1\n\nfor n in 0..7:\n    var count\
    \ = 1\n    for _ in 0..<n: count *= 3\n    for code in 0..<count:\n        var\
    \ values = newSeq[int](n)\n        var state = code\n        for x in values.mitems:\n\
    \            x = state mod 3 - 1\n            state = state div 3\n        drain(values)\n\
    \nvar rng = initRand(20260930)\nfor trial in 0..<100:\n    var values = newSeq[int](rng.rand(0..300))\n\
    \    for x in values.mitems: x = rng.rand(-100..100)\n    drain(values)\n    var\
    \ heap = values.toDoubleEndedPriorityQueue()\n    for step in 0..<1000:\n    \
    \    case rng.rand(0..9)\n        of 0..4:\n            let x = rng.rand(-100..100)\n\
    \            heap.push(x)\n            values.add(x)\n        of 5, 6:\n     \
    \       if values.len > 0:\n                let x = values.min\n             \
    \   doAssert heap.popMin() == x\n                values.delete(values.find(x))\n\
    \        of 7, 8:\n            if values.len > 0:\n                let x = values.max\n\
    \                doAssert heap.popMax() == x\n                values.delete(values.find(x))\n\
    \        else:\n            if step mod 2 == 0:\n                heap = values.toDoubleEndedPriorityQueue()\n\
    \            else:\n                heap.clear()\n                values.setLen(0)\n\
    \        heap.check(values)\n    for x in values.sorted(): doAssert heap.popMin()\
    \ == x\n    doAssert heap.isEmpty\n\nblock:\n    const n = 100000\n    for reverse\
    \ in [false, true]:\n        var heap = initDoubleEndedPriorityQueue[int]()\n\
    \        for i in 0..<n: heap.push(if reverse: n - i - 1 else: i)\n        for\
    \ i in 0..<n div 2:\n            doAssert heap.popMin() == i\n            doAssert\
    \ heap.popMax() == n - i - 1\n        doAssert heap.isEmpty\n\necho \"Hello World\"\
    \n"
  dependsOn:
  - cplib/collections/double_ended_priority_queue.nim
  - cplib/collections/double_ended_priority_queue.nim
  isVerificationFile: true
  path: verify/collections/double_ended_priority_queue_random_test.nim
  requiredBy: []
  timestamp: '2026-09-30 06:04:26+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/double_ended_priority_queue_random_test.nim
layout: document
redirect_from:
- /verify/verify/collections/double_ended_priority_queue_random_test.nim
- /verify/verify/collections/double_ended_priority_queue_random_test.nim.html
title: verify/collections/double_ended_priority_queue_random_test.nim
---
