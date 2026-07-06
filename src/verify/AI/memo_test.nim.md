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
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    echo \"Hello World\"\n\nimport cplib/utils/memo\n\nvar calls = 0\n\nproc fib(n:\
    \ int): int {.memo.} =\n  calls += 1\n  if n <= 1:\n    n\n  else:\n    fib(n\
    \ - 1) + fib(n - 2)\n\nassert fib(10) == 55\nlet callsAfterFirst = calls\nassert\
    \ fib(10) == 55\nassert calls == callsAfterFirst\n\nproc addPair(a, b: int): int\
    \ {.memo.} =\n  calls += 1\n  a + b\n\nlet beforePair = calls\nassert addPair(2,\
    \ 3) == 5\nassert addPair(2, 3) == 5\nassert calls == beforePair + 1\n"
  dependsOn:
  - cplib/utils/memo.nim
  - cplib/utils/memo.nim
  isVerificationFile: true
  path: verify/AI/memo_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/memo_test.nim
layout: document
redirect_from:
- /verify/verify/AI/memo_test.nim
- /verify/verify/AI/memo_test.nim.html
title: verify/AI/memo_test.nim
---
