---
data:
  _extendedDependsOn:
  - icon: ':warning:'
    path: cplib/utils/bititers.nim
    title: cplib/utils/bititers.nim
  - icon: ':warning:'
    path: cplib/utils/bititers.nim
    title: cplib/utils/bititers.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc269/tasks/abc269_c
    links:
    - https://atcoder.jp/contests/abc269/tasks/abc269_c
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://atcoder.jp/contests/abc269/tasks/abc269_c

    import cplib/utils/bititers

    import sequtils, strutils, algorithm

    proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}

    proc ii(): int {.inline.} = scanf("%lld\n", addr result)


    var N = ii()

    echo bitsubseteq_descending(N).toseq().reversed().join("\n")

    '
  dependsOn:
  - cplib/utils/bititers.nim
  - cplib/utils/bititers.nim
  isVerificationFile: false
  path: verify/utils/bititers_bitsubseteq_descending_test_.nim
  requiredBy: []
  timestamp: '2025-03-09 18:22:34+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/utils/bititers_bitsubseteq_descending_test_.nim
layout: document
redirect_from:
- /library/verify/utils/bititers_bitsubseteq_descending_test_.nim
- /library/verify/utils/bititers_bitsubseteq_descending_test_.nim.html
title: verify/utils/bititers_bitsubseteq_descending_test_.nim
---
