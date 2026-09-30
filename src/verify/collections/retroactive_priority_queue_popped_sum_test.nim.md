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
    import algorithm, random\nimport cplib/collections/retroactive_priority_queue\n\
    import cplib/collections/compressed_retroactive_priority_queue\nimport cplib/collections/dynamic_retroactive_priority_queue\n\
    \nvar rng = initRand(36328)\nfor order in [Ascending, Descending]:\n    let fixed\
    \ = initRetroactivePriorityQueue[int64](40, order)\n    var times: seq[int]\n\
    \    for i in 0..<40: times.add(i * 17 - 500)\n    let compressed = initCompressedRetroactivePriorityQueue[int,\
    \ int64](times, order)\n    let dynamic = initDynamicRetroactivePriorityQueue[int,\
    \ int64](order)\n    var kind = newSeq[int](40)\n    var values = newSeq[int64](40)\n\
    \    doAssert fixed.poppedSum == 0 and compressed.poppedSum == 0 and dynamic.poppedSum\
    \ == 0\n    for step in 0..<5000:\n        let i = rng.rand(39)\n        kind[i]\
    \ = rng.rand(2)\n        values[i] = int64(rng.rand(-100..100))\n        case\
    \ kind[i]\n        of 0:\n            fixed.erase(i)\n            compressed.erase(times[i])\n\
    \            dynamic.erase(times[i])\n        of 1:\n            fixed.setPush(i,\
    \ values[i])\n            compressed.setPush(times[i], values[i])\n          \
    \  dynamic.setPush(times[i], values[i])\n        else:\n            fixed.setPop(i)\n\
    \            compressed.setPop(times[i])\n            dynamic.setPop(times[i])\n\
    \        var heap: seq[int64]\n        var popped = 0'i64\n        for t in 0..<40:\n\
    \            if kind[t] == 1: heap.add(values[t])\n            elif kind[t] ==\
    \ 2 and heap.len > 0:\n                heap.sort(order)\n                popped\
    \ += heap[0]\n                heap.delete(0)\n        var remaining = 0'i64\n\
    \        for x in heap: remaining += x\n        doAssert fixed.poppedSum == popped\n\
    \        doAssert compressed.poppedSum == popped\n        doAssert dynamic.poppedSum\
    \ == popped\n        doAssert fixed.sum == remaining and compressed.sum == remaining\
    \ and dynamic.sum == remaining\n    for i in 0..<40:\n        fixed.erase(i)\n\
    \        compressed.erase(times[i])\n        dynamic.erase(times[i])\n    doAssert\
    \ fixed.poppedSum == 0 and compressed.poppedSum == 0 and dynamic.poppedSum ==\
    \ 0\n\ntemplate extreme(pq: untyped, T: typedesc) =\n    let queue = pq\n    queue.setPop(1)\n\
    \    queue.setPush(0, high(T))\n    queue.setPush(2, high(T))\n    doAssert queue.sum\
    \ == high(T) and queue.poppedSum == high(T)\n    queue.erase(0)\n    doAssert\
    \ queue.poppedSum == 0\n    queue.erase(2)\n    when T is SomeSignedInt:\n   \
    \     queue.setPush(0, low(T))\n        queue.setPush(2, low(T))\n        doAssert\
    \ queue.sum == low(T) and queue.poppedSum == low(T)\n\nextreme(initRetroactivePriorityQueue[int64](3),\
    \ int64)\nextreme(initDynamicRetroactivePriorityQueue[int, int64](), int64)\n\
    extreme(initRetroactivePriorityQueue[uint64](3), uint64)\nextreme(initDynamicRetroactivePriorityQueue[int,\
    \ uint64](), uint64)\n\nblock:\n    let queue = initRetroactivePriorityQueue[float64](3)\n\
    \    queue.setPush(0, 1.5)\n    queue.setPush(1, 2.5)\n    queue.setPop(2)\n \
    \   doAssert queue.poppedSum == 1.5 and queue.sum == 2.5\n    queue.erase(2)\n\
    \    doAssert queue.poppedSum == 0\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/compressed_coordinates_internal.nim
  - cplib/collections/compressed_retroactive_priority_queue.nim
  - cplib/collections/retroactive_priority_queue.nim
  - cplib/collections/compressed_coordinates_internal.nim
  - cplib/collections/compressed_retroactive_priority_queue.nim
  - cplib/collections/retroactive_priority_queue.nim
  - cplib/collections/dynamic_retroactive_priority_queue.nim
  - cplib/collections/dynamic_retroactive_priority_queue.nim
  isVerificationFile: true
  path: verify/collections/retroactive_priority_queue_popped_sum_test.nim
  requiredBy: []
  timestamp: '2026-09-28 01:13:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/retroactive_priority_queue_popped_sum_test.nim
layout: document
redirect_from:
- /verify/verify/collections/retroactive_priority_queue_popped_sum_test.nim
- /verify/verify/collections/retroactive_priority_queue_popped_sum_test.nim.html
title: verify/collections/retroactive_priority_queue_popped_sum_test.nim
---
