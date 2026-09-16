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
    import random, algorithm\nimport cplib/collections/bitset_avx2 as dynamic2\nimport\
    \ cplib/collections/bitset_avx512 as dynamic512\nimport cplib/collections/staticbitset_avx2\
    \ as fixed2\nimport cplib/collections/staticbitset_avx512 as fixed512\n\nproc\
    \ check[T](x: T, bits: seq[bool]) =\n    var prev = -1\n    doAssert x.prevSetBit(-1)\
    \ == -1\n    for start in 0..<bits.len:\n        if bits[start]: prev = start\n\
    \        doAssert x.prevSetBit(start) == prev\n    var next = -1\n    doAssert\
    \ x.nextSetBit(bits.len) == -1\n    for start in countdown(bits.len - 1, 0):\n\
    \        if bits[start]: next = start\n        doAssert x.nextSetBit(start) ==\
    \ next\n    doAssert x.lowestBit == next\n    var expected, actual, backward:\
    \ seq[int]\n    for i, bit in bits:\n        if bit: expected.add(i)\n    for\
    \ i in x: actual.add(i)\n    doAssert actual == expected\n    var pos = x.prevSetBit(x.len\
    \ - 1)\n    while pos >= 0:\n        backward.add(pos)\n        pos = x.prevSetBit(pos\
    \ - 1)\n    backward.reverse()\n    doAssert backward == expected\n    when compileOption(\"\
    boundChecks\"):\n        for invalid in [-2, bits.len]:\n            var raised\
    \ = false\n            try: discard x.prevSetBit(invalid)\n            except\
    \ IndexDefect: raised = true\n            doAssert raised\n        for invalid\
    \ in [-1, bits.len+1]:\n            var raised = false\n            try: discard\
    \ x.nextSetBit(invalid)\n            except IndexDefect: raised = true\n     \
    \       doAssert raised\n\ntemplate checkSize(n: static int) =\n    block:\n \
    \       proc checkAll(bits: seq[bool]) =\n            check(dynamic2.initBitSet(bits),\
    \ bits)\n            check(dynamic512.initBitSet(bits), bits)\n            check(fixed2.initBitSet(bits,\
    \ n), bits)\n            check(fixed512.initBitSet(bits, n), bits)\n        var\
    \ bits = newSeq[bool](n)\n        checkAll(bits)\n        for i in 0..<n: bits[i]\
    \ = true\n        checkAll(bits)\n        for pos in [0, 1, 63, 64, 255, 256,\
    \ 511, 512, 1023, 1024, n-1]:\n            if pos >= 0 and pos < n:\n        \
    \        bits = newSeq[bool](n)\n                bits[pos] = true\n          \
    \      checkAll(bits)\n        for trial in 0..<8:\n            for i in 0..<n:\
    \ bits[i] = rand(99) < (if trial mod 2 == 0: 1 else: 50)\n            checkAll(bits)\n\
    \nrandomize(156)\ncheckSize(0)\ncheckSize(1)\ncheckSize(63)\ncheckSize(64)\ncheckSize(65)\n\
    checkSize(255)\ncheckSize(256)\ncheckSize(257)\ncheckSize(511)\ncheckSize(512)\n\
    checkSize(513)\ncheckSize(1025)\ncheckSize(4097)\necho \"Hello World\"\n"
  dependsOn: []
  isVerificationFile: true
  path: verify/AI/bitset_simd_search_test.nim
  requiredBy: []
  timestamp: '2026-09-14 23:18:26+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/bitset_simd_search_test.nim
layout: document
redirect_from:
- /verify/verify/AI/bitset_simd_search_test.nim
- /verify/verify/AI/bitset_simd_search_test.nim.html
title: verify/AI/bitset_simd_search_test.nim
---
