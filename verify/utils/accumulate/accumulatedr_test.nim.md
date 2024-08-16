---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/accumulate.nim
    title: cplib/utils/accumulate.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/accumulate.nim
    title: cplib/utils/accumulate.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/static_range_sum
    links:
    - https://judge.yosupo.jp/problem/static_range_sum
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/static_range_sum\n\
    \nimport cplib/utils/accumulate\nimport sequtils\n\nproc scanf(formatstr: cstring){.header:\
    \ \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr\
    \ result)\n\nvar N,Q = ii()\nvar a = (newseqwith(N,ii())).accumulatedr(a+b,0)\n\
    \nfor i in 0..<Q:\n    var l = ii()\n    var r = ii()\n    echo a[l]-a[r]"
  dependsOn:
  - cplib/utils/accumulate.nim
  - cplib/utils/accumulate.nim
  isVerificationFile: true
  path: verify/utils/accumulate/accumulatedr_test.nim
  requiredBy: []
  timestamp: '2024-08-17 01:24:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/accumulate/accumulatedr_test.nim
layout: document
redirect_from:
- /verify/verify/utils/accumulate/accumulatedr_test.nim
- /verify/verify/utils/accumulate/accumulatedr_test.nim.html
title: verify/utils/accumulate/accumulatedr_test.nim
---
