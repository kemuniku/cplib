---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/lis.nim
    title: cplib/utils/lis.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/lis.nim
    title: cplib/utils/lis.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/arc126/tasks/arc126_b
    links:
    - https://atcoder.jp/contests/arc126/tasks/arc126_b
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://atcoder.jp/contests/arc126/tasks/arc126_b

    import sequtils, algorithm

    import cplib/utils/lis

    proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}

    proc ii(): int {.inline.} = scanf("%lld\n", addr result)


    var _, m = ii()

    var ab = newSeqWith(m, (ii(), ii()))

    var b = ab.sortedByIt((it[0], -it[1])).mapIt(it[1])

    echo b.lis

    '
  dependsOn:
  - cplib/utils/lis.nim
  - cplib/utils/lis.nim
  isVerificationFile: true
  path: verify/utils/lis_arc126b_test.nim
  requiredBy: []
  timestamp: '2024-04-09 01:13:26+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/lis_arc126b_test.nim
layout: document
redirect_from:
- /verify/verify/utils/lis_arc126b_test.nim
- /verify/verify/utils/lis_arc126b_test.nim.html
title: verify/utils/lis_arc126b_test.nim
---
