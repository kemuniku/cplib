---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/radix_heap.nim
    title: cplib/collections/radix_heap.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/radix_heap.nim
    title: cplib/collections/radix_heap.nim
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
    import algorithm, heapqueue, random\nimport cplib/collections/radix_heap\n\nproc\
    \ checkBounds[K: SomeInteger]() =\n    var heap = initRadixHeap[K, string]()\n\
    \    var keys = @[low(K), low(K) + K(1), K(0), K(1), high(K) - K(1), high(K)]\n\
    \    when K is SomeSignedInt:\n        keys.add(K(-1))\n    for key in keys:\n\
    \        heap.push(key, $key)\n    keys.sort()\n    for key in keys:\n       \
    \ doAssert heap.top().key == key\n        doAssert heap[0] == heap.top()\n   \
    \     doAssert heap.pop() == (key, $key)\n    doAssert heap.isEmpty()\n    heap.push(high(K),\
    \ \"last\")\n    doAssert heap.pop().key == high(K)\n    heap.clear()\n    heap.push(low(K),\
    \ \"first\")\n    doAssert heap.pop().key == low(K)\n\ncheckBounds[int]()\ncheckBounds[int8]()\n\
    checkBounds[int16]()\ncheckBounds[int32]()\ncheckBounds[int64]()\ncheckBounds[uint]()\n\
    checkBounds[uint8]()\ncheckBounds[uint16]()\ncheckBounds[uint32]()\ncheckBounds[uint64]()\n\
    \nvar rng = initRand(712367)\nvar heap = initRadixHeap[int, int]()\nvar reference\
    \ = initHeapQueue[int]()\nvar last = -100000\nfor step in 0..<30000:\n    if reference.len\
    \ == 0 or rng.rand(99) < 60:\n        let key = last + rng.rand(10000)\n     \
    \   heap.push((key, step))\n        reference.push(key)\n    else:\n        doAssert\
    \ heap.top().key == reference[0]\n        last = heap.pop().key\n        doAssert\
    \ last == reference.pop()\n    doAssert heap.len == reference.len\nwhile reference.len\
    \ != 0:\n    doAssert heap.pop().key == reference.pop()\n\ntype Payload = object\n\
    \    data: seq[string]\nvar payloadHeap = initRadixHeap[int, Payload](-3)\npayloadHeap.push(-2,\
    \ Payload(data: @[\"a\", \"b\"]))\npayloadHeap.push(-2, Payload(data: @[\"c\"\
    ]))\ndoAssert payloadHeap.pop().value.data.len > 0\npayloadHeap.clear(-10)\npayloadHeap.push(-10,\
    \ Payload(data: @[\"reset\"]))\ndoAssert payloadHeap.pop().value.data == @[\"\
    reset\"]\n\nwhen compileOption(\"assertions\"):\n    var rejected = false\n  \
    \  try:\n        payloadHeap.push(-11, Payload())\n    except AssertionDefect:\n\
    \        rejected = true\n    doAssert rejected\n    rejected = false\n    try:\n\
    \        discard payloadHeap.pop()\n    except AssertionDefect:\n        rejected\
    \ = true\n    doAssert rejected\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/radix_heap.nim
  - cplib/collections/radix_heap.nim
  isVerificationFile: true
  path: verify/AI/radix_heap_test.nim
  requiredBy: []
  timestamp: '2026-09-23 19:26:35+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/radix_heap_test.nim
layout: document
redirect_from:
- /verify/verify/AI/radix_heap_test.nim
- /verify/verify/AI/radix_heap_test.nim.html
title: verify/AI/radix_heap_test.nim
---
