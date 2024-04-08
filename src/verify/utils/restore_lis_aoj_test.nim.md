---
data:
  _extendedDependsOn:
  - icon: ':x:'
    path: cplib/utils/lis.nim
    title: cplib/utils/lis.nim
  - icon: ':x:'
    path: cplib/utils/lis.nim
    title: cplib/utils/lis.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':x:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/courses/library/7/DPL/1/DPL_1_D
    links:
    - https://onlinejudge.u-aizu.ac.jp/courses/library/7/DPL/1/DPL_1_D
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/7/DPL/1/DPL_1_D

    import sequtils

    import cplib/utils/lis

    proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}

    proc ii(): int {.inline.} = scanf("%lld\n", addr result)


    var n = ii()

    var a = newSeqWith(n, ii())

    echo a.restore_lis.len

    '
  dependsOn:
  - cplib/utils/lis.nim
  - cplib/utils/lis.nim
  isVerificationFile: true
  path: verify/utils/restore_lis_aoj_test.nim
  requiredBy: []
  timestamp: '2024-04-09 01:08:32+09:00'
  verificationStatus: TEST_WRONG_ANSWER
  verifiedWith: []
documentation_of: verify/utils/restore_lis_aoj_test.nim
layout: document
redirect_from:
- /verify/verify/utils/restore_lis_aoj_test.nim
- /verify/verify/utils/restore_lis_aoj_test.nim.html
title: verify/utils/restore_lis_aoj_test.nim
---
