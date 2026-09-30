---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
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
    echo \"Hello World\"\n\nimport cplib/math/isqrt\n\nproc referenceIsqrt(n: int):\
    \ int =\n    var lo = 0\n    var hi = n\n    while lo < hi:\n        let distance\
    \ = hi - lo\n        let mid = lo + (distance shr 1) + (distance and 1)\n    \
    \    if mid <= n div mid:\n            lo = mid\n        else:\n            hi\
    \ = mid - 1\n    return lo\n\nfor n in 0..100_000:\n    doAssert isqrt(n) == referenceIsqrt(n)\n\
    \nwhen sizeof(int) == 8:\n    const maxRoot = 3_037_000_499.int\n    doAssert\
    \ isqrt(1_000_000_000_000.int) == 1_000_000\nelse:\n    const maxRoot = 46_340\n\
    \ndoAssert isqrt(high(int)) == maxRoot\ndoAssert isqrt(high(int) - 1) == maxRoot\n\
    for root in [1, 2, 3, 15, 16, 100, maxRoot - 1, maxRoot]:\n    let square = root\
    \ * root\n    doAssert isqrt(square - 1) == root - 1\n    doAssert isqrt(square)\
    \ == root\n    doAssert isqrt(square + 1) == root\n\nfor bit in 0..<(sizeof(int)\
    \ * 8 - 1):\n    let value = 1 shl bit\n    for n in [value - 1, value, value\
    \ + 1, high(int) - value]:\n        doAssert isqrt(n) == referenceIsqrt(n)\n\n\
    for offset in 0..1000:\n    let n = high(int) - offset\n    doAssert isqrt(n)\
    \ == referenceIsqrt(n)\n"
  dependsOn:
  - cplib/math/isqrt.nim
  - cplib/math/isqrt.nim
  isVerificationFile: true
  path: verify/AI/isqrt_test.nim
  requiredBy: []
  timestamp: '2026-09-30 21:03:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/isqrt_test.nim
layout: document
redirect_from:
- /verify/verify/AI/isqrt_test.nim
- /verify/verify/AI/isqrt_test.nim.html
title: verify/AI/isqrt_test.nim
---
