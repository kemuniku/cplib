---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':question:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
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
    import random\nimport cplib/collections/staticRMQ\n\nproc checkAllRanges[T](values:\
    \ openArray[T]) =\n    ## \u5168\u533A\u9593\u306E\u6700\u5C0F\u5024\u3092\u611A\
    \u76F4\u89E3\u3068\u6BD4\u8F03\u3059\u308B\u3002\n    let rmq = initRMQ(values)\n\
    \    for l in 0..<values.len:\n        var expected = values[l]\n        for r\
    \ in l+1..values.len:\n            expected = min(expected, values[r-1])\n   \
    \         doAssert rmq.query(l, r) == expected\n\ncheckAllRanges(newSeq[int]())\n\
    checkAllRanges([42])\ncheckAllRanges([5, 2, 7, 1, 4, 3, 6, 0, 9, 8, 11, 10, 12,\
    \ 13, 14, 15, -1])\ncheckAllRanges([high(int), low(int), 0, high(int), low(int)])\n\
    checkAllRanges([3.5, -1.25, 0.0, -1.25, 8.0])\ncheckAllRanges([\"banana\", \"\
    apple\", \"pear\", \"apple\", \"orange\"])\n\nvar rng = initRand(20260908)\nfor\
    \ n in [2, 7, 8, 9, 15, 16, 17, 31, 32, 33, 63, 64, 65,\n          127, 128, 129,\
    \ 255, 256, 257, 511, 512, 513]:\n    var values = newSeq[int](n)\n    for i in\
    \ 0..<n: values[i] = i\n    checkAllRanges(values)\n    for i in 0..<n: values[i]\
    \ = n-i\n    checkAllRanges(values)\n    for i in 0..<n: values[i] = 7\n    checkAllRanges(values)\n\
    \    for i in 0..<n: values[i] = (if i mod 2 == 0: -1 else: 1)\n    checkAllRanges(values)\n\
    \    for trial in 0..<4:\n        for value in values.mitems: value = rng.rand(-100..100)\n\
    \        checkAllRanges(values)\n\nvar values32 = newSeq[int32](257)\nvar strings\
    \ = newSeq[string](129)\nfor value in values32.mitems: value = int32(rng.rand(-100..100))\n\
    for value in strings.mitems: value = $rng.rand(100)\ncheckAllRanges(values32)\n\
    checkAllRanges(strings)\n\nblock:\n    var values = @[3, 1, 4]\n    let rmq =\
    \ initRMQ(values)\n    values[1] = 9\n    doAssert rmq.query(0, 3) == 1\n\nfor\
    \ n in 0..130:\n    var values = newSeq[int32](n)\n    for value in values.mitems:\n\
    \        case rng.rand(3)\n        of 0: value = low(int32)\n        of 1: value\
    \ = high(int32)\n        else: value = int32(rng.rand(-10..10))\n    checkAllRanges(values)\n\
    \    var values64 = newSeq[int64](n)\n    for i in 0..<n:\n        values64[i]\
    \ = (if values[i] == low(int32): low(int64)\n                       elif values[i]\
    \ == high(int32): high(int64)\n                       else: int64(values[i]))\n\
    \    checkAllRanges(values64)\n\ncheckAllRanges([0'u64, high(uint64), 1'u64])\n\
    \nstatic:\n    let rmq = initRMQ([3, 1, 4])\n    doAssert rmq.query(0, 3) == 1\n\
    \nblock:\n    var original = initRMQ([3, 1, 4])\n    let copied = original\n \
    \   original = initRMQ([9, 8, 7])\n    doAssert copied.query(0, 3) == 1\n    doAssert\
    \ original.query(0, 3) == 7\n\nblock:\n    var values = newSeq[int32](4097)\n\
    \    for value in values.mitems: value = int32(rng.rand(-1_000_000..1_000_000))\n\
    \    let rmq = initRMQ(values)\n    for trial in 0..<4096:\n        let l = rng.rand(values.high)\n\
    \        let r = rng.rand(l+1..values.len)\n        var expected = values[l]\n\
    \        for i in l+1..<r: expected = min(expected, values[i])\n        doAssert\
    \ rmq.query(l, r) == expected\n\nwhen compileOption(\"assertions\"):\n    let\
    \ rmq = initRMQ([3, 1, 4])\n    for (l, r) in [(-1, 1), (0, 0), (1, 1), (0, 4),\
    \ (2, 1)]:\n        var rejected = false\n        try:\n            discard rmq.query(l,\
    \ r)\n        except AssertionDefect:\n            rejected = true\n        doAssert\
    \ rejected\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/staticRMQ.nim
  - cplib/collections/staticRMQ.nim
  isVerificationFile: true
  path: verify/AI/staticRMQ_test.nim
  requiredBy: []
  timestamp: '2026-09-08 14:58:59+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/staticRMQ_test.nim
layout: document
redirect_from:
- /verify/verify/AI/staticRMQ_test.nim
- /verify/verify/AI/staticRMQ_test.nim.html
title: verify/AI/staticRMQ_test.nim
---
