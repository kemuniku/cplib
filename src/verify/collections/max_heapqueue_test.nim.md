---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/max_heapqueue.nim
    title: cplib/collections/max_heapqueue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/max_heapqueue.nim
    title: cplib/collections/max_heapqueue.nim
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
    import algorithm, heapqueue, random\nimport cplib/collections/max_heapqueue\n\n\
    proc check(heap: MaxHeapQueue[int], values: seq[int]) =\n    doAssert heap.len\
    \ == values.len\n    var actual: seq[int]\n    for x in heap:\n        doAssert\
    \ x == heap[actual.len]\n        actual.add(x)\n    doAssert actual.sorted() ==\
    \ values.sorted()\n    for i in 1..<heap.len:\n        doAssert heap[i] <= heap[(i\
    \ - 1) div 2]\n    if values.len > 0:\n        doAssert heap[0] == values.max\n\
    \nblock:\n    var heap: MaxHeapQueue[int]\n    doAssert heap.len == 0\n    doAssert\
    \ $heap == \"[]\"\n    doAssert heap.find(0) == -1\n    doAssert 0 notin heap\n\
    \    doAssert heap.pushpop(5) == 5\n    doAssert heap.len == 0\n    heap.clear()\n\
    \    heap.push(low(int))\n    doAssert heap[0] == low(int)\n    doAssert heap.replace(high(int))\
    \ == low(int)\n    doAssert heap.replace(0) == high(int)\n    doAssert heap.pushpop(high(int))\
    \ == high(int)\n    doAssert heap[0] == 0\n    doAssert heap.pushpop(low(int))\
    \ == 0\n    doAssert heap.pop() == low(int)\n    doAssert heap.len == 0\n    heap.push(1)\n\
    \    heap.del(0)\n    doAssert heap.len == 0\n\nblock:\n    let empty: seq[int]\
    \ = @[]\n    var heap = empty.toMaxHeapQueue()\n    doAssert heap.len == 0\n \
    \   let values = @[low(int), high(int), 0, -1, 1, high(int), low(int)]\n    heap\
    \ = values.toMaxHeapQueue()\n    heap.check(values)\n    for x in values.sorted(Descending):\n\
    \        doAssert heap.pop() == x\n    doAssert heap.len == 0\n\nblock:\n    var\
    \ heap = [10, 5, 9, 1, 2, 8, 7].toMaxHeapQueue()\n    doAssert heap[3] == 1\n\
    \    heap.del(3)\n    heap.check(@[10, 5, 9, 2, 8, 7])\n    for x in [10, 9, 8,\
    \ 7, 5, 2]:\n        doAssert heap.pop() == x\n\nblock:\n    var heap = [3, 1,\
    \ 2].toMaxHeapQueue()\n    var copy = heap\n    doAssert copy.pop() == 3\n   \
    \ copy.push(4)\n    heap.check(@[1, 2, 3])\n    copy.check(@[1, 2, 4])\n    heap.clear()\n\
    \    heap.push(5)\n    doAssert heap.pop() == 5\n    copy.check(@[1, 2, 4])\n\n\
    block:\n    var heap = [\"abc\", \"xyz\", \"abc\"].toMaxHeapQueue()\n    doAssert\
    \ heap.pop() == \"xyz\"\n    doAssert heap.find(\"abc\") >= 0\n    doAssert \"\
    missing\" notin heap\n    doAssert heap.pop() == \"abc\"\n    doAssert heap.pop()\
    \ == \"abc\"\n    doAssert $[\"b\", \"a\"].toMaxHeapQueue() == \"[\\\"b\\\", \\\
    \"a\\\"]\"\n    doAssert $['\\n'].toMaxHeapQueue() == $['\\n'].toHeapQueue()\n\
    \    doAssert $[2, 1].toMaxHeapQueue() == \"[2, 1]\"\n\nblock:\n    var heap =\
    \ [(1, 9), (2, 0), (1, 10)].toMaxHeapQueue()\n    doAssert heap.pop() == (2, 0)\n\
    \    doAssert heap.pop() == (1, 10)\n    doAssert heap.pop() == (1, 9)\n\ntype\
    \ Job = object\n    priority: int\n    name: string\n\nproc `<`(a, b: Job): bool\
    \ = a.priority < b.priority\nproc `==`(a, b: Job): bool = a.name == b.name\n\n\
    block:\n    let low = Job(priority: 1, name: \"low\")\n    let middle = Job(priority:\
    \ 2, name: \"middle\")\n    let high = Job(priority: 3, name: \"high\")\n    var\
    \ heap = [middle, low].toMaxHeapQueue()\n    heap.push(high)\n    doAssert heap[0].name\
    \ == \"high\"\n    doAssert Job(priority: -1, name: \"middle\") in heap\n    doAssert\
    \ heap[heap.find(low)].name == \"low\"\n    doAssert heap.replace(middle).name\
    \ == \"high\"\n    doAssert heap.pushpop(high).name == \"high\"\n    doAssert\
    \ heap.pushpop(low).name == \"middle\"\n    heap.del(heap.find(middle))\n    doAssert\
    \ heap.pop().name == \"low\"\n    doAssert heap.pop().name == \"low\"\n    doAssert\
    \ heap.len == 0\n\nblock:\n    var minimum = initHeapQueue[int]()\n    var maximum\
    \ = initMaxHeapQueue[int]()\n    for x in [3, 1, 2]:\n        minimum.push(x)\n\
    \        maximum.push(x)\n    doAssert minimum.pop() == 1\n    doAssert maximum.pop()\
    \ == 3\n\nvar rng = initRand(20260926)\nfor trial in 0..<100:\n    var values:\
    \ seq[int]\n    for i in 0..<rng.rand(100):\n        values.add(rng.rand(-30..30))\n\
    \    var heap = values.toMaxHeapQueue()\n    heap.check(values)\n    for step\
    \ in 0..<300:\n        let x = rng.rand(-30..30)\n        case rng.rand(0..9)\n\
    \        of 0, 1, 2:\n            heap.push(x)\n            values.add(x)\n  \
    \      of 3:\n            if values.len > 0:\n                let expected = values.max\n\
    \                doAssert heap.pop() == expected\n                values.delete(values.find(expected))\n\
    \        of 4:\n            if values.len > 0:\n                let index = rng.rand(heap.len\
    \ - 1)\n                let removed = heap[index]\n                heap.del(index)\n\
    \                values.delete(values.find(removed))\n        of 5:\n        \
    \    if values.len > 0:\n                let expected = values.max\n         \
    \       doAssert heap.replace(x) == expected\n                values.delete(values.find(expected))\n\
    \                values.add(x)\n        of 6:\n            values.add(x)\n   \
    \         let expected = values.max\n            doAssert heap.pushpop(x) == expected\n\
    \            values.delete(values.find(expected))\n        of 7:\n           \
    \ heap.clear()\n            values.setLen(0)\n        of 8:\n            let index\
    \ = heap.find(x)\n            doAssert (index >= 0) == (x in values)\n       \
    \     doAssert (x in heap) == (x in values)\n            if index >= 0:\n    \
    \            doAssert heap[index] == x\n                for i in 0..<index:\n\
    \                    doAssert heap[i] != x\n        else:\n            heap =\
    \ values.toMaxHeapQueue()\n        heap.check(values)\n    for x in values.sorted(Descending):\n\
    \        doAssert heap.pop() == x\n    doAssert heap.len == 0\n\necho \"Hello\
    \ World\"\n"
  dependsOn:
  - cplib/collections/max_heapqueue.nim
  - cplib/collections/max_heapqueue.nim
  isVerificationFile: true
  path: verify/collections/max_heapqueue_test.nim
  requiredBy: []
  timestamp: '2026-09-27 01:42:57+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/max_heapqueue_test.nim
layout: document
redirect_from:
- /verify/verify/collections/max_heapqueue_test.nim
- /verify/verify/collections/max_heapqueue_test.nim.html
title: verify/collections/max_heapqueue_test.nim
---
