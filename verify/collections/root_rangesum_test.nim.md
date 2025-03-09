---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/root_rangesum.nim
    title: cplib/collections/root_rangesum.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/root_rangesum.nim
    title: cplib/collections/root_rangesum.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/point_add_range_sum
    links:
    - https://judge.yosupo.jp/problem/point_add_range_sum
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/point_add_range_sum\n\
    import sequtils, strutils\nimport cplib/collections/root_rangesum\n\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n\nvar N, Q = ii()\nvar A = newSeqWith(N, ii())\nvar st\
    \ = initrangesum(A)\nfor i in 0..<Q:\n    var T = ii()\n    if T == 0:\n     \
    \   var p, x = ii()\n        st[p] = st[p] + x\n    else:\n        var l, r =\
    \ ii()\n        echo st[l..<r]\n"
  dependsOn:
  - cplib/collections/root_rangesum.nim
  - cplib/collections/root_rangesum.nim
  isVerificationFile: true
  path: verify/collections/root_rangesum_test.nim
  requiredBy: []
  timestamp: '2024-08-17 04:11:20+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/root_rangesum_test.nim
layout: document
redirect_from:
- /verify/verify/collections/root_rangesum_test.nim
- /verify/verify/collections/root_rangesum_test.nim.html
title: verify/collections/root_rangesum_test.nim
---
