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
    import random, algorithm\nimport cplib/collections/bitset as scalar\nimport cplib/collections/bitset_avx2\
    \ as avx2\nimport cplib/collections/bitset_avx512 as avx512\nimport cplib/collections/staticbitset\
    \ as fixed\nimport cplib/collections/staticbitset_avx2 as fixed2\nimport cplib/collections/staticbitset_avx512\
    \ as fixed512\n\nproc reference(a, b: seq[bool]): int =\n    for i in 0..<a.len:\n\
    \        if a[i] != b[i]:\n            return if a[i]: 1 else: -1\n\nproc check[T](x,\
    \ y: T, expected: int) =\n    doAssert cmp(x, y) == expected\n    doAssert cmp(y,\
    \ x) == -expected\n    doAssert cmp(x, x) == 0\n    doAssert (x < y) == (expected\
    \ < 0)\n    doAssert (x <= y) == (expected <= 0)\n    doAssert lexLess(x, y) ==\
    \ (expected < 0)\n    doAssert (x > y) == (expected > 0)\n    doAssert (x >= y)\
    \ == (expected >= 0)\n    var values = @[y, x]\n    values.sort()\n    doAssert\
    \ values[0] <= values[1]\n\ntemplate checkSize(n: static int) =\n    block:\n\
    \        proc checkPair(a, b: seq[bool]) =\n            let expected = reference(a,\
    \ b)\n            check(scalar.initBitSet(a), scalar.initBitSet(b), expected)\n\
    \            check(avx2.initBitSet(a), avx2.initBitSet(b), expected)\n       \
    \     check(avx512.initBitSet(a), avx512.initBitSet(b), expected)\n          \
    \  check(fixed.initBitSet(a, n), fixed.initBitSet(b, n), expected)\n         \
    \   check(fixed2.initBitSet(a, n), fixed2.initBitSet(b, n), expected)\n      \
    \      check(fixed512.initBitSet(a, n), fixed512.initBitSet(b, n), expected)\n\
    \        var a = newSeq[bool](n)\n        var b = newSeq[bool](n)\n        checkPair(a,\
    \ b)\n        for i in 0..<n:\n            b[i] = true\n            checkPair(a,\
    \ b)\n            b[i] = false\n            a[i] = true\n            for j in\
    \ i+1..<n:\n                b[j] = true\n            checkPair(a, b)\n       \
    \     a[i] = false\n            b = newSeq[bool](n)\n        for trial in 0..<100:\n\
    \            for i in 0..<n:\n                a[i] = rand(1) == 1\n          \
    \      b[i] = a[i]\n            checkPair(a, b)\n            if n > 0:\n     \
    \           let start = rand(n - 1)\n                for i in start..<n:\n   \
    \                 b[i] = rand(1) == 1\n                checkPair(a, b)\n\nrandomize(7319)\n\
    checkSize(0)\ncheckSize(1)\ncheckSize(63)\ncheckSize(64)\ncheckSize(65)\ncheckSize(255)\n\
    checkSize(256)\ncheckSize(257)\ncheckSize(511)\ncheckSize(512)\ncheckSize(513)\n\
    checkSize(1025)\n\ntemplate checkMismatch(make: untyped) =\n    block:\n     \
    \   var raised = false\n        try:\n            discard cmp(make(1), make(2))\n\
    \        except ValueError:\n            raised = true\n        doAssert raised\n\
    checkMismatch(scalar.initBitSet)\ncheckMismatch(avx2.initBitSet)\ncheckMismatch(avx512.initBitSet)\n\
    echo \"Hello World\"\n"
  dependsOn: []
  isVerificationFile: true
  path: verify/AI/bitset_compare_test.nim
  requiredBy: []
  timestamp: '2026-09-13 04:30:30+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/bitset_compare_test.nim
layout: document
redirect_from:
- /verify/verify/AI/bitset_compare_test.nim
- /verify/verify/AI/bitset_compare_test.nim.html
title: verify/AI/bitset_compare_test.nim
---
