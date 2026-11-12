---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/memo.nim
    title: cplib/utils/memo.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/memo.nim
    title: cplib/utils/memo.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    \nimport cplib/utils/memo\n\nblock:\n    var calls = 0\n    proc fib(n: int):\
    \ int {.memo.} =\n        inc calls\n        if n <= 1:\n            return n\n\
    \        fib(n - 1) + fib(n - 2)\n\n    doAssert fib(10) == 55\n    doAssert calls\
    \ == 11\n    doAssert fib(10) == 55\n    doAssert calls == 11\n\nblock:\n    var\
    \ redCalls, blueCalls = 0\n    proc red(n: int): int\n    proc blue(n: int): int\n\
    \n    proc red(n: int): int {.memo.} =\n        inc redCalls\n        if n ==\
    \ 1:\n            return 0\n        return red(n - 1) + blue(n) * 2\n\n    proc\
    \ blue(n: int): int {.memo.} =\n        inc blueCalls\n        if n == 1:\n  \
    \          return 1\n        return red(n - 1) + blue(n - 1) * 3\n\n    doAssert\
    \ red(4) == 198\n    doAssert blue(4) == 81\n    doAssert redCalls == 4 and blueCalls\
    \ == 4\n    doAssert red(4) == 198\n    doAssert blue(4) == 81\n    doAssert redCalls\
    \ == 4 and blueCalls == 4\n\nblock:\n    var calls = 0\n    proc choose(n, k:\
    \ int): int {.memo.} =\n        inc calls\n        if k == 0 or k == n:\n    \
    \        return 1\n        choose(n - 1, k - 1) + choose(n - 1, k)\n\n    doAssert\
    \ choose(6, 3) == 20\n    let cachedCalls = calls\n    doAssert choose(6, 3) ==\
    \ 20\n    doAssert calls == cachedCalls\n\nblock:\n    var calls = 0\n    proc\
    \ retry(n: int): int {.memo.} =\n        inc calls\n        if calls == 1:\n \
    \           raise newException(ValueError, \"retry\")\n        result = n * 2\n\
    \n    var raised = false\n    try:\n        discard retry(3)\n    except ValueError:\n\
    \        raised = true\n    doAssert raised\n    doAssert retry(3) == 6\n    doAssert\
    \ retry(3) == 6\n    doAssert calls == 2\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/utils/memo.nim
  - cplib/utils/memo.nim
  isVerificationFile: true
  path: verify/utils/memo_test.nim
  requiredBy: []
  timestamp: '2026-11-13 04:26:50+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/memo_test.nim
layout: document
redirect_from:
- /verify/verify/utils/memo_test.nim
- /verify/verify/utils/memo_test.nim.html
title: verify/utils/memo_test.nim
---
