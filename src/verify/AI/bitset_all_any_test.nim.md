---
data:
  _extendedDependsOn: []
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
    import random\nwhen defined(cpp):\n    import cplib/collections/bitset as scalar\n\
    \    import cplib/collections/staticbitset as fixed\nimport cplib/collections/bitset_avx2\
    \ as avx2\nimport cplib/collections/bitset_avx512 as avx512\nimport cplib/collections/staticbitset_avx2\
    \ as fixed2\nimport cplib/collections/staticbitset_avx512 as fixed512\n\nproc\
    \ check[T](x: T, expectedAll, expectedAny: bool) =\n    doAssert x.all == expectedAll\n\
    \    doAssert x.any == expectedAny\n    doAssert (~x).all == not expectedAny\n\
    \    doAssert (~x).any == not expectedAll\n    doAssert x.all == expectedAll\n\
    \    doAssert x.any == expectedAny\n\ntemplate checkSize(n: static int) =\n  \
    \  block:\n        proc checkBits(bits: seq[bool]) =\n            var expectedAll\
    \ = true\n            var expectedAny = false\n            for bit in bits:\n\
    \                expectedAll = expectedAll and bit\n                expectedAny\
    \ = expectedAny or bit\n            when defined(cpp):\n                check(scalar.initBitSet(bits),\
    \ expectedAll, expectedAny)\n                check(fixed.initBitSet(bits, n),\
    \ expectedAll, expectedAny)\n            check(avx2.initBitSet(bits), expectedAll,\
    \ expectedAny)\n            check(avx512.initBitSet(bits), expectedAll, expectedAny)\n\
    \            check(fixed2.initBitSet(bits, n), expectedAll, expectedAny)\n   \
    \         check(fixed512.initBitSet(bits, n), expectedAll, expectedAny)\n    \
    \    var bits = newSeq[bool](n)\n        checkBits(bits)\n        for i in 0..<n:\n\
    \            bits[i] = true\n            checkBits(bits)\n            bits[i]\
    \ = false\n        for i in 0..<n:\n            bits[i] = true\n        checkBits(bits)\n\
    \        for i in 0..<n:\n            bits[i] = false\n            checkBits(bits)\n\
    \            bits[i] = true\n        for trial in 0..<100:\n            for i\
    \ in 0..<n:\n                bits[i] = rand(1) == 1\n            checkBits(bits)\n\
    \nrandomize(8341)\ncheckSize(0)\ncheckSize(1)\ncheckSize(63)\ncheckSize(64)\n\
    checkSize(65)\ncheckSize(127)\ncheckSize(128)\ncheckSize(255)\ncheckSize(256)\n\
    checkSize(257)\ncheckSize(511)\ncheckSize(512)\ncheckSize(513)\ncheckSize(1023)\n\
    checkSize(1024)\ncheckSize(1025)\necho \"Hello World\"\n"
  dependsOn: []
  isVerificationFile: true
  path: verify/AI/bitset_all_any_test.nim
  requiredBy: []
  timestamp: '2026-09-13 04:30:30+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/bitset_all_any_test.nim
layout: document
redirect_from:
- /verify/verify/AI/bitset_all_any_test.nim
- /verify/verify/AI/bitset_all_any_test.nim.html
title: verify/AI/bitset_all_any_test.nim
---
